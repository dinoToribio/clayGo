import 'package:claygo_app/screens/screens_name.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          "Home",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildItem(
              icon: Icons.water,
              label: "Water Level",
              endLabel: "76%",
              onTap: () {
                Navigator.of(context).pushNamed(
                  ScreenNames.waterLevel,
                );
              },
            ),
            _buildItem(
              icon: Icons.delete,
              label: "Dirt Level",
              endLabel: "25%",
              onTap: () {
                Navigator.of(context).pushNamed(
                  ScreenNames.dirtLevel,
                );
              },
            ),
            _buildItem(
              icon: Icons.data_usage,
              label: "Usage Count",
              endLabel: "1",
              onTap: () {},
            ),
            _buildItem(
              icon: Icons.restore,
              label: "Reset",
              onTap: () {},
            ),
            // _buildItem(
            //   icon: Icons.system_update,
            //   label: "System logs",
            //   onTap: () {},
            // ),
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
