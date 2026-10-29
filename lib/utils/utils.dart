class Utils{
  static String convertDateFormat(String inputDate) {
    // Split the input string by 'T' and take the first part
    List<String> parts = inputDate.split('T');
    // Split the date part by '-' and store year, month, and day
    List<String> dateParts = parts[0].split('-');
    // Re-arrange the date in the required format
    String formattedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
    return formattedDate;
  }

  static String convertTimeFormat(String inputTime) {
    // Split the input string by 'T' and take the second part
    List<String> parts = inputTime.split('T');
    // Split the time part by ':' and store hour and minute
    List<String> timeParts = parts[1].split(':');
    // Re-arrange the time in the required format
    String formattedTime =
        '${timeParts[0]}:${timeParts[1]}:${timeParts[2].substring(0, 2)}';
    return formattedTime;
  }

}