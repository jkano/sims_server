import 'dart:io';
import 'package:sims_server/outputs.dart';

Future<void> handleRequests(HttpServer server) async {
  await for (HttpRequest request in server) {
    switch (request.method) {
      case 'GET':
        _handleGet(request);
        break;
      case 'POST':
        _handlePost(request);
        break;
      default:
        _handleDefault(request);
    }
  }
}

String myStringStorage = "test";

void _handleGet(HttpRequest request) {
  final path = request.uri.path;

  if (path == '/ws_sims/sims') {
    handleGetSims(request);
  } else {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write("Invalid request")
      ..close();
  }
}

Future<void> _handlePost(HttpRequest request) async {
  final path = request.uri.path;

  if (path == '/ws_sims/getOutputStatus') {
    handleOutputStatus(request);
  } else if (path.contains('ws_sims/setOutput/')) {
    handleSetOutput(request);
  } else if (path.contains('ws_sims/toggleOutput/')) {
    handleToggleOutput(request);
  } else {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write('Invalid request\n/disetron_eoc\r\n')
      ..close();
  }
}

void _handleDefault(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.methodNotAllowed
    ..write('Unsupported request: ${request.method}.')
    ..close();
}
