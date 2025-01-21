import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

final counterProvider =
    StateProvider<int>((ref) => 0); // Define a counter provider

/// Displays a list of SampleItems.
class SampleItemListView extends StatelessWidget {
  const SampleItemListView({
    super.key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  });

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              restorationId: 'sampleItemListView',
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];

                return ListTile(
                  title: Text('SampleItem ${item.id}'),
                  leading: const CircleAvatar(
                    foregroundImage:
                        AssetImage('assets/images/flutter_logo.png'),
                  ),
                  onTap: () {
                    Navigator.restorablePushNamed(
                      context,
                      SampleItemDetailsView.routeName,
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Consumer(
                builder: (context, ref, child) {
                  final count = ref.watch(counterProvider);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () =>
                            ref.read(counterProvider.notifier).state--,
                      ),
                      Text('$count', style: const TextStyle(fontSize: 20)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () =>
                            ref.read(counterProvider.notifier).state++,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
            onPressed: () => ref.read(counterProvider.notifier).state++,
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
