import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/water_level_log.dart';

class WaterLevelLogsRepository {
  static Stream getTableWaterLevelLogs({
    required String tableId,
  }) {
    return FirebaseFirestore.instance
        .collection("tables")
        .doc(tableId)
        .collection("water_level_logs")
        .orderBy("created_datetime", descending: true)
        .snapshots();
  }

  static List<WaterLevelLog> parseWaterLevelLog({
    QuerySnapshot<Map<String, dynamic>>? snapshot,
  }) {
    List<WaterLevelLog> logs = [];
    if (snapshot != null) {
      for (var doc in snapshot.docs) {
        final log = WaterLevelLog.fromSnapshot(doc);
        logs.add(log);
      }
    }
    return logs;
  }
}
