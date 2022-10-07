import 'package:dartus/tomuss.dart';
import 'package:dartz/dartz.dart';
import 'package:lyon1agenda/src/utils/agenda_url.dart';
import 'package:test/test.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  late Authentication auth;
  DotEnv env = DotEnv(includePlatformEnvironment: true);
  setUpAll(() async {
    env.load();
    final String username = env['USERNAME'] ?? "";
    final String password = env['PASSWORD'] ?? "";
    if (username.isEmpty || password.isEmpty) {
      throw Exception(
          "Check your .env file, username and/or password are empty");
    }
    auth = Authentication(username, password);
    final bool ok = await auth.authenticate();
    expect(ok, equals(true));
  });

  test('getURL', () async {
    expect(auth.isAuthenticated, equals(true));

    final AgendaURL agendaURL = AgendaURL(auth);
    final Option<String> urlOpt = await agendaURL.getURL();
    final String url = urlOpt.toNullable() ?? "";
    expect(url.isNotEmpty, equals(true));
    expect(url.contains(RegExp("resources=[0-9,]+&")), equals(true));
    expect(url.contains(RegExp("projectId=[0-9]+&")), equals(true));
  });

  tearDownAll(() async {
    auth.logout();
  });
}
