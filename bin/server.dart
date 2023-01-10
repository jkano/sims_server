import 'package:sims_server/database/db.dart';
import 'package:sims_server/sims.dart' as sims;
import 'dart:io';

Future<void> main() async {
  await initDb();
  final server = await createServer();
  print('Server started: ${server.address} port ${server.port}');
  await sims.handleRequests(server);
}

Future<HttpServer> createServer() async {
  final address = InternetAddress.loopbackIPv4;
  const port = 4040;
  return await HttpServer.bind(address, port);
}
