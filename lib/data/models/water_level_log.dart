import 'package:cloud_firestore/cloud_firestore.dart';

class WaterLevelLog {
  final String id;
  final int level;
  final Timestamp createdAt;
  final DocumentReference reference;

  WaterLevelLog.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['level'] != null),
        assert(map['created_datetime'] != null),
        id = reference.id,
        level = map['level'],
        createdAt = map['created_datetime'];

  WaterLevelLog.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>?> snapshot)
      : this.fromMap(snapshot.data() ?? {}, reference: snapshot.reference);

  @override
  String toString() =>
      "WaterLevelLog<id=$id,level=$level,createdAt=$createdAt>";
}
