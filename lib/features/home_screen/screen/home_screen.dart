import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uae_task/core/commons/error_text.dart';
import 'package:uae_task/core/commons/loader.dart';
import 'package:uae_task/features/cart/screen/cart_screen.dart';
import 'package:uae_task/features/products/controller/product_controller.dart';
import 'package:uae_task/features/products/screen/add_products.dart';
import 'package:uae_task/features/products/screen/product_screen.dart';
import '../../../core/global_variables/global_variables.dart';
import '../../../models/product_model.dart';
import '../../authentication/controller/auth_controller.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// logout function
    void logOut({required WidgetRef ref, required BuildContext context}) {
      ref.read(authControllerProvider.notifier).logOut(context);
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          leading: Consumer(
            builder: (context,ref,child) {
              return IconButton(onPressed: () {
                logOut(ref: ref, context: context);
              }, icon: const Icon(Icons.logout,),
                tooltip:"LogOut",);
            }
          ),
          title: Text(
            "DashBoard"
          ),
          actions: [
            IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(),));
            }, icon: Icon(Icons.shopping_cart,))
          ],
        ),
        body: Padding(
          padding:  EdgeInsets.all(width*(0.02)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Products",style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: width*(0.05)
                  ),),
                  Row(
                    children: [
                      Text("SeeAll",style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                          fontSize: width*(0.03)
                      ),),
                      SizedBox(width: width*(0.02),),
                      IconButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen(),));
                      } , icon: Icon(Icons.arrow_forward)),
                    ],
                  ),
                ],
              ),
              Consumer(
                builder: (context, ref, child) {
                return  ref.watch(getProductsProvider("")).when(data: (productList) {
                    return  Container(
                      height: height*(0.81),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:const
                        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: productList.length<6?productList.length:6,
                        itemBuilder: (context, index) {
                          return buildContainer(product:productList[index]);
                        },),
                    );
                  },
                      error: (error, stackTrace) {
                        print(error);
                        return ErrorText(error: error.toString());
                      },
                      loading: () =>const Loader(),);
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddProducts(),));
        },
          child: Icon(Icons.add,
          color: Colors.black,),
          backgroundColor: Colors.blue,
          tooltip: "Add Product",
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
   ///  product Container
   Card buildContainer({required ProductModel product}) {
     return Card(
       elevation: 4,
       child: SizedBox(
         width: width*(0.35),
         height: height*(0.26),
         child: Column(
           children: [
             Image.network(product.photo,width: width*(0.32),
               height: height*(0.15),
               fit: BoxFit.fill,
               alignment: Alignment.center,
             ),
             SizedBox(height: height*(0.02),),
             Text(product.name),
           ],
         ),
       ),
     );
   }
}
