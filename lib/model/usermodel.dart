import 'package:cloud_firestore/cloud_firestore.dart'; 

class User {
  final String name;

  final String cpf;

  final String phone;

  final String email;

  final String? id;

  User(
      {required this.name,
      required this.cpf,
      required this.phone,
      required this.email,
      this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        cpf: json['cpf'],
        phone: json['phone'],
        email: json['email'],
        id: json['id']);
  }

  toJson() {
    return {'name': name, 'cpf': cpf, 'phone': phone, 'email': email, 'id': id};
  }
}
