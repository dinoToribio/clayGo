import 'package:cloud_firestore/cloud_firestore.dart';

class Table {
  final String id;
  final String name;
  final int maxUsage;
  final DocumentReference reference;

  Table.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['name'] != null),
        id = reference.id,
        name = map['name'],
        maxUsage = map['max_usage'];

  Table.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>?> snapshot)
      : this.fromMap(snapshot.data() ?? {}, reference: snapshot.reference);
  @override
  String toString() => "Table<id=$id,name=$name,max_usage=$maxUsage>";
}
