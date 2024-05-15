import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uae_task/core/commons/storage_repository.dart';
import 'package:uae_task/core/global_variables/global_variables.dart';
import 'package:uae_task/features/cart/repository/cart_repository.dart';
import 'package:uae_task/features/products/repository/product_repository.dart';
import '../../../core/utils.dart';
import '../../../models/product_model.dart';
import '../../../models/user_model.dart';

final cartControllerProvider = NotifierProvider<CartController,bool>(() {
  return CartController();
});

class CartController extends Notifier<bool>{
  @override
  bool build() {
    // TODO: implement build
    return false;
  }
  CartRepository get _cartRepository=>ref.read(cartRepositoryProvider);

  /// add to cart
  addToCart({required ProductModel productModel,required BuildContext context})
  async {
    UserModel user=ref.read(userProvider)!;
    state =true;
   final cart=await _cartRepository.addToCart(productModel: productModel, user: user);
   cart.fold((l) => showSnackBarOfFailure(context, l.message), (r) =>showSnackBarOfSuccess(context,"Product added to cart"));
    state=false;
  }
  /// remove from cart
  removeFromCart({required ProductModel productModel,required BuildContext context})
  async {
    UserModel user=ref.read(userProvider)!;
    state =true;
   final cart=await _cartRepository.removeFromCart(productModel: productModel, user: user);
   cart.fold((l) => showSnackBarOfFailure(context, l.message), (r) =>showSnackBarOfSuccess(context,"Product removed from cart"));
    state=false;
  }

}