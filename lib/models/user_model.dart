import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String name;
  final String password;
  final String role;
  final String id;
  final List<String> cart;
  final DocumentReference? reference;
  final DateTime createdTime;

  const UserModel({
    required this.name,
    required this.password,
    required this.role,
    required this.id,
    required this.cart,
    this.reference,
    required this.createdTime,
  });

  UserModel copyWith({
    String? name,
    String? password,
    String? role,
    String? id,
    List<String>? cart,
    DocumentReference? reference,
    DateTime? createdTime,
  }) {
    return UserModel(
      name: name ?? this.name,
      password: password ?? this.password,
      role: role ?? this.role,
      id: id ?? this.id,
      reference: reference ?? this.reference,
      cart: cart ?? this.cart,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'password': password,
      'role': role,
      'id': id,
      'cart': cart,
      'reference': reference,
      'createdTime': createdTime,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name']??"",
      password: map['password'] ??"",
      role: map['role'] ?? "",
      id: map['id'] as String,
      cart:List<String>.from((map['cart']),),
      reference: map['reference'] as DocumentReference,
      createdTime: map['createdTime'].toDate(),
    );
  }

//</editor-fold>
}