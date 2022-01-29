import 'package:dartus/tomuss.dart';
import 'package:dartz/dartz.dart';
import 'package:lyon1agenda/src/utils/agenda_url.dart';
import 'package:test/test.dart';
import 'package:dotenv/dotenv.dart' show load, env;

void main() async {
  late Authentication _auth;
  setUpAll(() async {
    load();
    final String username = env['USERNAME'] ?? "";
    final String password = env['PASSWORD'] ?? "";
    if (username.isEmpty || password.isEmpty) {
      throw Exception(
          "Check your .env file, username and/or password are empty");
    }
    _auth = Authentication(username, password);
    final bool ok = await _auth.authenticate();
    expect(ok, equals(true));
  });

  test('getURL', () async {
    expect(_auth.isAuthenticated, equals(true));

    final AgendaURL agendaURL = AgendaURL(_auth);
    final Option<String> urlOpt = await agendaURL.getURL();
    final String url = urlOpt.toNullable() ?? "";
    expect(url.isNotEmpty, equals(true));
    expect(url.contains(RegExp("resources=[0-9,]+&")), equals(true));
    expect(url.contains(RegExp("projectId=[0-9]+&")), equals(true));
  });

  tearDownAll(() async {
    _auth.logout();
  });
}
