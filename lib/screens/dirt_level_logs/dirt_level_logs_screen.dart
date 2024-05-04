import 'package:claygo_app/data/data.dart' as data;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/dirt_level_logs_screen_arguments.dart';

class DirtLevelLogsScreen extends StatefulWidget {
  const DirtLevelLogsScreen({super.key});

  @override
  State<DirtLevelLogsScreen> createState() => DirtLevelLogsScreenState();
}

class DirtLevelLogsScreenState extends State<DirtLevelLogsScreen> {
  List<data.DirtLevelLog> logs = [];
  data.Table? table;

  @override
  void didChangeDependencies() {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as DirtLevelLogsScreenArguments;
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
          "${table?.name ?? ''} - Dirt Level",
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.delete,
                size: 30,
                color: Colors.blue,
              ),
              const SizedBox(width: 5),
              StreamBuilder(
                stream: data.TablesRepository.getTable(
                  tableId: table?.id ?? '',
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final tble = snapshot.data;
                    return Text(
                      "${tble?.dirtLevel ?? 0}%",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      "Error!!!",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }

                  return const SizedBox(
                    height: 10,
                    width: 30,
                    child: LinearProgressIndicator(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "History",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 10,
                  thickness: 1,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: data.DirtLevelLogsRepository.getTableDirtLevelLogs(
                tableId: table?.id ?? '',
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if ((snapshot.data?.docs ?? []).isNotEmpty) {
                    logs = data.DirtLevelLogsRepository.parseDirtLevelLog(
                      snapshot: snapshot.data,
                    );
                    return _buildLogs();
                  }
                  return _buildNoLogs();
                } else if (snapshot.hasError) {
                  return _buildError();
                } else {
                  return _buildFetchingLogs();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogs() {
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return _buildLog(
          level: log.level,
          createdAt: log.createdAt.toDate(),
        );
      },
    );
  }

  Widget _buildLog({
    required int level,
    required DateTime createdAt,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.delete,
                size: 16,
                color: Colors.blue,
              ),
              const SizedBox(width: 5),
              Text(
                "${level.toString()}%",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            DateFormat('MM-dd-yyyy hh:mm a').format(createdAt),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 50,
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sorry, something went wrong in fetching the dirt level Logs.",
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

  Widget _buildNoLogs() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 50,
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No dirt level logs",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFetchingLogs() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 2,
            ),
          ),
          SizedBox(
            width: 7,
          ),
          Text(
            "Fetching dirt level logs",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
