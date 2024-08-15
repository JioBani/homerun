enum AgeRange {
  twenties('20대'),
  thirties('30대'),
  forties('40대'),
  fifties('50대'),
  sixtiesPlus('60대이상');

  final String label;

  const AgeRange(this.label);

  static AgeRange? fromString(String label) {
    for (var value in AgeRange.values) {
      if (value.label == label) {
        return value;
      }
    }
    return null;
  }
}
