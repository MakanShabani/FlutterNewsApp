class HelperMethods {
  static bool isTokenExpired(DateTime expireAt) {
    return expireAt.isBefore(DateTime.now());
  }

  static String calculateTimeForRepresetingInUI(DateTime time) {
    //calculate the diffrence between current time and the input time
    Duration diffrenceFromNow = DateTime.now().difference(time);

    //calculate the representing text in yeras/months/weeks/days if the difference is eqaul or more than 1 day
    if (diffrenceFromNow.inDays >= 1) {
      if (diffrenceFromNow.inDays >= 365) {
        int tempYears = diffrenceFromNow.inDays ~/ 365;
        return '$tempYears ${tempYears > 1 ? 'years' : 'year'} ago';
      }
      if (diffrenceFromNow.inDays >= 30) {
        int tempMonths = diffrenceFromNow.inDays ~/ 30;
        return '$tempMonths ${tempMonths > 1 ? 'months' : 'month'} ago';
      }
      if (diffrenceFromNow.inDays >= 7) {
        int tempWeeks = diffrenceFromNow.inDays ~/ 7;
        return '$tempWeeks ${tempWeeks > 1 ? 'weeks' : 'week'} ago';
      }
      return '${diffrenceFromNow.inDays} ${diffrenceFromNow.inDays > 1 ? 'days' : 'day'} ago';
    }

    //calculate the representing text in hours if the difference is eqaul or more than 1 hours && less than 1 day
    if (diffrenceFromNow.inHours >= 1) {
      return '${diffrenceFromNow.inHours} ${diffrenceFromNow.inHours > 1 ? 'hours' : 'hour'} ago';
    }

    //calculate the representing text in minutes if the difference is eqaul or more than 1 minute && less than 1 hour
    if (diffrenceFromNow.inMinutes >= 1) {
      return '${diffrenceFromNow.inMinutes} ${diffrenceFromNow.inMinutes > 1 ? 'minutes' : 'minute'} ago';
    }

    //calculate the representing text in seconds if the difference is eqaul or more than 1 seconds && less than 1 minute
    return '${diffrenceFromNow.inSeconds} ${diffrenceFromNow.inSeconds > 1 ? 'seconds' : 'second'} ago';
  }
}
