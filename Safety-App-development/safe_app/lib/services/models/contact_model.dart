///
///App contact
///@musabisimwa ,iman dirie
///
///model to structure contacts for persistent storage
///
/// 
class AppContact {
  int id; // auto generated
  String name;
  int? priority; //1-10
  String? phoneNumber;
  bool chose = false;
  bool addToDb = false;
  AppContact(
      {required this.id,
      required this.phoneNumber,
      required this.name,
      this.priority});

  AppContact.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        priority = res["priority"],
        phoneNumber = res["phoneNumber"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'priority': priority,
    };
  }
}
