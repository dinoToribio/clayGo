import 'package:claygo_app/data/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TablesRepository {
  static List<Table> parseTables(
    QuerySnapshot<Map<String, dynamic>>? snapshot,
  ) {
    final List<Table> tables = [];
    if (snapshot != null) {
      for (var doc in snapshot.docs) {
        final table = Table.fromSnapshot(doc);
        tables.add(table);
      }
    }
    return tables;
  }

  static Future<String?> addTable({
    required String name,
    required int maxUsageCount,
  }) async {
    try {
      final table = await FirebaseFirestore.instance.collection("tables").add({
        "dirt_level": 0,
        "name": name,
        "usage_count": maxUsageCount,
        "max_usage_count": maxUsageCount,
        "is_online": false,
        "water_level": 100,
        "created_datetime": Timestamp.now(),
      });
      table.collection("water_level_logs").add({
        "level": 100,
        "created_datetime": Timestamp.now(),
      });
      table.collection("dirt_level_logs").add({
        "level": 0,
        "created_datetime": Timestamp.now(),
      });
      table.collection("usage_count_logs").add({
        "count": maxUsageCount,
        "max_count": maxUsageCount,
        "created_datetime": Timestamp.now(),
      });
      return FirestoreStatuses.success;
    } catch (e) {
      return FirestoreStatuses.failed;
    }
  }

  static Future<String?> deleteTable({
    required Table table,
  }) async {
    try {
      final tableToBeDeleted =
          FirebaseFirestore.instance.collection("tables").doc(table.id);
      final batch = FirebaseFirestore.instance.batch();
      final waterLevelLogs =
          await tableToBeDeleted.collection("water_level_logs").get();
      for (var doc in waterLevelLogs.docs) {
        batch.delete(doc.reference);
      }

      final dirtLevelLogs =
          await tableToBeDeleted.collection("dirt_level_logs").get();
      for (var doc in dirtLevelLogs.docs) {
        batch.delete(doc.reference);
      }

      final usageCountLogs =
          await tableToBeDeleted.collection("usage_count_logs").get();
      for (var doc in usageCountLogs.docs) {
        batch.delete(doc.reference);
      }

      final t = await tableToBeDeleted.get();
      batch.delete(t.reference);

      await batch.commit();

      return FirestoreStatuses.success;
    } catch (e) {
      return FirestoreStatuses.failed;
    }
  }

  static Future<String?> updateTable({
    required Table table,
    required String name,
  }) async {
    try {
      final tableToBeUpdated =
          FirebaseFirestore.instance.collection("tables").doc(table.id);

      await tableToBeUpdated.update({
        "name": name,
      });

      return FirestoreStatuses.success;
    } catch (e) {
      return FirestoreStatuses.failed;
    }
  }

  static Stream<Table> getTable({
    required String tableId,
  }) {
    return FirebaseFirestore.instance
        .collection("tables")
        .doc(tableId)
        .snapshots()
        .map(
          (DocumentSnapshot<Map<String, dynamic>> snapshot) => Table.fromMap(
            snapshot.data()!,
            reference: snapshot.reference,
          ),
        );
  }

  static Future<String?> resetTableUsageCount({
    required Table table,
  }) async {
    try {
      final tableToBeUpdated =
          FirebaseFirestore.instance.collection("tables").doc(table.id);

      final usageCount = table.maxUsageCount;

      await tableToBeUpdated.update({
        "usage_count": usageCount,
      });

      await tableToBeUpdated.collection("usage_count_logs").add({
        "count": usageCount,
        "max_count": usageCount,
        "created_datetime": Timestamp.now(),
      });

      return FirestoreStatuses.success;
    } catch (e) {
      return FirestoreStatuses.failed;
    }
  }
}
