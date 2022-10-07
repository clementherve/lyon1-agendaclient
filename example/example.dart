import 'package:dartus/tomuss.dart';
import 'package:dartz/dartz.dart';
import 'package:lyon1agenda/lyon1agenda.dart';

void main() async {
  final Lyon1Agenda agendaClient = Lyon1Agenda.useAuthentication(Authentication("username", "password"));
  final Option<Agenda> agendaOpt = await agendaClient.getAgenda(
      url:
          "http://adelb.univ-lyon1.fr/jsp/custom/modules/plannings/anonymous_cal.jsp?resources=10069&projectId=1&calType=ical&firstDate=2022-01-24&lastDate=2022-01-29");
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
