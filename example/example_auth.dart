import 'package:dartus/tomuss.dart';
import 'package:dartz/dartz.dart';
import 'package:lyon1agenda/lyon1agenda.dart';

void main() async {
  final Lyon1Agenda agendaClient = Lyon1Agenda.useAuthentication(
      Authentication("p1234567", "a_valid_password"));
  final Option<Agenda> agendaOpt = await agendaClient.getAgenda();
  if (agendaOpt.isNone()) {
    // handle gracefully
  }
  final Agenda agenda = agendaOpt.toNullable() ?? Agenda.empty();

  for (final Event e in agenda.events) {
    print(e.name);
    print("\t${e.location} | ${e.teacher}");
    print("\t${e.start.toString()} -> ${e.end.toString()}");
  }
}
