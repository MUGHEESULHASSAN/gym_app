
DateTime addPlanToStartDate(DateTime start, String plan) {
  switch (plan) {
    case '1 Month':
      return DateTime(start.year, start.month + 1, start.day);
    case '3 Months':
      return DateTime(start.year, start.month + 3, start.day);
    case '1 Year':
      return DateTime(start.year + 1, start.month, start.day);
    default:
      return start;
  }
}
