import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class Neo4JConnect {
  Future<String> executeQuery(String q, String fn) async {
    final client = HttpClient();
    final uri = Uri.parse('http://localhost:3000$fn');
    final request = await client.postUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    request.write(jsonEncode({'query': q}));
    final response = await request.close();
    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final parsedResponse = json.decode(responseBody);
      if (fn != '/') {
        if (parsedResponse['props'] == null) {
          return "Something went wrong. Please try again";
        }
        return parsedResponse['props'].toString();
      } else {
        if (parsedResponse['titles'] == null) {
          return "Something went wrong. Please try again with different wordings";
        }
        return convertNestedListsToNewLines(parsedResponse['titles']);
      }
    } else {
      log("Some error occurred");
    }
    client.close();
    return "Something Went Wrong";
  }

  String convertNestedListsToNewLines(List<dynamic> inputList) {
    final List<String> lines = [];

    void extractStrings(List<dynamic> list) {
      for (final item in list) {
        if (item is List<dynamic>) {
          extractStrings(item);
        } else {
          if(item is! String && item['low'] != null){
            lines.add(item['low'].toString());
          }else{
            lines.add(item.toString());
          }
        }
      }
    }

    extractStrings(inputList);

    return lines.join('\n');
  }
}
