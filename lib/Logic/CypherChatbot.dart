import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testing/Logic/Neo4JConnect.dart';

import '../Constants/Constant.dart';

class CypherChatBot {
  final String apiKey; // Replace with your OpenAI API key
  final String apiEndpoint = "https://api.openai.com/v1/chat/completions";

  CypherChatBot(this.apiKey);

  Future<String> constructCypher(String question) async {

    String systemMessage = await constructSystemMessage();

    List<Map<String, dynamic>> messages = [
      {"role": "system", "content": systemMessage},
      {"role": "user", "content": question},
    ];

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $apiKey",
    };

    final data = {
      "model": "gpt-3.5-turbo", //gpt-3.5-turbo //gpt-4
      "temperature": 0.0,
      "max_tokens": 1000,
      "messages": messages,
    };

    final response = await http.post(Uri.parse(apiEndpoint), headers: headers, body: jsonEncode(data));
    final jsonResponse = jsonDecode(response.body);
    String cypherQuery = jsonResponse["choices"][0]["message"]["content"];
    cypherQuery = cypherQuery.replaceAll('\n', ' ');
    Neo4JConnect neo4j = Neo4JConnect();
    String ans = await neo4j.executeQuery(cypherQuery, '/');
    if(ans.isEmpty) return "No Results";
    return ans;
  }

  Future<String> constructSystemMessage() async {
    Neo4JConnect neo4j = Neo4JConnect();

    String node_props = await neo4j.executeQuery(Constant.NODE_PROPERTIES_QUERY, Constant.DB_PROPS_URL);
    String rel_props = await neo4j.executeQuery(Constant.REL_PROPERTIES_QUERY, Constant.DB_PROPS_URL);
    String rels = await neo4j.executeQuery(Constant.REL_QUERY, Constant.DB_PROPS_URL);

    String schema = "This is the schema representation of the Neo4j database. \n\nNode properties are the following:  $node_props\n\nRelationship properties are the following:  $rel_props\n\nRelationship point from source to target nodes $rels Make sure to respect relationship types and directions";
    String sysMsg = "Task: Generate Cypher queries to query a Neo4j graph database based on the provided schema definition. \nInstructions: Use only the provided relationship types and properties. \nDo not use any other relationship types or properties that are not provided. \nIf you cannot generate a Cypher statement based on the provided schema, explain the reason to the user. \n\nSchema: $schema\n\nNote: Do not include any explanations or apologies in your responses and return only the query. and WRITE THE WHOLE QUERY IN A SINGLE LINE DO NOT GIVE LINE BREAKS";
    // print(sysMsg);
    return sysMsg;
  }
}
