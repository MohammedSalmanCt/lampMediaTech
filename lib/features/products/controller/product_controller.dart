import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uae_task/core/commons/storage_repository.dart';
import 'package:uae_task/features/products/repository/product_repository.dart';
import '../../../core/utils.dart';
import '../../../models/product_model.dart';

final productControllerProvider = NotifierProvider<ProductController,bool>(() {
  return ProductController();
});

final getProductsProvider = StreamProvider.family.autoDispose((ref,String search)  {
  return ref.watch(productControllerProvider.notifier).getProducts(search);
});

final getProductModelProvider = StreamProvider.family.autoDispose((ref,String id)  {
  return ref.watch(productControllerProvider.notifier).getProductModel(id);
});
class ProductController extends Notifier<bool>{
  @override
  bool build() {
    // TODO: implement build
    return false;
  }
  ProductRepository get _productRepository=>ref.read(productRepositoryProvider);
  StorageRepository get _storageRepository=>ref.read(storageRepositoryProvider);
/// add product
   addProduct({required ProductModel productModel,required BuildContext context,required File img}) async {
     state =true;
     final storage=await _storageRepository.getImageUrl(file: img,path:"Products/${DateTime
         .now().microsecondsSinceEpoch}");
     storage.fold((l) => showSnackBarOfFailure(context, l.message), (imgUrl) async {
       final product=await _productRepository.addProduct(productModel: productModel,imgUrl: imgUrl);
       product.fold((l) => showSnackBarOfFailure(context,l.message), (r) {
         return showSnackBarOfSuccess(context, "Product added successfully");
       });
     });
     state=false;
   }
   /// product stream
  Stream<List<ProductModel>> getProducts(String search)
  {
    return _productRepository.getProducts(search);
  }
  Stream<ProductModel> getProductModel(String id)
  {
    return _productRepository.getProductModel(id);
  }
}