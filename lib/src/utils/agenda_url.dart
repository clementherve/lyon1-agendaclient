import 'package:dartus/tomuss.dart';
import 'package:dartz/dartz.dart';
import 'package:lyon1agenda/src/constants/constants.dart';

class AgendaURL {
  final Authentication _authentication;
  AgendaURL(this._authentication);

  Future<Option<String>> getURL(
      {int days = 180, String resources = "", String projectid = ""}) async {
    final DateTime start = DateTime.now().add(Duration(days: -180));
    final DateTime end = DateTime.now().add(Duration(days: 180));
    return getURLForDates(start, end,
        resources_: resources, projectid_: projectid);
  }

  Future<Option<String>> getURLForDates(
      final DateTime start, final DateTime end,
      {String resources_ = "", String projectid_ = ""}) async {
    final String response = await _authentication
        .serviceRequest(Constants.adeWebURL, unsafe: false);

    final String projectID = RegExp("projectId=(.*?)[&\"]", multiLine: true)
            .firstMatch(response)
            ?.group(1) ??
        "";
    final String resources = RegExp("resources=(.*?)[&\"]", multiLine: true)
            .firstMatch(response)
            ?.group(1) ??
        "";
    return Some(await _getIcalURL(
        resources_.isNotEmpty ? resources_ : resources,
        projectid_.isNotEmpty ? projectid_ : projectID,
        _convertDate(start),
        _convertDate(end)));
  }

  Future<String> _getIcalURL(final String resources, final String projectid,
      final String start, final String end) async {
    return "http://adelb.univ-lyon1.fr/jsp/custom/modules/plannings/anonymous_cal.jsp?resources=$resources&projectId=$projectid&calType=ical&firstDate=$start&lastDate=$end";
  }

  String _convertDate(final DateTime dt) {
    return dt.toIso8601String().split("T")[0];
  }
}
