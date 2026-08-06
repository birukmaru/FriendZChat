# ─── Flutter / Freezed / Riverpod ────────────────────────────────────────────
-keep class com.privatecall.app.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ─── Dio ────────────────────────────────────────────────────────────────────
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# ─── Hive ────────────────────────────────────────────────────────────────────
-keep class **.HiveType { *; }
-keep class **.HiveField { *; }
-keepclassmembers class * extends io.flutter.embedding.android.FlutterActivity { *; }

# ─── Mobile Scanner (camera) ────────────────────────────────────────────────
-keep class dev.steenbakker.mobile_scanner.** { *; }

# ─── General ────────────────────────────────────────────────────────────────
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-renamesourcefileattribute SourceFile
-dontwarn javax.annotation.**

# Obfuscation policy — keep models serializable.
-keep,allowobfuscation,allowshrinking class kotlin.Metadata
-keep,allowobfuscation,allowshrinking class kotlinx.serialization.**

# ─── Google Play Core (deferred components) ──────────────────────────────────
# Flutter's embedding references these classes for Play Store deferred
# component support. If you're NOT distributing via Play Store with
# deferred components (sideloading, direct APK, alternative stores)
# the classes are absent at runtime — tell R8 not to fail because of
# them.
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.**
-dontwarn io.flutter.embedding.android.FlutterPlayStoreSplitApplication
-dontwarn io.flutter.embedding.engine.deferredcomponents.**