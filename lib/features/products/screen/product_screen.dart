import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:uae_task/features/authentication/controller/auth_controller.dart';
import 'package:uae_task/features/cart/controller/cart_controller.dart';
import 'package:uae_task/features/products/controller/product_controller.dart';
import '../../../core/commons/error_text.dart';
import '../../../core/commons/loader.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/global_variables/global_variables.dart';
import '../../../models/product_model.dart';
import '../../../models/user_model.dart';
import '../../cart/screen/cart_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController searchController=TextEditingController();

  /// logout function
  void logOut({required WidgetRef ref, required BuildContext context}) {
    ref.read(authControllerProvider.notifier).logOut(context);
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Consumer(
          builder: (context,ref,child) {
            final userModel=ref.watch(userProvider)!;
            return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            automaticallyImplyLeading: userModel.role=="Admin"?true:false,
            title: Text(
              "Products",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: width * (0.05)),
            ),
                    actions: [
                     userModel.role!="Admin" ?IconButton(onPressed: () {
                       logOut(ref: ref, context: context);
                      }, icon: const Icon(Icons.logout,),
                     tooltip:"LogOut",)
                         :const SizedBox()
                    ],
                  ),
                  body: Padding(
                    padding:  EdgeInsets.only(right:width*(0.05),left: width*(0.05),top: width*(0.05), ),
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Consumer(
                              builder: (context, ref, child) {
                                return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black)
                                    ),
                                    width: width*0.8,
                                    height: height*0.06,
                                    child: TextFormField(
                                      controller: searchController,
                                      cursorColor: Colors.orange,
                                      onChanged: (value) {
                                        ref
                                            .read(searchProvider.notifier)
                                            .update((state) => value.trim());
                                      },
                                      style:
                                      const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(onPressed: () {
                                          searchController.clear();
                                          ref.read(searchProvider.notifier).update((state) => "");
                                        }, icon: Icon(Icons.clear,color: Colors.black,
                                          size: width*(0.05),)),
                                        border: InputBorder.none,
                                        hintText: 'Search Product',
                                        hintStyle: TextStyle(
                                            fontSize: width * (0.05),
                                            color: Colors.black),
                                        contentPadding: EdgeInsetsDirectional.only(start: width*(0.01)),
                                      ),
                                    )
                                );
                              }
                          ),
                          SizedBox(height: height*(0.05),),
                          Consumer(
                              builder: (context, ref, child) {
                                final search = ref.watch(searchProvider);
                                return ref.watch(userStreamProvider(userModel.id)).when(data: (user) {
                                  return ref.watch(getProductsProvider(search)).when(
                                    data: (productList) {
                                      if(productList.isEmpty)
                                        {
                                       return   SizedBox(
                                            height: height * 0.4,
                                            width: width ,
                                            child: Center(
                                              child: Lottie.asset(
                                                  AssetConstants.noDataLottie),
                                            ),
                                          );
                                        }
                                     else{
                                        return SingleChildScrollView(
                                          child: Container(
                                            height: height*(0.765),
                                            width: width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: GridView.builder(
                                              padding: EdgeInsetsDirectional.only(bottom: width*(0.02)),
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: width / height * 1.3,
                                              ),
                                              itemCount: productList.length,
                                              itemBuilder: (context, index) {
                                                return buildContainer(
                                                  product: productList[index],
                                                  ref: ref,
                                                  userModel: user,
                                                  context: context,
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    error: (error, stackTrace) {
                                      print(error);
                                      return ErrorText(error: error.toString());
                                    },
                                    loading: () => const Loader(),
                                  );
                                },error: (error, stackTrace) {
                                  print(error);
                                  return ErrorText(error: error.toString());
                                },
                                  loading: () => const Loader(),
                                );
                              }
                          )
                        ],
                      ),
                    ),
                  ),
              floatingActionButton: FloatingActionButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(),));
              },
                child: Icon(Icons.add_shopping_cart,
                  color: Colors.black,),
                backgroundColor: Colors.blue,
                tooltip: "Cart",
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
                );
          }
        ));
  }
  ///  product Container
  Card buildContainer({required ProductModel product,required WidgetRef ref,
    required UserModel userModel,required BuildContext context}) {
  /// add to cart
    addToCart({required ProductModel productModel,required BuildContext context}){
      ref.read(cartControllerProvider.notifier).addToCart(productModel: productModel, context: context);
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
               if(!userModel.cart.contains(product.id))
                 {
                   addToCart(productModel: product, context: context);
                 }
              },
                style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    backgroundColor:!userModel.cart.contains(product.id)? Colors.blue:Colors.green,
                    fixedSize: Size(width*(0.5), height*(0.06))
                ),
                child:  Text(!userModel.cart.contains(product.id)?"Add To Cart":"Item in cart"),)
            ],
          )

        ],
      ),
    );
  }
}
