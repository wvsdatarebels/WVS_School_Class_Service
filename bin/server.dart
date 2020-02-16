import 'dart:convert';
import 'dart:io';

import 'package:WVS_School_Class_Service/framework/enum/enum_from_string.dart';
import 'package:WVS_School_Class_Service/framework/model/response/ResponseModel.dart';
import 'package:WVS_School_Class_Service/server/handlers/base/ServerHandler.dart';
import 'package:WVS_School_Class_Service/server/handlers/class/ClassHandler.dart';
import 'package:WVS_School_Class_Service/server/handlers/class/ClassSearchHandler.dart';
import 'package:WVS_School_Class_Service/server/routes/routes.dart';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

const _hostname = '0.0.0.0';

void main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);

  // For Google Cloud Run, we respect the PORT environment variable
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '7621';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(_urlHandler);

  var server = await io.serve(handler, InternetAddress(_hostname), port);
  print('Serving at http://${server.address.host}:${server.port}');
}

Future<shelf.Response> _urlHandler(shelf.Request request) async {
  if (request.url.pathSegments.first == 'favicon.ico') return shelf.Response.ok(null);

  EnumFromString converter = EnumFromString<ServerRoutes>();
  ServerRoutes route = converter.get(request.url.pathSegments.last);

  ResponseModel response;
  ServerHandler handler;

  if (request.method != 'GET') {
    return shelf.Response.forbidden(null);
  }

  switch(route) {
    case ServerRoutes.CLASS:
      handler = ClassHandler();
      break;
    case ServerRoutes.CLASS_SEARCH:
      handler = ClassSearchHandler(
        searchString: request.url.queryParameters['query']
      );
      break;
    default:
      handler = null;
      break;
  }

  if (handler == null) {
    return shelf.Response.notFound('Not found path ' + request.url.pathSegments.first + '.');
  }

  response = await handler.createResponse();

  if (response.success) {
    return shelf.Response.ok(json.encode(response));
  } else {
    return shelf.Response.internalServerError();
  }
}
