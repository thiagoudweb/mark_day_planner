enum ReminderType { ligacao, reuniao, compra }

extension ReminderTypeLabel on ReminderType {
  String get label {
    switch (this) {
      case ReminderType.ligacao:
        return 'Ligações importantes';
      case ReminderType.reuniao:
        return 'Reuniões';
      case ReminderType.compra:
        return 'Compras';
    }
  }
}

class Reminder {
  final String id;
  final ReminderType type;
  final String description;
  final DateTime dateTime;

  Reminder({
    required this.id,
    required this.type,
    required this.description,
    required this.dateTime,
  });
}
