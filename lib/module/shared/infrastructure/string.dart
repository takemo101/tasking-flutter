class StringHelper {
  static String limit(
    String text, {
    int limit = 16,
    String suffix = '...',
  }) {
    return limit < text.length ? text.substring(0, limit) + suffix : text;
  }
}
