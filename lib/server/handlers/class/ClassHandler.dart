import 'dart:convert';

import 'package:WVS_School_Class_Service/framework/model/class/WVSClass.dart';
import 'package:WVS_School_Class_Service/framework/model/response/ResponseModel.dart';
import 'package:WVS_School_Class_Service/server/handlers/base/ServerHandler.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class ClassHandler extends ServerHandler {

  static const _tableURL = 'https://wvs-ffm.de/dateien/plaene/stundenplan1/index.htm';

  Future<List<WvsClass>> parseDOM() async {
    var response = await http.get(_tableURL);
    var parsedDocument = parse(response.body);
    var tableRows = parsedDocument.getElementsByTagName('table')[1].getElementsByTagName('tr');

    var generated = <WvsClass>[];

    for (var i in tableRows) {
      var cells = i.getElementsByTagName('td');

      for (var a in cells) {

        // ignore: unrelated_type_equality_checks
        if (a.innerHtml != null || a.innerHtml != []) {
          var element = a.getElementsByTagName('a');

          if (element.isNotEmpty) {
            var finalText = element[0].text;

            generated.add(WvsClass.create(
                finalText,
                'https://wvs-ffm.de/dateien/plaene/stundenplan1/index_' + finalText + '.htm'
            ));
          }
        }
      }
    }

    print(generated);

    return generated;
  }

  @override
  Future<ResponseModel> createResponse() async {
    try {
      return ResponseModel.create(true, await parseDOM());
    } catch (e) {
      return ResponseModel.create(true, e.toString());
    }
  }
}
