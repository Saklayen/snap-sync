const _units = ['B', 'KB', 'MB', 'GB', 'TB'];

String formatBytes(int bytes) {
  var value = bytes.toDouble();
  var unit = 0;

  while (value >= 1024 && unit < _units.length - 1) {
    value /= 1024;
    unit++;
  }

  final rounded = value >= 100 || unit == 0
      ? value.round().toString()
      : value.toStringAsFixed(1);

  return '$rounded ${_units[unit]}';
}
