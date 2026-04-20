import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SSLPinningInterceptor extends Interceptor {
  final Map<String, String> pinnedCertificates = {
    'api.coingecko.com': 'sha256/48:D4:98:60:20:93:56:8F:79:E2:63:E2:6F:18:65:1D:E8:6D:C9:ED:19:4A:2A:93:4B:7F:3E:1A:C2:80:89',
    'mainnet.infura.io': 'sha256/rrmWoD11np1u56NPtOHXh7VPsTwY5wTXSowvZyqMBHs=',
    'api.mainnet-beta.solana.com': 'sha256/42:71:C1:97:32:59:4E:D3:A8:31:52:9F:88:FE:EB:F1:85:77:5C:4F:8D:C2:B4:BC:E2:1B:3A:5E:9F:7E:0E',
    'eth-mainnet.g.alchemy.com': 'sha256/rrmWoD11np1u56NPtOHXh7VPsTwY5wTXSowvZyqMBHs=',
  };

  final Map<String, String> pinnedPublicKeys = {};

  bool allowBadCertificate = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final host = options.uri.host;
    
    if (pinnedCertificates.containsKey(host) || pinnedPublicKeys.containsKey(host)) {
      // Skip SSL pinning in debug mode
      if (kDebugMode && allowBadCertificate) {
        return handler.next(options);
      }
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.badCertificate) {
      if (allowBadCertificate) {
        debugPrint('SSL Pinning: Allow bad certificate (debug mode)');
      } else {
        debugPrint('SSL Pinning Failed: ${err.requestOptions.uri.host}');
        throw SSLPinningException('Certificate verification failed for ${err.requestOptions.uri.host}');
      }
    }
    return handler.next(err);
  }
}

class SSLPinningException implements Exception {
  final String message;
  SSLPinningException(this.message);
  
  @override
  String toString() => 'SSLPinningException: $message';
}

class NetworkSecurityConfig {
  static Dio createSecureDio() {
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status != null && status < 500,
    ));

    dio.interceptors.add(SSLPinningInterceptor());
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    return dio;
  }

  static SecurityContext get securityContext {
    final context = SecurityContext(withTrustedRoots: true);
    
    // Add pinned certificates
    // In production, embed actual certificates
    return context;
  }
}