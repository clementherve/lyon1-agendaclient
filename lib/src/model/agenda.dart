import 'event.dart';

class Agenda {
  late List<Event> _events;
  Agenda(this._events);
  Agenda.empty() {
    _events = [];
  }

  List<Event> get events => _events;

  Event firstEventForDay(final DateTime dt) {
    return _events.firstWhere(
        (event) => dt.isAfter(event.start) && dt.isBefore(event.end));
  }

  List<Event> allEventsForDay(final DateTime dt) {
    return _events
        .where((event) => dt.isAfter(event.start) && dt.isBefore(event.end))
        .toList();
  }

  List<Event> searchEvents(final String keyword) {
    final RegExp r = RegExp(keyword, multiLine: true, caseSensitive: false);

    return _events
        .where((event) =>
            event.location.contains(r) ||
            event.teacher.contains(r) ||
            event.name.contains(r) ||
            event.description.contains(r))
        .toList();
  }
}
