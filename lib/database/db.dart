import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:sqflite_common/sqlite_api.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:sims_server/model/sims.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

late Database db;

Future<bool> initDb() async {
  // Init ffi loader if needed.
  sqfliteFfiInit();

  var databaseFactory = databaseFactoryFfi;
  // databaseFactory.deleteDatabase(inMemoryDatabasePath);
  //db = await databaseFactory.openDatabase(inMemoryDatabasePath);
  db = await databaseFactory.openDatabase(p.join("/" "Users", "Jose", "Downloads", "sims.db"));

  await db.execute('''
  CREATE TABLE sims (
      id INTEGER PRIMARY KEY,
      serial TEXT,
      out1 INTEGER,
      out2 INTEGER,
      out3 INTEGER,
      out4 INTEGER,
      out5 INTEGER,
      out6 INTEGER
  )
  ''').onError((error, stackTrace) => print("Opened existing database"));

  if (db.isOpen) return true;

  return false;
}

Future<List<Sims>> getSims() async {
  // Query the table for all The Dogs.
  final List<Map<String, dynamic>> maps = await db.query('sims');

  // Convert the List<Map<String, dynamic> into a List<Sims>.
  return List.generate(maps.length, (i) {
    return Sims(
      id: maps[i]['id'],
      serial: maps[i]['serial'],
      out1: maps[i]['out1'],
      out2: maps[i]['out2'],
      out3: maps[i]['out3'],
      out4: maps[i]['out4'],
      out5: maps[i]['out5'],
      out6: maps[i]['out6'],
    );
  });
}

Future<Sims> getSimsBySerial(String serial) async {
  // Query the table for all the Sims
  List<Map<String, dynamic>> maps = await db.query('sims', where: 'serial = ?', whereArgs: [serial]);

  if (maps.isEmpty) {
    // Create asims with this serial number
    await db.insert(
      'sims',
      <String, Object?>{'serial': serial, 'out1': 0, 'out2': 0, 'out3': 0, 'out4': 0, 'out5': 0, 'out6': 0},
    );
    maps = await db.query('sims', where: 'serial = ?', whereArgs: [serial]);
  }

  return Sims(
    id: maps[0]['id'],
    serial: maps[0]['serial'],
    out1: maps[0]['out1'],
    out2: maps[0]['out2'],
    out3: maps[0]['out3'],
    out4: maps[0]['out4'],
    out5: maps[0]['out5'],
    out6: maps[0]['out6'],
  );
}

Future<void> updateSims(Sims device) async {
  // Update the given Sims
  await db.update(
    'sims',
    device.toMap(),
    // Ensure that the Sims has a matching id
    where: 'id = ?',
    // Pass the Sims's id as a whereArg to prevent SQL injection.
    whereArgs: [device.id],
  );
}

Future<Sims> setSimsOutput(String serial, int outputIndex, int value) async {
  var sims = await getSimsBySerial(serial);

  if (value == 2) {
    return sims;
  }

  if (outputIndex == 1) {
    sims.out1 = value;
  } else if (outputIndex == 2) {
    sims.out2 = value;
  } else if (outputIndex == 3) {
    sims.out3 = value;
  } else if (outputIndex == 4) {
    sims.out4 = value;
  } else if (outputIndex == 5) {
    sims.out5 = value;
  } else if (outputIndex == 6) {
    sims.out6 = value;
  }

  updateSims(sims);

  return sims;
}

Future<Sims> toggleSimsOutput(String serial, int outputIndex) async {
  var sims = await getSimsBySerial(serial);

  if (outputIndex == 1) {
    sims.out1 ^= 1;
  } else if (outputIndex == 2) {
    sims.out2 ^= 1;
  } else if (outputIndex == 3) {
    sims.out3 ^= 1;
  } else if (outputIndex == 4) {
    sims.out4 ^= 1;
  } else if (outputIndex == 5) {
    sims.out5 ^= 1;
  } else if (outputIndex == 6) {
    sims.out6 ^= 1;
  }

  updateSims(sims);

  return sims;
}
