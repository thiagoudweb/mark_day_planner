import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/reminder_store.dart';
import '../models/reminder.dart';
import 'package:intl/intl.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ReminderStore>();
    final reminders = store.reminders;
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final r = reminders[index];
          return Card(
            child: ListTile(
              leading: Icon(_iconForType(r.type)),
              title: Text(r.type.label),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.description),
                  Text(
                    DateFormat(
                      'EEEE, dd/MM/yyyy – HH:mm',
                      'pt_BR',
                    ).format(r.dateTime),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => store.removeReminder(r.id),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReminderDialog(context),
        icon: const Icon(Icons.add_alert),
        label: const Text('Novo Lembrete'),
      ),
    );
  }

  IconData _iconForType(ReminderType type) {
    switch (type) {
      case ReminderType.ligacao:
        return Icons.phone;
      case ReminderType.reuniao:
        return Icons.people;
      case ReminderType.compra:
        return Icons.shopping_cart;
    }
  }

  void _showAddReminderDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => _AddReminderDialog());
  }
}

class _AddReminderDialog extends StatefulWidget {
  @override
  State<_AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<_AddReminderDialog> {
  ReminderType _type = ReminderType.ligacao;
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Novo Lembrete'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<ReminderType>(
              value: _type,
              items: ReminderType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                  .toList(),
              onChanged: (t) => setState(() => _type = t!),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      locale: const Locale('pt', 'BR'),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                  child: const Text('Escolher Data'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Text(_selectedTime.format(context))),
                TextButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (picked != null) setState(() => _selectedTime = picked);
                  },
                  child: const Text('Escolher Hora'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final dateTime = DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              _selectedTime.hour,
              _selectedTime.minute,
            );
            if (_descController.text.trim().isEmpty) return;
            context.read<ReminderStore>().addReminder(
              _type,
              _descController.text.trim(),
              dateTime,
            );
            Navigator.pop(context);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
