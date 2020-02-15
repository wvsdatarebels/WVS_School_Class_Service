import 'dart:io';

import 'package:WVS_School_Class_Service/framework/model/response/ResponseModel.dart';

abstract class ServerHandler {
  Future<ResponseModel> createResponse() async {
    return ResponseModel.create(false, 'No handler has been found');
  }

  void sendErrorLog() {
    stdout.writeln('An error has been occurred on a Server Handler');
  }
}
