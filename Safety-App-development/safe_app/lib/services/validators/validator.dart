

class FieldValidator{

  //For the password validation..........
  static String? validatePassword(String? value) {
    if(value!.isEmpty)
      return "Enter Password";

    if(value.length < 6){
      return 'Password must be more than 16 character';
    }
    return null;
  }

  //For the Email Validation.........
  static String? validateEmail(String? value){
    return value!.isEmpty ? 'Email can\'t be empty' : null;
  }
}
