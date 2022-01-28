import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lyon1agenda/src/constants/constants.dart';
import 'package:lyon1agenda/src/model/agenda.dart';
import 'package:lyon1agenda/src/parser/agendaparser.dart';

class Lyon1Agenda {
  late Dio _dio;
  late AgendaParser _parser;
  Lyon1Agenda() {
    _dio = Dio(BaseOptions(
        connectTimeout: 3 * 1000,
        headers: {'User-Agent': Constants.userAgent}));
    _parser = AgendaParser();
  }

  Future<Option<Agenda>> getAgenda(final String url) async {
    final Response response = await _dio.get(url);
    return ((response.statusCode ?? 400) >= 400)
        ? None()
        : await _parser.parseICS(response.data);
  }
}
