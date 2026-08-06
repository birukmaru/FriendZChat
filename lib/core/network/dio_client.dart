/// Configured [Dio] client used by all remote data sources.
///
/// Adds interceptors for logging, auth tokens, and SSL pinning hooks.
library;

import 'package:dio/dio.dart';

import 'package:friendzchat/core/constants/app_constants.dart';
import 'package:friendzchat/utils/logger.dart';

typedef TokenProvider = Future<String?> Function();

/// Builds and configures a [Dio] instance.
abstract interface class DioClient {
  Dio get dio;
  void setAuthToken(String? token);
  void setBaseUrl(String url);
}

class DioClientImpl implements DioClient {
  DioClientImpl({
    String? baseUrl,
    TokenProvider? tokenProvider,
    bool enableLogging = true,
  })  : _tokenProvider = tokenProvider,
        dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? AppConstants.defaultBaseUrl,
            connectTimeout: AppConstants.connectTimeout,
            receiveTimeout: AppConstants.networkTimeout,
            sendTimeout: AppConstants.networkTimeout,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'X-App-Platform': 'flutter',
            },
          ),
        ) {
    dio.interceptors.add(_AuthInterceptor(this));
    dio.interceptors.add(_RetryInterceptor(dio));
    if (enableLogging) {
      dio.interceptors.add(_LogInterceptor());
    }
  }

  final TokenProvider? _tokenProvider;
  String? _authToken;

  @override
  final Dio dio;

  @override
  void setAuthToken(String? token) {
    _authToken = token;
  }

  @override
  void setBaseUrl(String url) {
    dio.options.baseUrl = url;
  }

  String? get _token => _authToken;

  // ─── Interceptors ──────────────────────────────────────────────────────────

  Future<String?> _resolveToken() async =>
      _token ?? await _tokenProvider?.call();
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._client);

  final DioClientImpl _client;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _client._resolveToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class _RetryInterceptor extends Interceptor {
  _RetryInterceptor(this._dio);

  final Dio _dio;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final attempt = (err.requestOptions.extra['retry'] as int?) ?? 0;
    if (!_shouldRetry(err) || attempt >= AppConstants.maxRetries) {
      return handler.next(err);
    }
    err.requestOptions.extra['retry'] = attempt + 1;
    await Future<void>.delayed(Duration(milliseconds: 300 * (attempt + 1)));
    try {
      final response = await _dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null &&
            err.response!.statusCode! >= 500 &&
            err.response!.statusCode! < 600);
  }
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d(
      '→ ${options.method} ${options.uri}'
      '${options.data == null ? '' : ' | body=${options.data}'}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.d(
      '← ${response.statusCode} ${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.w(
      '✗ ${err.requestOptions.method} ${err.requestOptions.uri} '
      '(${err.type}) ${err.response?.statusCode ?? "-"} ${err.message ?? ""}',
    );
    handler.next(err);
  }
}

/// Placeholder for production SSL pinning — wire to your certificate chain.
///
/// Example:
/// ```dart
/// installCertificatePinning(dio, ['sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=']);
/// ```
///
/// See [Dio HTTP client adapters](https://pub.dev/packages/dio#http-client-adapters)
/// for the recommended setup.
void installCertificatePinning(Dio dio, List<String> sha256Hashes) {
  // Intentionally a no-op in this skeleton.  Implement with your project's
  // pinning strategy when the backend certificate chain is known.
  // ignore: unused_local_variable
  final _ = sha256Hashes;
}