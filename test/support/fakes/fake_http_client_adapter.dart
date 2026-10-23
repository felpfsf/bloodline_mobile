import 'dart:typed_data';

import 'package:dio/dio.dart';

final class FakeHttpClientAdapter implements HttpClientAdapter {
  FakeHttpClientAdapter(this.statusCode);

  final int statusCode;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString('{}', statusCode);
  }

  @override
  void close({bool force = false}) {}
}
