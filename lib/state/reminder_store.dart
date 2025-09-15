import 'package:flutter/foundation.dart';
import '../models/reminder.dart';
import 'package:uuid/uuid.dart';

class ReminderStore extends ChangeNotifier {
  final List<Reminder> _reminders = [];

  List<Reminder> get reminders => List.unmodifiable(_reminders);

  void addReminder(ReminderType type, String description, DateTime dateTime) {
    final reminder = Reminder(
      id: const Uuid().v4(),
      type: type,
      description: description,
      dateTime: dateTime,
    );
    _reminders.add(reminder);
    notifyListeners();
  }

  void removeReminder(String id) {
    _reminders.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  List<Reminder> remindersForWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return _reminders
        .where(
          (r) =>
              r.dateTime.isAfter(
                weekStart.subtract(const Duration(seconds: 1)),
              ) &&
              r.dateTime.isBefore(weekEnd.add(const Duration(days: 1))),
        )
        .toList();
  }
}
