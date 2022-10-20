import 'package:dartus/tomuss.dart';
import 'package:dartz/dartz.dart';
import 'package:lyon1agenda/src/constants/constants.dart';
import 'package:lyon1agenda/src/model/agenda.dart';
import 'package:lyon1agenda/src/parser/agendaparser.dart';
import 'package:lyon1agenda/src/utils/agenda_url.dart';
import 'package:requests/requests.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

class Lyon1Agenda {
  late final AgendaParser _parser = AgendaParser();
  late AgendaURL _agendaURL;

  Lyon1Agenda(this._agendaURL);

  Lyon1Agenda.useAuthentication(final Authentication authentication) {
    _agendaURL = AgendaURL(authentication);
  }

  Future<Option<Agenda>> getAgenda({String url = ""}) async {
    if (url.isEmpty) {
      return None();
    }
    String resources = "";
    String projectid = "";
    if (url.isNotEmpty) {
      resources = url.substring(url.indexOf("resources=") + 10);
      resources = resources.substring(0, resources.indexOf("&"));
      projectid = url.substring(url.indexOf("projectId=") + 10);
      projectid = projectid.substring(0, projectid.indexOf("&"));
    }

    final String newURL =
        (await _agendaURL.getURL(projectid: projectid, resources: resources))
            .getOrElse(() => "");
    url = newURL.isEmpty ? url : newURL;

    url = url.replaceFirst("http:", "https:"); // force https

    final Response response = await Requests.get(url,
        headers: {
          'User-Agent': Constants.userAgent,
          'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.5',
          'Accept-Encoding': 'gzip, deflate, br',
          'DNT': '1',
          'Pragma': 'no-cache',
          'Cache-Control': 'no-cache'
        },
    );
    return ((response.statusCode) >= 400)
        ? None()
        : await _parser.parseICS(response.body);
  }
}
