import 'package:flutter/material.dart';

class SettingsDialog extends StatelessWidget {
  final Locale currentLocale;
  final Function(ThemeMode) onThemeModeChanged;
  final Function(Locale) onLocaleChanged;

  const SettingsDialog({super.key, 
    required this.currentLocale,
    required this.onThemeModeChanged,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ayarlar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Karanlık Mod'),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                onThemeModeChanged(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
          ListTile(
            title: const Text('Dil Seçeneği'),
            trailing: DropdownButton<Locale>(
              value: currentLocale,
              items: const [
                DropdownMenuItem(
                  value: Locale('tr', 'TR'),
                  child: Text('Türkçe'),
                ),
                DropdownMenuItem(
                  value: Locale('en', 'US'),
                  child: Text('English'),
                ),
              ],
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  onLocaleChanged(newLocale);
                }
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Kapat'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
