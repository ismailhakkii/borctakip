import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/entry.dart';

class EntryForm extends StatefulWidget {
  final bool isDebt;
  final Function(bool, Entry) onAdd;

  const EntryForm({super.key, required this.isDebt, required this.onAdd});

  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime _dueDate = DateTime.now();

  void _addEntry() {
    final String name = _nameController.text;
    final double amount = double.tryParse(_amountController.text) ?? 0;

    if (name.isNotEmpty && amount > 0) {
      widget.onAdd(
        widget.isDebt,
        Entry(
          name: name,
          amount: amount,
          date: _selectedDate,
          dueDate: _dueDate,
        ),
      );
      _nameController.clear();
      _amountController.clear();
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isDebt ? 'Yeni Borç Ekle' : 'Yeni Alacak Ekle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'İsim'),
          ),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Miktar'),
            keyboardType: TextInputType.number,
          ),
          ListTile(
            title: Text('Tarih Seç: ${DateFormat.yMMMd().format(_selectedDate)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: _selectDate,
          ),
          ListTile(
            title: Text('Vade Tarihi: ${DateFormat.yMMMd().format(_dueDate)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: _selectDueDate,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('İptal'),
          onPressed: () {
            _nameController.clear();
            _amountController.clear();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          onPressed: _addEntry,
          child: const Text('Ekle'),
        ),
      ],
    );
  }
}
