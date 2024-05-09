import 'package:claygo_app/data/data.dart' as data;
import 'package:claygo_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/usage_count_screen_arguments.dart';

class UsageCountLogsScreen extends StatefulWidget {
  const UsageCountLogsScreen({super.key});

  @override
  State<UsageCountLogsScreen> createState() => UsageCountLogsScreenState();
}

class UsageCountLogsScreenState extends State<UsageCountLogsScreen> {
  List<data.UsageCountLog> logs = [];
  data.Table? table;

  @override
  void didChangeDependencies() {
    final arguments = ModalRoute.of(context)?.settings.arguments
        as UsageCountLogsScreenArguments;
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
          "${table?.name ?? ''} - Usage Count",
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: data.TablesRepository.getTable(
                  tableId: table?.id ?? '',
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final tble = snapshot.data;
                    return Row(
                      children: [
                        UsageCircularIcon(
                          size: 25,
                          strokeWidth: 5,
                          isOnline: true,
                          maxUsageCount: table?.maxUsageCount ?? 0,
                          usageCount: table?.usageCount ?? 0,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${tble?.usageCount ?? 0}/${tble?.maxUsageCount ?? 0}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
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
              stream: data.UsageCountLogsRepository.getTableUsageCountLogs(
                tableId: table?.id ?? '',
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if ((snapshot.data?.docs ?? []).isNotEmpty) {
                    logs = data.UsageCountLogsRepository.parseUsageCountLogs(
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
          usageCount: log.count,
          maxUsageCount: log.maxCount,
          createdAt: log.createdAt,
        );
      },
    );
  }

  _buildLog({
    required int usageCount,
    required int maxUsageCount,
    required Timestamp createdAt,
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
              UsageCircularIcon(
                size: 16,
                isOnline: true,
                maxUsageCount: maxUsageCount,
                usageCount: usageCount,
              ),
              const SizedBox(width: 7),
              Text(
                "$usageCount/$maxUsageCount",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Flexible(
            child: Text(
              DateFormat('MM-dd-yyyy hh:mm a').format(createdAt.toDate()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
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
            "Sorry, something went wrong in fetching the water level Logs.",
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
            "No water level logs",
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
            "Fetching water level logs",
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
