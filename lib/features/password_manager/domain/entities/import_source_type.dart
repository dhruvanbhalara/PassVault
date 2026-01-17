/// Enum representing supported password import sources.
///
/// Each source has a different CSV/JSON format with unique column headers
/// and field mappings. The parser factory uses this enum to select the
/// appropriate parser implementation.
enum ImportSourceType {
  /// Google Chrome password export (3 columns: url, username, password)
  chrome,

  /// Mozilla Firefox password export (9 columns including metadata)
  firefox,

  /// Microsoft Edge password export (same format as Chrome)
  edge,

  /// Apple Safari password export (similar to Chrome)
  safari,

  /// Bitwarden password manager export (11 columns with folders and TOTP)
  bitwarden,

  /// 1Password password manager export
  onePassword,

  /// LastPass password manager export
  lastPass,

  /// Generic CSV fallback with intelligent header detection
  generic;

  /// Human-readable display name for UI
  String get displayName {
    switch (this) {
      case ImportSourceType.chrome:
        return 'Google Chrome';
      case ImportSourceType.firefox:
        return 'Mozilla Firefox';
      case ImportSourceType.edge:
        return 'Microsoft Edge';
      case ImportSourceType.safari:
        return 'Apple Safari';
      case ImportSourceType.bitwarden:
        return 'Bitwarden';
      case ImportSourceType.onePassword:
        return '1Password';
      case ImportSourceType.lastPass:
        return 'LastPass';
      case ImportSourceType.generic:
        return 'Generic CSV';
    }
  }

  /// Convert from string value (for persistence/parsing)
  static ImportSourceType? fromString(String value) {
    try {
      return ImportSourceType.values.firstWhere(
        (type) => type.name.toLowerCase() == value.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
