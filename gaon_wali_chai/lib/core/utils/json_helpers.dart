/// Helper functions for safe JSON parsing

/// Safely parse an integer from JSON, handling null and string "null"
int? parseIntOrNull(dynamic value) {
  if (value == null || value.toString() == 'null' || value.toString().isEmpty) {
    return null;
  }
  return int.parse(value.toString());
}

/// Safely parse an integer from JSON with default value
int parseInt(dynamic value, {int defaultValue = 0}) {
  if (value == null || value.toString() == 'null' || value.toString().isEmpty) {
    return defaultValue;
  }
  return int.parse(value.toString());
}

/// Safely parse a double from JSON, handling null and string "null"
double? parseDoubleOrNull(dynamic value) {
  if (value == null || value.toString() == 'null' || value.toString().isEmpty) {
    return null;
  }
  return double.parse(value.toString());
}

/// Safely parse a double from JSON with default value
double parseDouble(dynamic value, {double defaultValue = 0.0}) {
  if (value == null || value.toString() == 'null' || value.toString().isEmpty) {
    return defaultValue;
  }
  return double.parse(value.toString());
}

/// Safely parse a boolean from JSON
bool parseBool(dynamic value, {bool defaultValue = false}) {
  if (value == null || value.toString() == 'null') {
    return defaultValue;
  }
  return value == true ||
      value == 1 ||
      value == '1' ||
      value.toString().toLowerCase() == 'true';
}

/// Safely parse a string from JSON
String parseString(dynamic value, {String defaultValue = ''}) {
  if (value == null || value.toString() == 'null') {
    return defaultValue;
  }
  return value.toString();
}

/// Safely parse a nullable string from JSON
String? parseStringOrNull(dynamic value) {
  if (value == null || value.toString() == 'null' || value.toString().isEmpty) {
    return null;
  }
  return value.toString();
}
