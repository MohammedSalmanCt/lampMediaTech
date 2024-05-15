import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uae_task/core/constants/firebase_constants.dart';
import 'package:uae_task/core/failure.dart';
import 'package:uae_task/core/providers/firebase_providers.dart';
import 'package:uae_task/core/type_def.dart';
import 'package:uae_task/models/product_model.dart';

final productRepositoryProvider = StateProvider<ProductRepository>((ref) {
  return ProductRepository(firestore: ref.watch(firestoreProvider));
});

class ProductRepository{
  final FirebaseFirestore _firestore;
  ProductRepository({required FirebaseFirestore firestore}):_firestore=firestore;

  CollectionReference get _product=>_firestore.collection(FirebaseConstants.productCollections);
/// add product
  FutureVoid addProduct({required ProductModel productModel,required String imgUrl})
  async {
    try{
    return  right(await _product.add(productModel.toMap()).then((value) async {
        ProductModel product=productModel.copyWith(id: value.id,
        reference: value,
          photo: imgUrl
        );
        return await value.set(product.toMap());
      }));
    }
    on FirebaseException catch(e){
      throw e.message!;
    }
    catch (e){
      return left(Failure(e.toString()));
    }
  }

  /// product stream
  Stream<List<ProductModel>> getProducts(String search)
  {
   return _product.where("search",arrayContains: search.isNotEmpty?search.toUpperCase():null)
        .orderBy("createdTime",descending: true).snapshots().map((event) {
          List<ProductModel> products=[];
          for(var i in event.docs)
            {
              products.add(ProductModel.fromMap(i.data() as Map<String,dynamic>));
            }
          return products;
    });
  }

  /// get productModel
  Stream<ProductModel> getProductModel(String id)
  {
   return _product.doc(id).snapshots().map((event)=> ProductModel.fromMap(event.data() as Map<String,dynamic>));
  }
}