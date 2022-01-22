import 'package:http/http.dart' as http;

class Network {
  Future<dynamic> getPage(link) async {
    var url = Uri.parse('http://koto.org.tr/$link');
    var response = await http.get(url);
    return response.body;
  }
}
