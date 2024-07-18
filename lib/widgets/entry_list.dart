import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/entry.dart';

class EntryList extends StatelessWidget {
  final List<Entry> entries;
  final bool isDebt;

  const EntryList({super.key, required this.entries, required this.isDebt});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return ListTile(
          title: Text('${entry.name} ${entry.amount} TL'),
          subtitle: Text(
              'Tarih: ${DateFormat.yMMMd().format(entry.date)}\nVade: ${DateFormat.yMMMd().format(entry.dueDate)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(entry.paid
                    ? Icons.check_box
                    : Icons.check_box_outline_blank),
                onPressed: () {
                  // Borç veya alacak ödeme durumunu güncelle
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Borç veya alacak sil
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
