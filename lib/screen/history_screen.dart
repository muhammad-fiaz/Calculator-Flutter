import 'package:calculator/controller/calculate_controller.dart';
import 'package:calculator/models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CalculateController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: FutureBuilder<List<HistoryModel>>(
        future: controller.fetchHistory(),
        builder: (context, AsyncSnapshot<List<HistoryModel>> snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No History Available'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var history = snapshot.data![index];
                return ListTile(
                  title: Text(history.expression),
                  subtitle: Text(history.result),
                );
              },
            );
          }
        },
      ),
    );
  }
}
