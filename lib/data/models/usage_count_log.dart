import 'package:cloud_firestore/cloud_firestore.dart';

class UsageCountLog {
  final String id;
  final int maxCount;
  final int count;
  final Timestamp createdAt;
  final DocumentReference reference;

  UsageCountLog.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['max_count'] != null),
        assert(map['count'] != null),
        assert(map['created_datetime'] != null),
        id = reference.id,
        maxCount = map['max_count'],
        count = map['count'],
        createdAt = map['created_datetime'];

  UsageCountLog.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>?> snapshot)
      : this.fromMap(snapshot.data() ?? {}, reference: snapshot.reference);

  @override
  String toString() =>
      "UsageCountLog<id=$id,maxCount=$maxCount,count=$count,createdAt=$createdAt>";
}
