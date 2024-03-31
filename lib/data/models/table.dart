import 'package:cloud_firestore/cloud_firestore.dart';

class Table {
  final String id;
  final String name;
  final int maxUsageCount;
  final int waterLevel;
  final int dirtLevel;
  final int usageCount;
  final DocumentReference reference;

  Table.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['name'] != null),
        id = reference.id,
        name = map['name'],
        maxUsageCount = map['max_usage_count'],
        waterLevel = map['water_level'],
        dirtLevel = map['dirt_level'],
        usageCount = map['usage_count'];

  Table.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>?> snapshot)
      : this.fromMap(snapshot.data() ?? {}, reference: snapshot.reference);
  @override
  String toString() => "Table<id=$id,name=$name,max_usage_count=$maxUsageCount,usage_count=>$usageCount, water_level=>$waterLevel, dirt_level=>$dirtLevel>";
}
