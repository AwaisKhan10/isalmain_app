import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sheduling_app/teacher/core/model/class_time_shedule.dart';

class ScheduleUtils {
  static String formatClassDate(int? millis) {
    if (millis == null) return 'N/A';
    return DateFormat('EEE, dd MMM yyyy').format(
      DateTime.fromMillisecondsSinceEpoch(millis),
    );
  }

  static String formatTimeDisplay(String? time) {
    if (time == null || time.isEmpty) return 'N/A';
    return time;
  }

  static int timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  static String timeOfDayToLabel(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  static TimeOfDay? parseTimeLabel(String? time) {
    if (time == null || time.trim().isEmpty) return null;
    final normalized = time.trim().toUpperCase();
    final match = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$').firstMatch(normalized);
    if (match == null) return null;

    var hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)!;

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute);
  }

  static int? parseTimeToMinutes(String? time) {
    final parsed = parseTimeLabel(time);
    if (parsed == null) return null;
    return timeOfDayToMinutes(parsed);
  }

  static bool isSameTimeSlot(ClassTimeSheduleModel a, ClassTimeSheduleModel b) {
    final aMinutes = a.startTimeMinutes ?? parseTimeToMinutes(a.time);
    final bMinutes = b.startTimeMinutes ?? parseTimeToMinutes(b.time);
    if (aMinutes != null && bMinutes != null) {
      return aMinutes == bMinutes;
    }
    return (a.time ?? '').trim().toLowerCase() ==
        (b.time ?? '').trim().toLowerCase();
  }

  static bool isSameDay(ClassTimeSheduleModel a, ClassTimeSheduleModel b) {
    return (a.day ?? '').trim().toLowerCase() ==
        (b.day ?? '').trim().toLowerCase();
  }

  /// Returns an error message when the teacher already has a class on the same day and time.
  static String? findTeacherScheduleConflict({
    required List<ClassTimeSheduleModel> existing,
    required ClassTimeSheduleModel candidate,
    String? excludeId,
  }) {
    for (final schedule in existing) {
      if (excludeId != null && schedule.id == excludeId) continue;
      if (!isSameDay(schedule, candidate)) continue;
      if (!isSameTimeSlot(schedule, candidate)) continue;

      return 'You already added "${schedule.subject ?? 'a class'}" on '
          '${candidate.day} at ${candidate.time}. '
          'Please choose a different time to arrange your classes.';
    }
    return null;
  }

  static void sortSchedules(List<ClassTimeSheduleModel> schedules) {
    schedules.sort((a, b) {
      final dateCompare = (a.classDate ?? 0).compareTo(b.classDate ?? 0);
      if (dateCompare != 0) return dateCompare;

      final dayCompare = _dayIndex(a.day).compareTo(_dayIndex(b.day));
      if (dayCompare != 0) return dayCompare;

      final aMinutes = a.startTimeMinutes ?? parseTimeToMinutes(a.time) ?? 0;
      final bMinutes = b.startTimeMinutes ?? parseTimeToMinutes(b.time) ?? 0;
      return aMinutes.compareTo(bMinutes);
    });
  }

  static int _dayIndex(String? day) {
    const order = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final index = order.indexOf((day ?? '').trim().toLowerCase());
    return index == -1 ? 99 : index;
  }
}
