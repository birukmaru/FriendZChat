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