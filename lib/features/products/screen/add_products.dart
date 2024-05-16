import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uae_task/features/products/controller/product_controller.dart';
import 'package:uae_task/models/product_model.dart';
import '../../../core/global_variables/global_variables.dart';
import 'package:image_picker/image_picker.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  /// TextEditingController
  TextEditingController productName=TextEditingController();
  TextEditingController mrp=TextEditingController();
  TextEditingController qty=TextEditingController();
  /// image url
  final imgProvider = StateProvider<File?>((ref) {
    return null;
  });
  /// image pick function

  /// add product functio
  Future<void> pickImg(source ,WidgetRef ref ) async {
    final imageFile=await ImagePicker.platform.getImageFromSource(source:source);
    ref.read(imgProvider.notifier).update((state) => File(imageFile!.path));
  }
  addProduct({required BuildContext context,required WidgetRef ref}){
    print("sssssssssssssssssssssss");
    ProductModel productModel=ProductModel(name: productName.text.trim(),
        mrp: double.parse(mrp.text.trim()),
        qty: int.parse(qty.text.trim()),
        photo: "",
        id: "",
        search: setSearchParam(productName.text.toUpperCase().trim()),
        createdTime: DateTime.now());
    ref.read(productControllerProvider.notifier).addProduct(productModel: productModel,
        context: context,img: ref.read(imgProvider)!);
    productName.clear();
    mrp.clear();
    qty.clear();
    ref.read(imgProvider.notifier).update((state) => null);
    Navigator.pop(context);
  }
  /// add confirm alert
  void confirmBox({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    showDialog(
      context: context,
      builder: (context1) => AlertDialog(
        contentTextStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 16.0,
        ),
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(20.0),
        content: const SizedBox(
          width: 250.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are sure add this product?",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(100.0, 50.0),
              backgroundColor: Colors.grey[300],
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              addProduct(context: context, ref: ref);
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(100.0, 50.0),
              backgroundColor: Colors.blue,
            ),
            child:const Text(
              "Add",
              style:  TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    productName.dispose();
    mrp.dispose();
    qty.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          leading: InkWell(hoverColor: Colors.transparent,
              onTap: () => Navigator.pop(context),
              child:const Icon(Icons.arrow_back,)),
          title: Text("Add Product",style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: width*(0.05)
          ),),
        ),
        body: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height*(0.03),),
                Consumer(
                  builder: (context,ref,child) {
                    final image=ref.watch(imgProvider);
                    return Column(
                      children: [
                       image!=null ?IconButton(
                          onPressed: () {
                            ref.read(imgProvider.notifier).update((state) => null);
                          },
                          hoverColor: Colors.transparent,
                          icon: Icon(Icons.delete,color: Colors.red,
                          size: width*(0.08),),
                        )
                        :const SizedBox(),
                        Container(
                          width: width*(0.5),
                          height: height*(0.3),
                    decoration: BoxDecoration(
                        color: Colors.white,
                      border:  Border.all(color: Colors.black87)
                    ),
                          child: image==null?IconButton(
                            onPressed: () async {
                              pickImg(ImageSource.gallery, ref);
                            },
                            hoverColor: Colors.transparent,
                            icon: Icon(Icons.add,color: Colors.black,
                            size: width*(0.1),),
                          )
                          :Image.file(image,
                          fit: BoxFit.fill,),
                        ),
                      ],
                    );
                  }
                ),
                SizedBox(height: height*(0.03),),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: width*0.8,
                      height: height*0.08,
                      child: TextFormField(
                        cursorColor: Colors.orange,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          var val = value ?? '';
                          if (val.isEmpty) {
                            return 'Please enter Username';
                          }
                          return null;
                        },
                        controller: productName,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          labelStyle: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: const Color(0xFF57636C),
                            fontSize: width*0.035,
                            fontWeight: FontWeight.normal,
                          ),
                          hintText: 'Please Enter Product Name',
                          hintStyle: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: const Color(0xFF57636C),
                            fontSize: width*0.035,
                            fontWeight: FontWeight.normal,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color:Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(top: height*0.015,left: width*0.05),
                        ),
                        style:TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: const Color(0xFF1D2429),
                          fontSize: width*0.035,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width*0.8,
                      height: height*0.08,
                      child: TextFormField(
                        cursorColor: Colors.orange,
                        keyboardType:
                        const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^(\d+)?\.?\d{0,2}'))
                        ],
                        validator: (value) {
                          RegExp regex = RegExp(r'^\d+(\.\d+)?$');
                          if (!regex.hasMatch(value!)|| value=="0") {
                            return "Enter only numbers";
                          }
                          return null;
                        },
                        controller: mrp,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'MRP',
                          labelStyle: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: const Color(0xFF57636C),
                            fontSize: width*0.035,
                            fontWeight: FontWeight.normal,
                          ),
                          hintText: 'Please Enter MRP',
                          hintStyle: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: const Color(0xFF57636C),
                            fontSize: width*0.035,
                            fontWeight: FontWeight.normal,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:  const BorderSide(
                              color:Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(top: height*0.015,left: width*0.05),
                        ),
                        style:TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: const Color(0xFF1D2429),
                          fontSize: width*0.035,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width*0.8,
                      height: height*0.08,
                      child: TextFormField(
                        cursorColor: Colors.orange,
                        keyboardType:
                        const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          RegExp regex = RegExp(
                              r'^\d+(\.\d+)?$');
                          if (!regex.hasMatch(value!)||value=="0") {
                            return "Please Enter the Quantity";
                          }
                          return null;
                        },
                        controller: qty,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          labelStyle: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: const Color(0xFF57636C),
                            fontSize: width*0.035,
                            fontWeight: FontWeight.normal,
                          ),
                          hintText: 'Please Enter Quantity',
                          hintStyle: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: const Color(0xFF57636C),
                            fontSize: width*0.035,
                            fontWeight: FontWeight.normal,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color:Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(top: height*0.015,left: width*0.05),
                        ),
                        style:TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: const Color(0xFF1D2429),
                          fontSize: width*0.035,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                Consumer(
                  builder: (context,ref,child) {
                    return ElevatedButton(onPressed: () {
                      if(formKey.currentState!.validate())
                        {
                          confirmBox(context: context, ref: ref);
                        }
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      backgroundColor: Colors.blue,
                      fixedSize: Size(width*(0.5), height*(0.06))
                    ),
                        child: const Text("Add Product"),);
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
