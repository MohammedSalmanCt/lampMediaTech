import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
  final String name;
  final double mrp;
  final int qty;
  final String photo;
  final String id;
  final List<String> search;
  final DocumentReference? reference;
  final DateTime createdTime;

  const ProductModel({
    required this.name,
    required this.mrp,
    required this.qty,
    required this.photo,
    required this.id,
    this.reference,
    required this.search,
    required this.createdTime,
  });
  ProductModel copyWith({
    String? name,
    double? mrp,
    int? qty,
    String? photo,
    String? id,
    DocumentReference? reference,
    List<String>? search,
    DateTime? createdTime,
  }) {
    return ProductModel(
      name: name ?? this.name,
      mrp: mrp ?? this.mrp,
      qty: qty ?? this.qty,
      photo: photo ?? this.photo,
      id: id ?? this.id,
      search: search ?? this.search,
      reference: reference ?? this.reference,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mrp': mrp,
      'qty': qty,
      'photo': photo,
      'id': id,
      'search':search,
      'reference': reference,
      'createdTime': createdTime,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ??"",
      mrp: map['mrp']??0,
      qty: map['qty']??0,
      photo: map['photo']??"",
      id: map['id'] as String,
      search:List<String>.from((map['search']),),
      reference: map['reference'] as DocumentReference,
      createdTime: map['createdTime'].toDate(),
    );
  }

//</editor-fold>
}