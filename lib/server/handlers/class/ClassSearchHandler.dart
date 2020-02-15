import 'package:WVS_School_Class_Service/framework/model/class/WVSClass.dart';
import 'package:WVS_School_Class_Service/framework/model/response/ResponseModel.dart';
import 'package:WVS_School_Class_Service/server/handlers/base/ServerHandler.dart';
import 'package:WVS_School_Class_Service/server/handlers/class/ClassHandler.dart';

class ClassSearchHandler extends ServerHandler {
  final String searchString;

  ClassSearchHandler({this.searchString});

  @override
  Future<ResponseModel> createResponse() async {
    var classHandler = ClassHandler();

    var classes = await classHandler.parseDOM();

    if (searchString == null) {
      return ResponseModel.create(true, classes);
    }

    var newClasses = <WvsClass>[];

    for (var i in classes) {
      if (i.wvsClassClass.startsWith(searchString)) {
        newClasses.add(i);
      }
    }

    if (newClasses.isEmpty) {
      return ResponseModel.create(true, classes);
    }

    return ResponseModel.create(true, newClasses);
  }
}
