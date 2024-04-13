import 'package:claygo_app/data/statuses/statuses.dart';
import 'package:claygo_app/screens/screens.dart';
import 'package:claygo_app/widgets/toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:claygo_app/data/data.dart' as data;

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => TablesScreenState();
}

class TablesScreenState extends State<TablesScreen> {
  TextEditingController tableNameTextfield = TextEditingController(text: "");
  
  //Edit here to change the maxUsageCount
  int maxUsageCount = 5;

  ///This variables will be used for storing tables from FireStore
  List<data.Table> tables = [];

  Future<void> addTable(BuildContext context) async {
    final status = await data.TablesRepository.addTable(
      name: tableNameTextfield.text,
      maxUsageCount: maxUsageCount,
    );
    if (mounted) {
      if (status == FirestoreStatuses.success) {
        tableNameTextfield.text = "";
        Navigator.of(context).pop();
        Toast.showSuccessMsg(
          context: context,
          message: "Table Added Successfully",
        );
      } else {
        Toast.showErrorMsg(
          context: context,
          message: "Sorry, adding the table failed. Try again later.",
        );
      }
    }
  }

  Future<void> deleteTable({
    required data.Table table,
  }) async {
    final status = await data.TablesRepository.deleteTable(table: table);
    if (mounted) {
      if (status == FirestoreStatuses.success) {
        Navigator.of(context).pop();
        Toast.showSuccessMsg(
          context: context,
          message: "Table Deleted Successfully",
        );
      } else {
        Toast.showErrorMsg(
          context: context,
          message: "Sorry, deleting the table failed. Try again later.",
        );
      }
    }
  }

  Future<void> updateTable({
    required data.Table table,
  }) async {
    final status = await data.TablesRepository.updateTable(
      table: table,
      name: tableNameTextfield.text,
    );
    if (mounted) {
      if (status == FirestoreStatuses.success) {
        Navigator.of(context).pop();
        Toast.showSuccessMsg(
          context: context,
          message: "Table Updated Successfully",
        );
      } else {
        Toast.showErrorMsg(
          context: context,
          message: "Sorry, updating the table failed. Try again later.",
        );
      }
    }
  }

  @override
  void dispose() {
    tableNameTextfield.dispose();
    super.dispose();
  }

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
        stream: FirebaseFirestore.instance
            .collection("tables")
            .orderBy(
              "created_datetime",
              descending: true,
            )
            .snapshots(),
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
        onPressed: () {
          //uncomment this when you need add table function
          // _showAddTableDialog();
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          size: 25,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'ClayGo App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Instructions'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {},
            ),
          ],
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
      padding: const EdgeInsets.only(top: 20, bottom: 100),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        final table = tables[index];
        return _buildTable(
          table: table,
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
    required data.Table table,
    required String label,
    required String waterLevelLabel,
    required String dirtLevelLabel,
    required String usageCountLabel,
  }) {
    bool showRedHighlight = table.usageCount == 0 ||
        table.dirtLevel == 100 ||
        table.waterLevel == 0;
    final tableColor = showRedHighlight ? Colors.red : Colors.blue;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          RouteNames.table,
          arguments: TablesScreenArguments(
            table: table,
          ),
        );
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
            width: showRedHighlight ? 2.5 : 1,
            color: tableColor,
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
                    Icon(
                      Icons.table_restaurant_outlined,
                      size: 30,
                      color: tableColor,
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
                      onTap: () {
                        _showEditTableDialog(table: table);
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildTableButtons(
                      icon: Icons.delete,
                      iconColor: Colors.black,
                      onTap: () {
                        _showDeleteTableDialog(table: table);
                      },
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
                  showRedHighlight: table.waterLevel == 0,
                ),
                const SizedBox(width: 4),
                _buildTableMiniStatus(
                  icon: Icons.delete,
                  label: dirtLevelLabel,
                  showRedHighlight: table.dirtLevel == 100,
                ),
                const SizedBox(width: 4),
                _buildTableMiniStatus(
                  icon: Icons.data_usage,
                  label: usageCountLabel,
                  showRedHighlight: table.usageCount == 0,
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
    required bool showRedHighlight,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: showRedHighlight ? Colors.red : Colors.blue,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            color: showRedHighlight ? Colors.red : Colors.black,
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

  //Dialogs

  // Uncomment when need add table function
  // void _showAddTableDialog() async {
  //   tableNameTextfield.clear();
  //   await showDialog(
  //     builder: (context) => AlertDialog(
  //       contentPadding: const EdgeInsets.all(25),
  //       actionsPadding: const EdgeInsets.all(5),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Row(
  //             children: <Widget>[
  //               Expanded(
  //                 child: TextField(
  //                   controller: tableNameTextfield,
  //                   autofocus: true,
  //                   decoration: const InputDecoration(
  //                     labelText: 'Name',
  //                     floatingLabelBehavior: FloatingLabelBehavior.always,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //       actions: <Widget>[
  //         TextButton(
  //           child: const Text('CANCEL'),
  //           onPressed: () {
  //             tableNameTextfield.text = "";
  //             Navigator.pop(context);
  //           },
  //         ),
  //         TextButton(
  //           child: const Text('ADD Table'),
  //           onPressed: () {
  //             if (tableNameTextfield.text.isNotEmpty) {
  //               addTable(context);
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //     context: context,
  //   );
  // }

  //Dialogs
  void _showEditTableDialog({
    required data.Table table,
  }) async {
    tableNameTextfield.text = table.name;
    await showDialog(
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(25),
        actionsPadding: const EdgeInsets.all(5),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: tableNameTextfield,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              tableNameTextfield.text = "";
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Update Table'),
            onPressed: () {
              if (tableNameTextfield.text.isNotEmpty) {
                if (tableNameTextfield.text.toLowerCase() !=
                    table.name.toLowerCase()) {
                  updateTable(table: table);
                }
              }
            },
          ),
        ],
      ),
      context: context,
    );
  }

  void _showDeleteTableDialog({
    required data.Table table,
  }) async {
    await showDialog(
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(30),
        content: Text("Do you really want to delete ${table.name}?"),
        actionsPadding: const EdgeInsets.all(5),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () {
              deleteTable(table: table);
            },
          ),
        ],
      ),
      context: context,
    );
  }
}
