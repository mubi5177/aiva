mixin Validator {
  String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Enter a valid Email';
    } else {
      bool isValidEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+", caseSensitive: false).hasMatch(email);
      if (isValidEmail) {
        return null;
      } else {
        return 'Enter a valid Email';
      }
    }
  }

  String? validateUsername(String? username) {
    if (username!.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? validateName(String? name) {
    if (name!.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validateSurname(String? surname) {
    if (surname!.isEmpty) {
      return 'Surname is required';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password!.isEmpty) {
      return 'Password is required';
    } else if (password.length < 8) {
      return 'Password length must be 8 character long';
    }
    return null;
  }

  String? validatePasswordRequired(String? password) {
    if (password!.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword!.isEmpty) {
      return 'Confirm Password is required';
    } else if (confirmPassword.length < 8) {
      return 'Password length must be 8 character long';
    } else if (password != confirmPassword) {
      return 'Password does not match';
    }
    return null;
  }

  String? validateOTP(String? otp) {
    if (otp!.isEmpty) {
      return 'OTP is required';
    } else if (otp.length < 6) {
      return 'OTP length must be six digit';
    }
    return null;
  }

  bool validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty || phoneNumber.length < 11 || phoneNumber.length > 11) {
      return false;
    }
    return true;
  }

  String? validateStartDateTime(String? eventDate) {
    if (eventDate!.isEmpty) {
      return 'Event Start Date and Time is required';
    }
    return null;
  }

  String? validateEndDateTime(String? eventDate) {
    if (eventDate!.isEmpty) {
      return 'Event End Date and Time is required';
    }
    return null;
  }

  String? validateImage(String? image) {
    if (image!.isEmpty) {
      return 'Event Image is required';
    }
    return null;
  }

  String? validateBio(String? bio) {
    if (bio!.isEmpty) {
      return 'Bio is required';
    }
    return null;
  }
}
