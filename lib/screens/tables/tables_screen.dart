import 'package:claygo_app/routes/route_names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:claygo_app/data/data.dart' as data;

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => TablesScreenState();
}

class TablesScreenState extends State<TablesScreen> {
  ///This variables will be used for storing tables from FireStore
  List<data.Table> tables = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          "Tables",
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("tables").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if ((snapshot.data?.docs ?? []).isNotEmpty) {
              tables = data.TablesRepository.parseTables(snapshot.data);
              return _buildTables();
            }
            return _buildNoTable();
          } else if (snapshot.hasError) {
            return _buildError();
          } else {
            return _buildLoading();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          size: 25,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Colors.blue,
          ),
          SizedBox(height: 20),
          Text(
            "Fetching tables",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sorry, something went wrong in fetching the tables.",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTables() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        final table = tables[index];
        return _buildTable(
          label: table.name,
          waterLevelLabel: "${table.waterLevel}% left",
          dirtLevelLabel: "${table.dirtLevel}%",
          usageCountLabel: "${table.usageCount}/${table.maxUsageCount}",
        );
      },
    );
  }

  Widget _buildNoTable() {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No Tables",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable({
    required String label,
    required String waterLevelLabel,
    required String dirtLevelLabel,
    required String usageCountLabel,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteNames.table);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: Colors.blue,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.table_restaurant_outlined,
                      size: 30,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTableButtons(
                      icon: Icons.edit,
                      iconColor: Colors.black,
                      onTap: () {},
                    ),
                    const SizedBox(width: 10),
                    _buildTableButtons(
                      icon: Icons.delete,
                      iconColor: Colors.black,
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
            const Divider(thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTableMiniStatus(
                  icon: Icons.water_drop,
                  label: waterLevelLabel,
                ),
                const SizedBox(width: 4),
                _buildTableMiniStatus(
                  icon: Icons.delete,
                  label: dirtLevelLabel,
                ),
                const SizedBox(width: 4),
                _buildTableMiniStatus(
                  icon: Icons.data_usage,
                  label: usageCountLabel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableMiniStatus({
    required IconData icon,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: Colors.blue,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTableButtons({
    required IconData icon,
    required Color iconColor,
    required Function()? onTap,
  }) {
    const double size = 20;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: size,
        width: size,
        child: FittedBox(
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
