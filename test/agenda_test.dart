import 'package:dartz/dartz.dart';
import 'package:lyon1agenda/src/lyon1agenda.dart';
import 'package:lyon1agenda/src/model/agenda.dart';
import 'package:lyon1agenda/src/model/event.dart';
import 'package:test/test.dart';

void main() async {
  test('getAgenda from URL', () async {
    final List<String> icalLinks = [
      "https://adelb.univ-lyon1.fr/jsp/custom/modules/plannings/anonymous_cal.jsp?resources=46404&projectId=1&calType=ical&firstDate=2022-01-24&lastDate=2022-01-29",
      "https://adelb.univ-lyon1.fr/jsp/custom/modules/plannings/anonymous_cal.jsp?resources=10069&projectId=1&calType=ical&firstDate=2022-01-24&lastDate=2022-01-29"
    ];

    for (final String link in icalLinks) {
      final Lyon1Agenda agendaClient = Lyon1Agenda();
      final Option<Agenda> agendaOpt = await agendaClient.getAgenda(url: link);

      expect(agendaOpt.isSome(), equals(true));

      final Agenda agenda = agendaOpt.getOrElse(() => Agenda.empty());

      for (final Event event in agenda.events) {
        expect(event.start.runtimeType, equals(DateTime));
        expect(event.end.runtimeType, equals(DateTime));
        expect(event.lastModified.runtimeType, equals(DateTime));

        expect(event.description, isNot(isEmpty));
        expect(event.description.contains("Exported"), equals(false));
        expect(event.name, isNot(isEmpty));
        expect(event.location, isNot(isEmpty));

        // TODO: investigate
        // expect(event.teacher, isNot(isEmpty)); // does not pass
      }
    }
  });
}
