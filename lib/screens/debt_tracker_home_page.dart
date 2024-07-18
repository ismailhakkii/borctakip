import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/entry.dart';
import '../widgets/entry_form.dart';
import '../widgets/entry_list.dart';
import '../widgets/settings_dialog.dart';

class DebtTrackerHomePage extends StatefulWidget {
  final Function(ThemeMode) onThemeModeChanged;
  final Function(Locale) onLocaleChanged;

  const DebtTrackerHomePage({super.key, required this.onThemeModeChanged, required this.onLocaleChanged});

  @override
  _DebtTrackerHomePageState createState() => _DebtTrackerHomePageState();
}

class _DebtTrackerHomePageState extends State<DebtTrackerHomePage> {
  final List<Entry> _debts = [];
  final List<Entry> _credits = [];
  bool _showDebts = true;
  String _timeFilter = 'All';

  void _addEntry(bool isDebt, Entry entry) {
    setState(() {
      (isDebt ? _debts : _credits).add(entry);
    });
  }

  List<Entry> _filterEntries(List<Entry> entries) {
    DateTime now = DateTime.now();
    DateTime oneWeekFromNow = now.add(const Duration(days: 7));
    DateTime oneMonthFromNow = DateTime(now.year, now.month + 1, now.day);
    DateTime oneYearFromNow = DateTime(now.year + 1, now.month, now.day);

    switch (_timeFilter) {
      case '1 Week':
        return entries.where((entry) => entry.dueDate.isBefore(oneWeekFromNow)).toList();
      case '1 Month':
        return entries.where((entry) => entry.dueDate.isBefore(oneMonthFromNow)).toList();
      case '1 Year':
        return entries.where((entry) => entry.dueDate.isBefore(oneYearFromNow)).toList();
      case 'All':
      default:
        return entries;
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = _showDebts ? _debts : _credits;
    final filteredEntries = _filterEntries(entries);
    double totalAmount = filteredEntries.fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borç Takip Uygulaması'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => EntryForm(
                isDebt: _showDebts,
                onAdd: _addEntry,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Borçlar'),
                onPressed: () {
                  setState(() {
                    _showDebts = true;
                  });
                },
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                child: const Text('Alacaklar'),
                onPressed: () {
                  setState(() {
                    _showDebts = false;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: _timeFilter,
                items: ['All', '1 Week', '1 Month', '1 Year']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _timeFilter = newValue!;
                  });
                },
              ),
            ],
          ),
          Expanded(child: EntryList(entries: filteredEntries, isDebt: _showDebts)),
          if (filteredEntries.isNotEmpty) Expanded(child: _buildChart(filteredEntries)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Toplam: $totalAmount TL',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Bildirimler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        currentIndex: 1,
        backgroundColor: Colors.blueGrey,
        selectedItemColor: Color.fromARGB(255, 96, 31, 175),
        unselectedItemColor: Color.fromARGB(255, 96, 31, 175),
        onTap: (index) {
          if (index == 3) {
            showDialog(
              context: context,
              builder: (context) => SettingsDialog(
                currentLocale: Localizations.localeOf(context),
                onThemeModeChanged: widget.onThemeModeChanged,
                onLocaleChanged: widget.onLocaleChanged,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildChart(List<Entry> entries) {
    List<PieSeries<Entry, String>> series = [
      PieSeries<Entry, String>(
        dataSource: entries,
        xValueMapper: (Entry entry, _) => entry.name,
        yValueMapper: (Entry entry, _) => entry.amount,
        dataLabelMapper: (Entry entry, _) => '${entry.name}: ${entry.amount} TL',
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ];

    return SfCircularChart(
      series: series,
      legend: const Legend(isVisible: true),
    );
  }
}
