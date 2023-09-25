final class Constant {
  static const String API_KEY = "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";
  static const String NEO4J_URL = 'neo4j+s://0d27134e.databases.neo4j.io';
  static const String DB_USERNAME = 'neo4j';
  static const String DB_PASSWORD = '9DwsMQnvpkPYaoNl7fPDWHPJAtemS8jl9SiuBR8XslE';
  static const String NODE_PROPERTIES_QUERY = "CALL apoc.meta.data() YIELD label, other, elementType, type, property WHERE NOT type = \"RELATIONSHIP\" AND elementType = \"node\" WITH label AS nodeLabels, collect(property) AS properties RETURN {labels: nodeLabels, properties: properties} AS output";
  static const String REL_PROPERTIES_QUERY = "CALL apoc.meta.data() YIELD label, other, elementType, type, property WHERE NOT type = \"RELATIONSHIP\" AND elementType = \"relationship\" WITH label AS nodeLabels, collect(property) AS properties RETURN {type: nodeLabels, properties: properties} AS output";
  static const String REL_QUERY = "CALL apoc.meta.data() YIELD label, other, elementType, type, property WHERE type = \"RELATIONSHIP\" AND elementType = \"node\" RETURN {source: label, relationship: property, target: other} AS output";
  static const String DB_PROPS_URL = "/get_db_props";
  static const String SANITY_MSG = "Database modifications are not allowed via frontend";
  static const String GPT_MODEL = "gpt-3.5-turbo"; //gpt-3.5-turbo //gpt-4
  static const String apiEndpoint = "https://api.openai.com/v1/chat/completions";
}