int? parseToInt(Object? value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '');
}
