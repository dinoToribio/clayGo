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
}
