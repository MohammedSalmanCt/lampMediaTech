import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uae_task/features/authentication/controller/auth_controller.dart';
import '../../../core/commons/error_text.dart';
import '../../../core/commons/loader.dart';
import '../../../core/global_variables/global_variables.dart';
import '../../../models/product_model.dart';
import '../../../models/user_model.dart';
import '../../products/controller/product_controller.dart';
import '../controller/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            leading: InkWell(
                hoverColor: Colors.transparent,
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                )),
            title: Text(
              "Cart page",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: width * (0.05)),
            ),
          ),
          body: Consumer(
            builder: (context, ref, child) {
              final user=ref.watch(userProvider)!;
              return ref.watch(userStreamProvider(user.id)).when(data: (userModel) {
                return Padding(
                    padding:  EdgeInsets.all(width*(0.05)),
                    child:   userModel.cart.isNotEmpty?
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: width/height*1.3),
                        itemCount: userModel.cart.length ,
                        itemBuilder: (context, index) {
                          return ref.watch(getProductModelProvider(userModel.cart[index])).when(data: (productModel) {
                            return buildContainer(product: productModel,ref: ref,userModel: userModel,context: context);
                          },
                            error: (error, stackTrace) {
                              print(error);
                              return ErrorText(error: error.toString());
                            },
                            loading: () => const Loader(),
                          );
                        },
                      ),
                    )
                      :SizedBox(
                    height: height ,
                    width: width ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Cart is Empty",style: TextStyle(color: Colors.black,fontSize: width*(0.1),fontWeight: FontWeight.w400),),
                        SizedBox(height: height*(0.02),),
                        Icon(Icons.remove_shopping_cart_outlined,color: Colors.black45,
                            size: width*(.7),),
                      ],
                    ),
                  )
                );
              },
                error: (error, stackTrace) {
                  print(error);
                  return ErrorText(error: error.toString());
                },
                loading: () => const Loader(),
              );
            },
          ),
        ));
  }

  ///  cart Container
  Card buildContainer({required ProductModel product,required WidgetRef ref,
    required UserModel userModel,required BuildContext context}) {
    /// remove from cart
    removeFromCart({required ProductModel productModel,required BuildContext context}){
      ref.read(cartControllerProvider.notifier).removeFromCart(productModel: productModel, context: context);
    }
    return Card(
      elevation: 4,
      child: Column(
        children: [
         Image.network(product.photo,width: width*(0.32),
              height: height*(0.15),
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          SizedBox(height: height*(0.02),),
          Text(product.name),
          Column(
            children: [
              SizedBox(height: height*(0.02),),
              Text(product.mrp.toStringAsFixed(2)),
              SizedBox(height: height*(0.02),),
              ElevatedButton(onPressed: () {
                if(userModel.cart.contains(product.id))
                {
                  removeFromCart(productModel: product, context: context);
                }
              },
                style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    backgroundColor:Colors.red,
                    fixedSize: Size(width*(0.5), height*(0.06))
                ),
                child:  Text("Remove"),)
            ],
          )

        ],
      ),
    );
  }
}
