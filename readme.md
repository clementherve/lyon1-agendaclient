# ADE ICal Client
An ICal Client for ADE Lyon 1

# Adding it to your project
```bash
dart pub get https://github.com/clementherve/lyon1-agendaclient
```

# Example
```dart
final Lyon1Agenda agendaClient = Lyon1Agenda();
final Option<Agenda> agendaOpt =
    await agendaClient.getAgenda(url: "http://<url>");
if (agendaOpt.isNone()) {
    // handle gracefully
}
final Agenda agenda = agendaOpt.toNullable() ?? Agenda.empty();

for (final Event e in agenda.events) {
    print(e.name);
    print("\t${e.location} | ${e.teacher}");
    print("\t${e.start.toString()} -> ${e.end.toString()}");
}
```
