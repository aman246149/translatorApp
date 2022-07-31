import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:translation/app/model/translation_model.dart';
import 'package:translation/global/errors/custom_error.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class TranslationApi {
  static Future<Either<CustomError, String>> convertText(
      String text, List<String> to) async {
    String uid = const Uuid().v4();
    String key = "949e6c11f7e043949cc750ed6a848774";

    String url = "https://api.cognitive.microsofttranslator.com";
    String region = "EastUS2";

    TranslationModel data = TranslationModel(text: text);
    List<Map<String, dynamic>> listdata = [];

    var mapData = TranslationModel.toMap(data);
    listdata.add(mapData);
    final uri = Uri.parse('$url/translate').replace(
        queryParameters: {'api-version': '3.0', 'from': 'en', 'to': to});

    try {
      final response = await http.post(uri,
          headers: {
            'Ocp-Apim-Subscription-Key': key,
            'Ocp-Apim-Subscription-Region': region,
            'Content-type': 'application/json',
            'X-ClientTraceId': uid
          },
          body: jsonEncode(listdata));

      var decodedJson = jsonDecode(response.body);
      return Right(decodedJson[0]["translations"][0]["text"]);
    } catch (e) {
      return Left(CustomError(message: e.toString()));
    }
  }
}
