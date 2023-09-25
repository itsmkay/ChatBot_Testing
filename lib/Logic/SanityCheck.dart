class SanityCheck{

  static bool isDeleteQuery(String query) {
    String uppercaseQuery = query.toUpperCase();
    return uppercaseQuery.contains("DELETE") || uppercaseQuery.contains("REMOVE");
  }

  static bool isWriteQuery(String query) {
    String uppercaseQuery = query.toUpperCase();
    return uppercaseQuery.contains("CREATE") || uppercaseQuery.contains("SET");
  }

  static bool isCypherQuery(String text) {
    List<String> cypherKeywords = ["MATCH", "CREATE", "MERGE", "DELETE", "SET", "RETURN", "WHERE", "UNWIND"];
    String uppercaseText = text.toUpperCase();
    for (String keyword in cypherKeywords) {
      if (uppercaseText.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

}