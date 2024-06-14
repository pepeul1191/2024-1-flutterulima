
import 'dart:convert';

import 'package:ulimagym/configs/constants.dart';
import 'package:http/http.dart' as http;
import '../models/entities/BodyPart.dart';

class BodyPartService {
  Future<List<BodyPart>?> fetchAll() async{
    String url = "${BASE_URL}body_part/list";
    List<BodyPart> bodyPartList = [];
    try{
      var response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        final List<dynamic> parsedData = json.decode(response.body);
        bodyPartList = parsedData.map((bodyPartJson) => BodyPart.fromJson(bodyPartJson)).toList();
        return bodyPartList;
      }else{
        print('ERROORRR!!!');
      }
    }catch(e, stackTrace){
      print('Error no esperado: $e');
      print(stackTrace);
    }
  }
}