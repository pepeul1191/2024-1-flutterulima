import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:ulimagym/configs/constants.dart';
import 'package:http/http.dart' as http;
import '../models/responses/user_member.dart';

class UserService {
  Future<UserMember?> validate(String user, String password) async {
    String url = "${BASE_URL}user/validate";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['user'] = user;
    request.fields['password'] = password;
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        final UserMember em = UserMember.fromJson(json.decode(responseBody));
        return em;
      } else if (response.statusCode == 404) {
        final UserMember em = UserMember(userId: 0, memberId: 0);
        throw Exception(
            'Usuario y/o contraseña no válidos: ${response.statusCode}');
        return em;
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
        print('ERROORRR!!!');
      }
    } catch (e, stackTrace) {
      print('catch!: $e');
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      print('Error no esperado: $e');
      print(stackTrace);
    }
  }
}
