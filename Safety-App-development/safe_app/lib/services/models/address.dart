/**
 * localdb.dart
 * 
 * contains  adress data that is locally stored on the phone
 * 
 * 
 * 
 * author @musabisimwa @diri0060
 * 
 */

class Address {
  final int id;
  final String address;
  final String name;
  Address({required this.id, required this.address, required this.name});

  Address.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        address = res["address"];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'address': address};
  }
}
