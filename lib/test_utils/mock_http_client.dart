import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {
  MockClient({
    required this.mockedResult,
    this.mockedStatus = 200,
  });

  final Map<String, dynamic> mockedResult;
  final int mockedStatus;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return Future<http.StreamedResponse>.value(
      http.StreamedResponse(
        Stream.value(utf8.encode(jsonEncode(mockedResult))),
        mockedStatus,
      ),
    );
  }
}
