import 'package:http/http.dart' as http;

class Network {
  Future<dynamic> getPage(link) async {
    var url = Uri.parse(link);
    var response = await http.get(url);
    return response.body;
  }
}
