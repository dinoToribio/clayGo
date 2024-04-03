import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/dirt_level_log.dart';

class DirtLevelLogsRepository {
  static Stream getTableDirtLevelLogs({
    required String tableId,
  }) {
    return FirebaseFirestore.instance
        .collection("tables")
        .doc(tableId)
        .collection("dirt_level_logs")
        .orderBy("created_datetime", descending: true)
        .snapshots();
  }

  static List<DirtLevelLog> parseDirtLevelLog({
    QuerySnapshot<Map<String, dynamic>>? snapshot,
  }) {
    List<DirtLevelLog> logs = [];
    if (snapshot != null) {
      for (var doc in snapshot.docs) {
        final log = DirtLevelLog.fromSnapshot(doc);
        logs.add(log);
      }
    }
    return logs;
  }
}
