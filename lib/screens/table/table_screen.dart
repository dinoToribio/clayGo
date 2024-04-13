import 'package:claygo_app/data/data.dart';
import 'package:claygo_app/screens/screens.dart';
import 'package:claygo_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:claygo_app/data/data.dart' as data;

class TableScreen extends StatefulWidget {
  const TableScreen({
    super.key,
  });
  @override
  State<TableScreen> createState() => TableScreenState();
}

class TableScreenState extends State<TableScreen> {
  data.Table? table;
  ValueNotifier<bool> showRedHighlight = ValueNotifier(false);

  checkTableIfWorstCondition() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (table != null) {
        if (table!.dirtLevel == 100 ||
            table!.waterLevel == 0 ||
            table!.usageCount == 0) {
          showRedHighlight.value = true;
        } else {
          showRedHighlight.value = false;
        }
      }
    });
  }

  Future<void> resetTable({
    required data.Table table,
  }) async {
    final status = await data.TablesRepository.resetTableUsageCount(table: table);
    if (mounted) {
      if (status == FirestoreStatuses.success) {
        Navigator.of(context).pop();
        Toast.showSuccessMsg(
          context: context,
          message: "Table Reset Completed",
        );
      } else {
        Toast.showErrorMsg(
          context: context,
          message: "Sorry, resetting the table failed. Try again later.",
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as TablesScreenArguments;
    table = arguments.table;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showRedHighlight,
      builder: (context, bool showRed, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: showRed ? Colors.red : Colors.blue,
            foregroundColor: Colors.white,
            title: Text(
              table?.name ?? '',
            ),
          ),
          body: table != null
              ? StreamBuilder(
                  stream:
                      data.TablesRepository.getTable(tableId: table?.id ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      table = snapshot.data;
                      checkTableIfWorstCondition();
                      return _buildTableItems();
                    } else if (snapshot.hasError) {
                      return _buildError();
                    } else {
                      return _buildLoading();
                    }
                  },
                )
              : const SizedBox(),
        );
      },
    );
  }

  Widget _buildTableItems() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildItem(
            icon: Icons.water,
            label: "Water Level",
            endLabel: "${table?.waterLevel ?? 0}%",
            showRedHighlight: (table?.waterLevel ?? 0) == 0,
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteNames.waterLevelLogs,
                arguments: WaterLevelLogsScreenArguments(
                  table: table,
                ),
              );
            },
          ),
          _buildItem(
            icon: Icons.delete,
            label: "Dirt Level",
            endLabel: "${table?.dirtLevel ?? 0}%",
            showRedHighlight: (table?.dirtLevel ?? 0) == 100,
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteNames.dirtLevelLogs,
                arguments: DirtLevelLogsScreenArguments(
                  table: table,
                ),
              );
            },
          ),
          _buildItem(
            icon: Icons.data_usage,
            label: "Usage Count",
            endLabel: "${table?.usageCount ?? 0}/${table?.maxUsageCount}",
            showRedHighlight: (table?.usageCount ?? 0) == 0,
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteNames.usageCountLogs,
                arguments: UsageCountLogsScreenArguments(
                  table: table,
                ),
              );
            },
          ),
          _buildItem(
            icon: Icons.restore,
            label: "Reset Table",
            onTap: () {
              if (table != null) {
                _showResetTableUsageCountDialog(table: table!);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    required Function()? onTap,
    String? endLabel,
    bool showRedHighlight = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: showRedHighlight ? Colors.red : Colors.blue,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30,
              color: showRedHighlight ? Colors.red : Colors.blue,
            ),
            const SizedBox(width: 20),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (endLabel != null) ...[
              Text(
                endLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: showRedHighlight ? Colors.red : Colors.black,
                  fontSize: 17,
                  fontWeight:
                      showRedHighlight ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sorry, something went wrong in fetching the table.",
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

  void _showResetTableUsageCountDialog({
    required data.Table table,
  }) async {
    await showDialog(
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(30),
        content: Text("Do you really want to reset ${table.name}?"),
        actionsPadding: const EdgeInsets.all(5),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Reset'),
            onPressed: () {
              resetTable(table: table);
            },
          ),
        ],
      ),
      context: context,
    );
  }
}
