import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:payment/services/Bloc.dart';
import 'package:payment/utility/jwt.dart';
import 'package:payment/models/store.dart';
import 'package:payment/models/Payments.dart';
import 'package:payment/models/Leave.dart';

void main() {
  group('apirepository', () {
    late apirepository repository;

    setUp(() {
      repository = apirepository();
    });

    test('store_getdata should return data if successful', () async {
      // Setup
      final mockId = '123';
      final mockResponse = {
        'status': true,
        'data': [{'id': '1', 'name': 'Store 1'}, {'id': '2', 'name': 'Store 2'}]
      };
      final mockJwt = JWT();
      repository.uploadURL = 'http://example.com';
      repository.jwt = mockJwt;
      final mockToken = 'mock-token';
      final mockGetResponse = http.Response(jsonEncode(mockResponse), 200);
      when(() => mockJwt.read_token()).thenAnswer((_) async => mockToken);
      when(() => http.get(
            Uri.parse('http://example.com/store/getdata/$mockId'),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => mockGetResponse);

      // Execution
      final result = await repository.store_getdata(mockId);

      // Verification
      expect(result, isA<List<Store>>());
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].name, 'Store 1');
      expect(result[1].id, '2');
      expect(result[1].name, 'Store 2');
      verify(() => mockJwt.read_token()).called(1);
      verify(() => http.get(
            Uri.parse('http://example.com/store/getdata/$mockId'),
            headers: {
              'x-access-token': mockToken,
            },
          )).called(1);
    });

    
  });
}
