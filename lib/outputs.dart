import 'dart:convert';
import 'dart:io';

import 'package:sims_server/database/db.dart';

void handleGetSims(HttpRequest request) {
  getSims().then((sims) {
    var simsJson = jsonEncode(sims);

    request.response
      ..write(simsJson)
      ..close();
  });
}

void handleOutputStatus(HttpRequest request) {
  final query = request.uri.query;

  if (query.isEmpty) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write("Empty query parameters")
      ..close();
  }

  var data = query.split(',');

  // Serial Number
  print("Query serial number: ${data[0]}");

  getSimsBySerial(data[0]).then((sims) {
    print("Sims: $sims");
    request.response
      ..write(
          "STATUS=NEW_STATE\r\nOUTPUTS_STATE=${sims.out1},${sims.out2},${sims.out3},${sims.out4},${sims.out5},${sims.out6}\r\n\r\n/disetron_eoc\r\n")
      ..close();
  });
}

void handleSetOutput(HttpRequest request) {
  if (request.uri.pathSegments.length < 3) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write("Invalid path request")
      ..close();
    return;
  }

  final query = request.uri.query;

  if (query.isEmpty) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write("Empty query parameters")
      ..close();
  }

  final serialNumber = request.uri.pathSegments[2];
  final outputIndex = request.uri.pathSegments[3];
  final outputValue = request.uri.queryParameters['value'] ?? '2';

  // Set the sims output value on db
  setSimsOutput(serialNumber, int.parse(outputIndex), int.parse(outputValue)).then((sims) {
    // And return the new value
    request.response
      ..write(
          "STATUS=NEW_STATE\r\nOUTPUTS_STATE=${sims.out1},${sims.out2},${sims.out3},${sims.out4},${sims.out5},${sims.out6}\r\n\r\n/disetron_eoc\r\n")
      ..close();
  });
}

void handleToggleOutput(HttpRequest request) {
  if (request.uri.pathSegments.length < 3) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write("Invalid path request")
      ..close();
    return;
  }

  final serialNumber = request.uri.pathSegments[2];
  final outputIndex = request.uri.pathSegments[3];

  // Toggle the sims output value on db
  toggleSimsOutput(serialNumber, int.parse(outputIndex)).then((sims) {
    // And return the new value
    request.response
      ..write(
          "STATUS=NEW_STATE\r\nOUTPUTS_STATE=${sims.out1},${sims.out2},${sims.out3},${sims.out4},${sims.out5},${sims.out6}\r\n\r\n/disetron_eoc\r\n")
      ..close();
  });
}
