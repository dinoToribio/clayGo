import 'package:claygo_app/data/models/usage_count_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsageCountLogsRepository {
  static Stream getTableUsageCountLogs({
    required String tableId,
  }) {
    return FirebaseFirestore.instance
        .collection("tables")
        .doc(tableId)
        .collection("usage_count_logs")
        .orderBy("created_datetime", descending: true)
        .snapshots();
  }

  static List<UsageCountLog> parseUsageCountLogs({
    QuerySnapshot<Map<String, dynamic>>? snapshot,
  }) {
    List<UsageCountLog> logs = [];
    if (snapshot != null) {
      for (var doc in snapshot.docs) {
        final log = UsageCountLog.fromSnapshot(doc);
        logs.add(log);
      }
    }
    return logs;
  }
}
