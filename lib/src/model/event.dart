class Event {
  late String _location;
  late String _description;
  late String _teacher;
  late String _summary;

  late DateTime _start;
  late DateTime _end;
  late DateTime _eventLastModified;
  Event.fromJSON(final dynamic eventJSON) {
    _location = eventJSON['location'] ?? "";
    _description = (eventJSON['description'] ?? "")
        .toString()
        .replaceFirst(RegExp("\\(Exported.*", multiLine: true), "")
        .trim();
    _summary = eventJSON['summary'] ?? "";

    _teacher = RegExp("\\n\\n.*?\\n([A-Z -])+\\n", multiLine: true)
            .firstMatch(_description)
            ?.group(1) ??
        "";
    _start = DateTime.parse(eventJSON['dtstart']['dt']);
    _end = DateTime.parse(eventJSON['dtend']['dt']);
    _eventLastModified = DateTime.parse(eventJSON['lastModified']['dt']);
  }

  String get name => _summary;
  String get location => _location;
  String get teacher => _teacher;
  String get description => _description;
  DateTime get start => _start;
  DateTime get end => _end;
  DateTime get lastModified => _eventLastModified;
}
