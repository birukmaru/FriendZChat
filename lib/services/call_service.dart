/// Call service abstraction with pluggable transports.
///
/// The default transport is the system dialer (`DialerCallService`), but the
/// same contract is implemented for SIP, VoIP, or a REST backend.  The UI
/// only ever sees [CallService].
library;

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/core/errors/exceptions.dart';
import 'package:friendzchat/utils/logger.dart';

/// Common contract for any call transport.
abstract interface class CallService {
  /// Friendly identifier of the transport — used for logs/UI.
  String get name;

  /// Place a call to [userId]. The service takes care of any prefix needed
  /// (e.g. `8776`).
  Future<CallResult> placeCall({
    required String userId,
    String? displayName,
  });

  /// Hang up an in-flight call (best-effort).
  Future<void> endCall(String callId);
}

class CallResult {
  const CallResult({
    required this.callId,
    required this.destination,
    required this.transport,
    required this.startedAt,
  });

  final String callId;
  final String destination;
  final String transport;
  final DateTime startedAt;
}

/// Default — hands the call off to the OS dialer with the formatted number.
///
/// On Android the call is launched via `tel:` so the dialer opens pre-filled;
/// iOS behaves the same way.  No special permission is required.
class DialerCallService implements CallService {
  DialerCallService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('private_call/dialer');

  final MethodChannel _channel;

  @override
  String get name => 'Dialer';

  @override
  Future<CallResult> placeCall({
    required String userId,
    String? displayName,
  }) async {
    final destination = '${AppConstants.serviceShortCode}$userId';
    final uri = Uri(scheme: 'tel', path: destination);
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) {
        throw PlatformException(
          code: 'NO_HANDLER',
          message: 'No dialer available on this device',
        );
      }
      AppLogger.i('Dialer launched: $destination');
      return CallResult(
        callId: DateTime.now().microsecondsSinceEpoch.toString(),
        destination: destination,
        transport: name,
        startedAt: DateTime.now(),
      );
    } on PlatformException catch (e) {
      AppLogger.e('Dialer launch failed', error: e);
      throw PermissionDeniedException(
        e.message ?? 'Could not launch the dialer',
        cause: e,
      );
    } catch (e) {
      AppLogger.e('Dialer launch failed', error: e);
      throw UnknownException('Could not start the call', cause: e);
    }
  }

  @override
  Future<void> endCall(String callId) async {
    // System dialer doesn't allow programmatic hang-up — best effort log.
    AppLogger.i('Dialer call $callId ended by user');
  }
}

/// Stub implementation for a SIP-based transport — wire to your SIP SDK.
class SipCallService implements CallService {
  SipCallService();

  @override
  String get name => 'SIP';

  @override
  Future<CallResult> placeCall({
    required String userId,
    String? displayName,
  }) async {
    // Replace with the project's SIP library (e.g. flutter_sip).
    AppLogger.w('SipCallService is not configured — falling back to dialer');
    throw const UnknownException('SIP transport not configured');
  }

  @override
  Future<void> endCall(String callId) async {}
}

/// Stub implementation for VoIP (e.g. WebRTC) — wire to your VoIP SDK.
class VoipCallService implements CallService {
  VoipCallService();

  @override
  String get name => 'VoIP';

  @override
  Future<CallResult> placeCall({
    required String userId,
    String? displayName,
  }) async {
    throw const UnknownException('VoIP transport not configured');
  }

  @override
  Future<void> endCall(String callId) async {}
}

/// Stub implementation for a backend REST call — wire to your server.
class RestCallService implements CallService {
  RestCallService();

  @override
  String get name => 'REST';

  @override
  Future<CallResult> placeCall({
    required String userId,
    String? displayName,
  }) async {
    throw const UnknownException('REST call transport not configured');
  }

  @override
  Future<void> endCall(String callId) async {}
}