/// Validators for the private-call service.
library;

/// Pure helpers for validating user inputs that the service cares about.
abstract final class Validators {
  /// A valid FriendZChat user ID is 6 numeric digits.
  static final RegExp _userIdPattern = RegExp(r'^\d{6}$');

  /// Phone numbers (optional) accept E.164 and common national formats.
  static final RegExp _phonePattern = RegExp(r'^\+?[0-9\s\-\(\)]{6,20}$');

  /// OTP pattern (4–6 digits).
  static final RegExp _otpPattern = RegExp(r'^\d{4,6}$');

  /// Returns `true` if [value] looks like a valid FriendZChat user ID.
  static bool isUserId(String? value) {
    if (value == null) return false;
    return _userIdPattern.hasMatch(value.trim());
  }

  /// Returns `true` if [value] looks like a phone number.
  static bool isPhoneNumber(String? value) {
    if (value == null) return false;
    return _phonePattern.hasMatch(value.trim());
  }

  /// Returns `true` if [value] looks like a valid nickname.
  static bool isNickname(String? value) {
    if (value == null) return false;
    final v = value.trim();
    return v.isNotEmpty && v.length <= 32;
  }

  /// Returns `true` if [value] is non-empty.
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Returns `true` if [value] is a plausible OTP (4–6 digits).
  static bool isOtp(String? value) {
    if (value == null) return false;
    return _otpPattern.hasMatch(value.trim());
  }
}

/// User-friendly validators that surface to the form layer.
abstract final class FormValidators {
  static FormFieldValidator<String> userId({String message = 'Enter a 6-digit ID'}) {
    return (value) {
      if (value == null || value.trim().isEmpty) return 'User ID is required';
      if (!Validators.isUserId(value)) return message;
      return null;
    };
  }

  static FormFieldValidator<String> nickname({String message = '1–32 characters'}) {
    return (value) {
      if (value == null || value.trim().isEmpty) return 'Nickname is required';
      if (!Validators.isNickname(value)) return message;
      return null;
    };
  }

  static FormFieldValidator<String> optionalPhone() {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!Validators.isPhoneNumber(value)) return 'Enter a valid phone number';
      return null;
    };
  }

  static FormFieldValidator<String> otp() {
    return (value) {
      if (value == null || value.isEmpty) return 'OTP is required';
      if (!Validators.isOtp(value)) return 'Enter a 4–6 digit code';
      return null;
    };
  }
}

typedef FormFieldValidator<T> = String? Function(T? value);