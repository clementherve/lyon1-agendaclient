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
        connectTimeout: 3 * 1000,
        headers: {'User-Agent': Constants.userAgent}));
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

    final Response response = await _dio.get(url);
    return ((response.statusCode ?? 400) >= 400)
        ? None()
        : await _parser.parseICS(response.data);
  }
}
