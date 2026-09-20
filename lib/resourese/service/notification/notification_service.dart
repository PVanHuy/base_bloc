import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:somics_os/utils/app_constants.dart';
import 'package:somics_os/utils/logger_helper.dart';

import 'background_service.dart';

class NotificationService {
  NotificationService();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSub;
  StreamSubscription<String>? _onTokenRefreshSub;

  bool _initialized = false;
  bool _initialMessageHandled = false;

  /// Prevents the same notification from being handled multiple times
  /// during the current application process.
  String? _lastHandledMessageId;

  // ===========================================================================
  // INITIALIZATION
  // ===========================================================================

  Future<void> onInit() async {
    if (_initialized) {
      return;
    }

    _initialized = true;

    try {
      await _initializeLocalNotification();

      _registerFirebaseListeners();

      loggerHelper.success(
        'Notification service initialized',
        name: 'NotificationService',
      );
    } catch (e) {
      _initialized = false;

      loggerHelper.error(
        'Notification service initialization failed: $e',
        name: 'NotificationService',
      );
    }
  }

  Future<void> _initializeLocalNotification() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestSoundPermission: false,
        requestBadgePermission: false,
      ),
      macOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestSoundPermission: false,
        requestBadgePermission: false,
      ),
    );

    await _plugin.initialize(
      settings,
      onDidReceiveBackgroundNotificationResponse:
          onNotificationTapBackground,
      onDidReceiveNotificationResponse:
          onDidReceiveNotificationResponse,
    );

    await _createAndroidNotificationChannel();
  }

  void _registerFirebaseListeners() {
    _onMessageOpenedAppSub =
        FirebaseMessaging.onMessageOpenedApp.listen(
      _handleRemoteMessage,
      onError: (Object error) {
        loggerHelper.error(
          'FCM onMessageOpenedApp error: $error',
          name: 'NotificationService',
        );
      },
    );

    _onMessageSub = FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
      onError: (Object error) {
        loggerHelper.error(
          'FCM onMessage error: $error',
          name: 'NotificationService',
        );
      },
    );

    _onTokenRefreshSub = _messaging.onTokenRefresh.listen(
      (_) {
        // Do not log the actual token.
        loggerHelper.logBlue(
          'FCM token refreshed',
          name: 'NotificationService',
        );

        // TODO:
        // Send the refreshed token to SOMICS OS backend
        // when the backend contract is available.
      },
      onError: (Object error) {
        loggerHelper.error(
          'FCM token refresh error: $error',
          name: 'NotificationService',
        );
      },
    );
  }

  // ===========================================================================
  // PERMISSION
  // ===========================================================================

  Future<bool> onRequestPermission() async {
    try {
      if (Platform.isAndroid) {
        return await _requestAndroidPermission();
      }

      if (Platform.isIOS || Platform.isMacOS) {
        return await _requestApplePermission();
      }

      return false;
    } catch (e) {
      loggerHelper.error(
        'Notification permission error: $e',
        name: 'NotificationService',
      );

      return false;
    }
  }

  Future<bool> _requestAndroidPermission() async {
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) {
      return false;
    }

    final granted =
        await androidPlugin.requestNotificationsPermission();

    return granted ?? false;
  }

  Future<bool> _requestApplePermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final granted =
        settings.authorizationStatus ==
            AuthorizationStatus.authorized ||
        settings.authorizationStatus ==
            AuthorizationStatus.provisional;

    loggerHelper.logBlue(
      'Notification permission status: '
      '${settings.authorizationStatus.name}',
      name: 'NotificationService',
    );

    return granted;
  }

  // ===========================================================================
  // ANDROID CHANNEL
  // ===========================================================================

  Future<void> _createAndroidNotificationChannel() async {
    if (!Platform.isAndroid) {
      return;
    }

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) {
      return;
    }

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        AppConstants.notificationChannelId,
        'SOMICS OS Notifications',
        description:
            'General notifications from SOMICS OS.',
        importance: Importance.high,
      ),
    );
  }

  // ===========================================================================
  // FCM TOKEN
  // ===========================================================================

  Future<String?> getFcmToken() async {
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        await onRequestPermission();

        // APNs must normally be available before FCM can provide
        // a registration token on Apple platforms.
        final apnsToken = await _messaging.getAPNSToken();

        if (apnsToken == null) {
          loggerHelper.logBlue(
            'APNs token is not available yet',
            name: 'NotificationService',
          );
        }
      }

      final token = await _messaging.getToken();

      if (token != null) {
        loggerHelper.logBlue(
          'FCM token received',
          name: 'NotificationService',
        );
      }

      // Never log the actual FCM token.
      return token;
    } catch (e) {
      loggerHelper.error(
        'Error getting FCM token: $e',
        name: 'NotificationService',
      );

      return null;
    }
  }

  // ===========================================================================
  // INITIAL NOTIFICATION
  // ===========================================================================

  /// Call once after application initialization.
  ///
  /// Handles the notification responsible for launching the application
  /// from a terminated state.
  Future<void> onHandleInitialMessage() async {
    if (_initialMessageHandled) {
      return;
    }

    _initialMessageHandled = true;

    try {
      // Notification delivered directly through Firebase Messaging.
      final initialMessage =
          await _messaging.getInitialMessage();

      if (initialMessage != null) {
        await _handleRemoteMessage(initialMessage);
        return;
      }

      // Notification displayed through flutter_local_notifications.
      final launchDetails =
          await _plugin.getNotificationAppLaunchDetails();

      if (launchDetails?.didNotificationLaunchApp != true) {
        return;
      }

      final response = launchDetails?.notificationResponse;

      if (response == null) {
        return;
      }

      onDidReceiveNotificationResponse(response);
    } catch (e) {
      loggerHelper.error(
        'Error handling initial notification: $e',
        name: 'NotificationService',
      );
    }
  }

  // ===========================================================================
  // FOREGROUND MESSAGE
  // ===========================================================================

  Future<void> _handleForegroundMessage(
    RemoteMessage message,
  ) async {
    loggerHelper.logWhite(
      'FCM foreground message received',
      name: 'NotificationService',
    );

    // Do not execute notification click/navigation logic here.
    //
    // Foreground messages are displayed as local notifications.
    // Business handling occurs when the user actually taps them.
    if (message.notification != null) {
      await showNotification(message);
    }

    // TODO:
    // Dispatch realtime data refresh/update to the appropriate BLoC
    // when SOMICS OS notification contracts are defined.
  }

  // ===========================================================================
  // REMOTE NOTIFICATION TAP
  // ===========================================================================

  Future<void> _handleRemoteMessage(
    RemoteMessage message,
  ) async {
    final messageId = message.messageId;

    if (_isDuplicateMessage(messageId)) {
      loggerHelper.logBlue(
        'Ignored duplicated notification',
        name: 'NotificationService',
      );

      return;
    }

    _rememberMessage(messageId);

    onHandleNotification(message.data);
  }

  bool _isDuplicateMessage(String? messageId) {
    if (messageId == null || messageId.isEmpty) {
      return false;
    }

    return _lastHandledMessageId == messageId;
  }

  void _rememberMessage(String? messageId) {
    if (messageId == null || messageId.isEmpty) {
      return;
    }

    _lastHandledMessageId = messageId;
  }

  // ===========================================================================
  // LOCAL NOTIFICATION
  // ===========================================================================

  Future<void> showNotification(
    RemoteMessage message,
  ) async {
    final notification = message.notification;

    if (notification == null) {
      return;
    }

    try {
      await _plugin.show(
        message.messageId?.hashCode ??
            notification.hashCode,
        notification.title ?? '',
        notification.body ?? '',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.notificationChannelId,
            'SOMICS OS Notifications',
            channelDescription:
                'General notifications from SOMICS OS.',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentBadge: true,
            presentAlert: true,
            presentSound: true,
          ),
          macOS: DarwinNotificationDetails(
            presentBadge: true,
            presentAlert: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode({
          'messageId': message.messageId,
          'data': message.data,
        }),
      );
    } catch (e) {
      loggerHelper.error(
        'Error showing notification: $e',
        name: 'NotificationService',
      );
    }
  }

  // ===========================================================================
  // LOCAL NOTIFICATION TAP
  // ===========================================================================

  void onDidReceiveNotificationResponse(
    NotificationResponse response,
  ) {
    try {
      final rawPayload = response.payload;

      if (rawPayload == null || rawPayload.isEmpty) {
        return;
      }

      final decoded = jsonDecode(rawPayload);

      if (decoded is! Map<String, dynamic>) {
        return;
      }

      final messageId =
          decoded['messageId']?.toString();

      if (_isDuplicateMessage(messageId)) {
        loggerHelper.logBlue(
          'Ignored duplicated local notification',
          name: 'NotificationService',
        );

        return;
      }

      final rawData = decoded['data'];

      if (rawData is! Map) {
        return;
      }

      final data = Map<String, dynamic>.from(rawData);

      _rememberMessage(messageId);

      onHandleNotification(data);
    } catch (e) {
      loggerHelper.error(
        'Invalid notification payload: $e',
        name: 'NotificationService',
      );
    }
  }

  // ===========================================================================
  // NOTIFICATION BUSINESS HANDLER
  // ===========================================================================

  void onHandleNotification(
    Map<String, dynamic> payload,
  ) {
    loggerHelper.logWhite(
      'Notification selected',
      name: 'NotificationService',
    );

    try {
      // SOMICS OS notification contract has not been defined yet.
      //
      // Do NOT reuse notification payload fields from the previous
      // application.
      //
      // Example future flow:
      //
      // final type = payload['type'];
      //
      // switch (type) {
      //   case 'device':
      //     ...
      //
      //   case 'emergency_broadcast':
      //     ...
      //
      //   default:
      //     break;
      // }

      loggerHelper.logBlue(
        'Notification payload received',
        name: 'NotificationService',
      );
    } catch (e) {
      loggerHelper.error(
        'Error handling notification: $e',
        name: 'NotificationService',
      );
    }
  }

  // ===========================================================================
  // DISPOSE
  // ===========================================================================

  Future<void> onClose() async {
    await _onTokenRefreshSub?.cancel();
    await _onMessageSub?.cancel();
    await _onMessageOpenedAppSub?.cancel();

    _onTokenRefreshSub = null;
    _onMessageSub = null;
    _onMessageOpenedAppSub = null;

    _initialized = false;
    _initialMessageHandled = false;
    _lastHandledMessageId = null;
  }
}