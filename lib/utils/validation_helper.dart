// class ValidationHelper {
//   static String? validateFullName(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your full name';
//     }
//     if (value.length < 2) {
//       return 'Name must be at least 2 characters';
//     }
//     return null;
//   }

//   static String? validateGarageName(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your garage name';
//     }
//     if (value.length < 2) {
//       return 'Garage name must be at least 2 characters';
//     }
//     return null;
//   }

//   static String? validatePhoneNumber(String? value) {
//     if (value != null && value.isNotEmpty) {
//       if (value.length < 10) {
//         return 'Please enter a valid phone number';
//       }
//     }
//     return null;
//   }

//   static String? validateBusinessType(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please select your business type';
//     }
//     return null;
//   }

//   static String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email address';
//     }
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) {
//       return 'Please enter a valid email address';
//     }
//     return null;
//   }

//   static String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your password';
//     }
//     if (value.length < 6) {
//       return 'Password must be at least 6 characters';
//     }
//     return null;
//   }

//   static String? validateConfirmPassword(String? value, String password) {
//     if (value == null || value.isEmpty) {
//       return 'Please confirm your password';
//     }
//     if (value != password) {
//       return 'Passwords do not match';
//     }
//     return null;
//   }
// }

class ValidationHelper {
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateGarageName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your garage/business name';
    }
    if (value.length < 2) {
      return 'Business name must be at least 2 characters';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length != 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  static String? validateBusinessType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select garage type';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
