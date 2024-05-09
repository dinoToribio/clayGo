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

  ValueNotifier<bool> isTableOnline = ValueNotifier(true);

  checkTableIfWorstCondition() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (table != null) {
        if (table!.isOnline) {
          isTableOnline.value = true;
          if (table!.dirtLevel == 100 ||
              table!.waterLevel == 0 ||
              table!.usageCount == 0) {
            showRedHighlight.value = true;
          } else {
            showRedHighlight.value = false;
          }
        } else {
          isTableOnline.value = false;
        }
      }
    });
  }

  Future<void> resetTable({
    required data.Table table,
  }) async {
    final status =
        await data.TablesRepository.resetTableUsageCount(table: table);
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
      valueListenable: isTableOnline,
      builder: (context, bool isOnline, child) {
        return ValueListenableBuilder(
          valueListenable: showRedHighlight,
          builder: (context, bool showRed, child) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: isOnline
                    ? showRed
                        ? Colors.red
                        : Colors.blue
                    : Colors.grey,
                foregroundColor: Colors.white,
                title: Text(
                  table?.name ?? '',
                ),
                actions: [
                  StatusCard(isOnline: isOnline),
                  const SizedBox(width: 15),
                ],
              ),
              body: table != null
                  ? StreamBuilder(
                      stream: data.TablesRepository.getTable(
                          tableId: table?.id ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          table = snapshot.data;
                          checkTableIfWorstCondition();
                          return _buildTableItems(
                            isOnline: table?.isOnline ?? false,
                          );
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
      },
    );
  }

  Widget _buildTableItems({required bool isOnline}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildItem(
            iconWidget: WaterLevelIcon(
              height: 25,
              width: 20,
              isOnline: table?.isOnline ?? false,
              waterLevel: table?.waterLevel ?? 0,
            ),
            label: "Water Level",
            endLabel: "${table?.waterLevel ?? 0}%",
            showRedHighlight: (table?.waterLevel ?? 0) == 0,
            isOnline: isOnline,
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
            iconWidget: DirtLevelIcon(
              height: 25,
              width: 20,
              isOnline: table?.isOnline ?? false,
              dirtLevel: table?.dirtLevel ?? 0,
            ),
            label: "Dirt Level",
            endLabel: "${table?.dirtLevel ?? 0}%",
            showRedHighlight: (table?.dirtLevel ?? 0) == 100,
            isOnline: isOnline,
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
            iconWidget: UsageCircularIcon(
              size: 25,
              strokeWidth: 5,
              isOnline: table?.isOnline ?? false,
              maxUsageCount: table?.maxUsageCount ?? 0,
              usageCount: table?.usageCount ?? 0,
            ),
            label: "Usage Count",
            endLabel: "${table?.usageCount ?? 0}/${table?.maxUsageCount}",
            showRedHighlight: (table?.usageCount ?? 0) == 0,
            isOnline: isOnline,
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
            isOnline: isOnline,
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
    IconData? icon,
    Widget? iconWidget,
    required String label,
    required Function()? onTap,
    String? endLabel,
    bool showRedHighlight = false,
    bool isOnline = false,
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
            color: isOnline
                ? showRedHighlight
                    ? Colors.red
                    : Colors.blue
                : Colors.grey,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: 30,
                    color: isOnline
                        ? showRedHighlight
                            ? Colors.red
                            : Colors.blue
                        : Colors.grey,
                  )
                : iconWidget ?? const SizedBox(),
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
