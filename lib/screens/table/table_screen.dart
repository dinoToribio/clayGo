import 'package:claygo_app/screens/screens.dart';
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

  @override
  void didChangeDependencies() {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as TablesScreenArguments;
    table = arguments.table;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          table?.name ?? '',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildItem(
              icon: Icons.water,
              label: "Water Level",
              endLabel: "${table?.waterLevel ?? 0}%",
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
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    required Function()? onTap,
    String? endLabel,
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
            color: Colors.blue,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Colors.blue),
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
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
