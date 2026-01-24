/// User's choice for resolving a duplicate password entry.
enum DuplicateResolutionChoice {
  /// Keep the existing password entry in PassVault, discard the imported one
  keepExisting,

  /// Replace the existing password entry with the imported one
  replaceWithNew,

  /// Keep both entries (imported entry will get a modified appName)
  keepBoth,
}
