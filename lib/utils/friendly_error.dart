String friendlyErrorMessage(
  Object? error, {
  String fallback = 'Something went wrong. Please try again.',
}) {
  final raw = (error ?? '').toString();
  final text = raw.toLowerCase();

  if (text.contains('valid distributorid is required') ||
      text.contains('distributor id missing') ||
      text.contains('distributorid')) {
    return 'Please select a distributor before viewing products.';
  }
  if (text.contains('socket') ||
      text.contains('network') ||
      text.contains('connection') ||
      text.contains('timeout') ||
      text.contains('failed host lookup')) {
    return 'Please check your internet connection and try again.';
  }
  if (text.contains('401') || text.contains('unauthorized')) {
    return 'Your session has expired. Please sign in again.';
  }
  if (text.contains('403') || text.contains('forbidden')) {
    return 'You do not have permission to perform this action.';
  }
  if (text.contains('404') || text.contains('not found')) {
    return 'The requested information could not be found.';
  }
  if (text.contains('400') || text.contains('validation')) {
    return 'Some required information is missing or invalid. Please review and try again.';
  }
  if (text.contains('500') ||
      text.contains('server') ||
      text.contains('internal')) {
    return 'The service is temporarily unavailable. Please try again in a moment.';
  }

  return fallback;
}
