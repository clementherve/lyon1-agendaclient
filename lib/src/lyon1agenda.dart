import 'package:dartus/tomuss.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lyon1agenda/src/constants/constants.dart';
import 'package:lyon1agenda/src/model/agenda.dart';
import 'package:lyon1agenda/src/parser/agendaparser.dart';
import 'package:lyon1agenda/src/utils/agenda_url.dart';

class Lyon1Agenda {
  late Dio _dio;
  late AgendaParser _parser;
  AgendaURL? _agendaURL;

  Lyon1Agenda() {
    _dio = Dio(BaseOptions(
        connectTimeout: 10 * 1000,
        headers: {'User-Agent': Constants.userAgent},
        followRedirects: true,
        maxRedirects: 5));
    _parser = AgendaParser();
  }

  Lyon1Agenda.useAuthentication(final Authentication authentication) {
    _agendaURL = AgendaURL(authentication);
  }

  Future<Option<Agenda>> getAgenda({String url = ""}) async {
    if (_agendaURL == null && url.isEmpty) {
      return None();
    }

    final String newURL =
        (await _agendaURL?.getURL())?.getOrElse(() => "") ?? "";
    url = newURL.isEmpty ? url : newURL;

    url = url.replaceFirst("http:", "https:"); // force https

    final Response response = await _dio.get(url,
        options: Options(headers: {
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.5',
          'Accept-Encoding': 'gzip, deflate, br',
          'DNT': '1',
          'Pragma': 'no-cache',
          'Cache-Control': 'no-cache'
        }));
    return ((response.statusCode ?? 400) >= 400)
        ? None()
        : await _parser.parseICS(response.data);
  }
}
