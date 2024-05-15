import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uae_task/core/constants/firebase_constants.dart';
import 'package:uae_task/core/failure.dart';
import 'package:uae_task/core/providers/firebase_providers.dart';
import 'package:uae_task/core/type_def.dart';
import 'package:uae_task/models/product_model.dart';

import '../../../models/user_model.dart';

final cartRepositoryProvider = StateProvider<CartRepository>((ref) {
  return CartRepository(firestore: ref.watch(firestoreProvider));
});

class CartRepository{
  final FirebaseFirestore _firestore;
  CartRepository({required FirebaseFirestore firestore}):_firestore=firestore;

  CollectionReference get _user=>_firestore.collection(FirebaseConstants.userCollections);

  /// add to cart
  FutureVoid addToCart({required ProductModel productModel,required UserModel user})
  async {
    try{
        return right(user.reference!.update({
          "cart": FieldValue.arrayUnion([productModel.id])
        }));

    }
    on FirebaseException catch(e){
      throw e.message!;
    }
    catch (e){
      return left(Failure(e.toString()));
    }
  }
  /// remove from cart
  FutureVoid removeFromCart({required ProductModel productModel,required UserModel user})
  async {
    try{
       return right(user.reference!.update({
         "cart": FieldValue.arrayRemove([productModel.id])
       }));
     }
    on FirebaseException catch(e){
      throw e.message!;
    }
    catch (e){
      return left(Failure(e.toString()));
    }
  }
}