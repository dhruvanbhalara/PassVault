# Flutter ProGuard Rules

# Keep Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Hive
-keep class hive.** { *; }
-keep class * extends hive.TypeAdapter { *; }

# Keep Flutter Secure Storage
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Keep Local Auth
-keep class androidx.biometric.** { *; }

# Prevent stripping of native Flutter classes
-dontwarn io.flutter.embedding.**

# General optimization
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose
