import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class CustomValidator {
  CustomValidator._();

  // ===========================================================================
  // REGEX
  // ===========================================================================

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9.!#$%&''*+/=?^_`{|}~-]+@'
    r'[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?'
    r'(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+$',
  );

  /// Vietnamese mobile number after normalization:
  /// +84 + 9 digits, starting with 3, 5, 7, 8 or 9.
  static final RegExp _vietnamPhoneRegex = RegExp(
    r'^\+84[35789]\d{8}$',
  );

  static final RegExp _upperCaseRegex = RegExp(r'[A-Z]');
  static final RegExp _lowerCaseRegex = RegExp(r'[a-z]');
  static final RegExp _digitRegex = RegExp(r'\d');
  static final RegExp _specialCharacterRegex =
      RegExp(r'''[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>/?`~]''');

  // ===========================================================================
  // REQUIRED
  // ===========================================================================

  static String? validateRequired(
    String? value, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  // ===========================================================================
  // NAME
  // ===========================================================================

  static String? validateName(
    String? value, {
    String fieldName = 'Name',
    int minLength = 2,
    int maxLength = 100,
    bool isRequired = true,
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return isRequired ? '$fieldName is required' : null;
    }

    if (text.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    if (text.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }

    return null;
  }

  // ===========================================================================
  // EMAIL
  // ===========================================================================

  static String? validateEmail(
    String? value, {
    bool isRequired = true,
  }) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return isRequired ? 'Email is required' : null;
    }

    // Practical maximum length defined for an email address.
    if (email.length > 254) {
      return 'Email is invalid';
    }

    if (email.contains('..')) {
      return 'Email is invalid';
    }

    final atIndex = email.indexOf('@');

    if (atIndex <= 0 || atIndex != email.lastIndexOf('@')) {
      return 'Email is invalid';
    }

    final localPart = email.substring(0, atIndex);

    if (localPart.length > 64 ||
        localPart.startsWith('.') ||
        localPart.endsWith('.')) {
      return 'Email is invalid';
    }

    if (!_emailRegex.hasMatch(email)) {
      return 'Email is invalid';
    }

    return null;
  }

  // ===========================================================================
  // PASSWORD
  // ===========================================================================

  static String? validatePassword(
    String? value, {
    int minLength = 8,
    int maxLength = 128,
    bool isRequired = true,
  }) {
    final password = value ?? '';

    if (password.isEmpty) {
      return isRequired ? 'Password is required' : null;
    }

    if (password.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    if (password.length > maxLength) {
      return 'Password must not exceed $maxLength characters';
    }

    if (password.contains(RegExp(r'\s'))) {
      return 'Password must not contain spaces';
    }

    if (!_upperCaseRegex.hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!_lowerCaseRegex.hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!_digitRegex.hasMatch(password)) {
      return 'Password must contain at least one number';
    }

    if (!_specialCharacterRegex.hasMatch(password)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  // ===========================================================================
  // PHONE
  // ===========================================================================

  static String? validatePhone(
    String? value, {
    bool isRequired = true,
  }) {
    final rawPhone = value?.trim() ?? '';

    if (rawPhone.isEmpty) {
      return isRequired ? 'Phone number is required' : null;
    }

    final result = parseVietnamPhone(rawPhone);

    if (!result.isValid) {
      return 'Phone number is invalid';
    }

    return null;
  }

  static PhoneValidationResult parseVietnamPhone(String value) {
    final input = value.trim();

    if (input.isEmpty) {
      return const PhoneValidationResult(
        isValid: false,
        normalizedPhone: '',
      );
    }

    try {
      // Allow common user input:
      // 0901234567
      // +84901234567
      // 84 901 234 567
      // 090 123 4567
      // 090-123-4567
      final cleaned = input.replaceAll(
        RegExp(r'[\s().-]'),
        '',
      );

      String normalized;

      if (cleaned.startsWith('+84')) {
        normalized = cleaned;
      } else if (cleaned.startsWith('84')) {
        normalized = '+$cleaned';
      } else if (cleaned.startsWith('0')) {
        normalized = '+84${cleaned.substring(1)}';
      } else {
        // Treat a 9-digit Vietnamese mobile number as national
        // significant number.
        normalized = '+84$cleaned';
      }

      final parsed = PhoneNumber.parse(normalized);

      final e164 = '+${parsed.countryCode}${parsed.nsn}';

      final isValid =
          parsed.isoCode == IsoCode.VN &&
          _vietnamPhoneRegex.hasMatch(e164);

      return PhoneValidationResult(
        isValid: isValid,
        normalizedPhone: e164,
      );
    } catch (_) {
      return PhoneValidationResult(
        isValid: false,
        normalizedPhone: input,
      );
    }
  }

  // ===========================================================================
  // ADDRESS
  // ===========================================================================

  static String? validateAddress(
    String? value, {
    int minLength = 5,
    int maxLength = 255,
    bool isRequired = true,
  }) {
    return validateLength(
      value,
      fieldName: 'Address',
      minLength: minLength,
      maxLength: maxLength,
      isRequired: isRequired,
    );
  }

  // ===========================================================================
  // GENERIC LENGTH
  // ===========================================================================

  static String? validateLength(
    String? value, {
    required String fieldName,
    int? minLength,
    int? maxLength,
    bool isRequired = true,
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return isRequired ? '$fieldName is required' : null;
    }

    if (minLength != null && text.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    if (maxLength != null && text.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }

    return null;
  }

  // ===========================================================================
  // URL
  // ===========================================================================

  static String? validateUrl(
    String? value, {
    String fieldName = 'URL',
    bool isRequired = false,
  }) {
    final url = value?.trim() ?? '';

    if (url.isEmpty) {
      return isRequired ? '$fieldName is required' : null;
    }

    final uri = Uri.tryParse(url);

    if (uri == null ||
        !uri.hasScheme ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      return '$fieldName is invalid';
    }

    return null;
  }

  // ===========================================================================
  // CONFIRM PASSWORD
  // ===========================================================================

  static String? validateConfirmPassword(
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }
}

class PhoneValidationResult {
  final bool isValid;
  final String normalizedPhone;

  const PhoneValidationResult({
    required this.isValid,
    required this.normalizedPhone,
  });
}