import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testing/Logic/Neo4JConnect.dart';
import 'package:testing/Logic/SanityCheck.dart';

import '../Constants/Constant.dart';

class CypherChatBot {

  Future<String> constructCypher(String question) async {

    String systemMessage = await constructSystemMessage();

    List<Map<String, dynamic>> messages = [
      {"role": "system", "content": systemMessage},
      {"role": "user", "content": question},
    ];

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${Constant.API_KEY}",
    };

    final data = {
      "model": Constant.GPT_MODEL,
      "temperature": 0.0,
      "max_tokens": 1000,
      "messages": messages,
    };

    //Converting Natural Language Query to Cypher Query
    final response = await http.post(Uri.parse(Constant.apiEndpoint), headers: headers, body: jsonEncode(data));
    final jsonResponse = jsonDecode(response.body);
    String cypherQuery = jsonResponse["choices"][0]["message"]["content"];

    //Sanity Checking
    cypherQuery = cypherQuery.replaceAll('\n', ' ');
    if(!SanityCheck.isCypherQuery(cypherQuery)) return cypherQuery;
    if(SanityCheck.isDeleteQuery(cypherQuery) ||
        SanityCheck.isWriteQuery(cypherQuery)) return Constant.SANITY_MSG;

    //Executing Query on Database
    Neo4JConnect neo4j = Neo4JConnect();
    String ans = await neo4j.executeQuery(cypherQuery, '/');

    //Returning the Response
    if(ans.isEmpty) return "No Results";
    return ans;
  }

  Future<String> constructSystemMessage() async {
    Neo4JConnect neo4j = Neo4JConnect();

    String nodeProps = await neo4j.executeQuery(Constant.NODE_PROPERTIES_QUERY, Constant.DB_PROPS_URL);
    String relProps = await neo4j.executeQuery(Constant.REL_PROPERTIES_QUERY, Constant.DB_PROPS_URL);
    String relations = await neo4j.executeQuery(Constant.REL_QUERY, Constant.DB_PROPS_URL);

    String schema = "This is the schema representation of the Neo4j database. \n\nNode properties are the following:  $nodeProps\n\nRelationship properties are the following:  $relProps\n\nRelationship point from source to target nodes $relations Make sure to respect relationship types and directions";
    String sysMsg = "Task: Generate Cypher queries to query a Neo4j graph database based on the provided schema definition. \nInstructions: Use only the provided relationship types and properties. \nDo not use any other relationship types or properties that are not provided. \nIf you cannot generate a Cypher statement based on the provided schema, explain the reason to the user. \n\nSchema: $schema\n\nNote: Do not include any explanations or apologies in your responses and return only the query. and WRITE THE WHOLE QUERY IN A SINGLE LINE DO NOT GIVE LINE BREAKS";

    return sysMsg;
  }
}
