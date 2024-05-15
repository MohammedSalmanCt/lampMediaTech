import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uae_task/features/authentication/controller/auth_controller.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/global_variables/global_variables.dart';
import '../../../core/utils.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
 FocusNode f1=FocusNode();
 FocusNode f2=FocusNode();
  final passwordVisibilityProvider=StateProvider((ref) => false);
  final TextEditingController userName=TextEditingController();
  final TextEditingController password=TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  getLogin(WidgetRef ref,BuildContext context){
    if(userName.text.trim().isNotEmpty&&password.text.trim().isNotEmpty){
      ref.read(authControllerProvider.notifier).userLogin(userName: userName.text.trim(), password: password.text, context: context);
    }
    else{
      userName.text.trim().isEmpty?
      showSnackBarOfFailure(context,"Please Enter Username" ):
      showSnackBarOfFailure(context,"Please Enter Password" );
    }
  }
  @override
  Widget build(BuildContext context) {
    Color primaryColor=Colors.black;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding:  EdgeInsets.all(width*0.1),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height*0.08,),
                    SizedBox(
                        width: width*0.8,
                        height: height*0.3,
                        child: Image.asset(AssetConstants.login)),
                    SizedBox(height: height*0.025,),
                    Text("Log in",style: TextStyle(fontSize: width*0.065,fontWeight: FontWeight.bold),),
                    Text("your account",style: TextStyle(fontSize: width*0.065,fontWeight: FontWeight.bold)),
                    SizedBox(height: height*0.015,),
                    SizedBox(
                      width: width*0.8,
                      height: height*0.08,
                      child: TextFormField(
                        cursorColor: Colors.orange,
                        autofillHints: const [AutofillHints.name],
                        validator: (value) {
                          var val = value ?? '';
                          if (val.isEmpty) {
                            return 'Please enter Username';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        focusNode: f1,
                        onFieldSubmitted: (value) {
                          f1.unfocus();
                          FocusScope.of(context).requestFocus(f2);
                        },
                        autofocus: true,
                        controller: userName,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: const Color(0xFF57636C),
                            fontSize: width*0.035,
                            fontWeight: FontWeight.normal,
                          ),
                          hintText: 'Please Enter Username',
                          hintStyle: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: const Color(0xFF57636C),
                            fontSize: width*0.035,
                            fontWeight: FontWeight.normal,
                          ),
                          border: OutlineInputBorder(
                            borderSide:  BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:  BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:  BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:  BorderSide(
                              color:primaryColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
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
                    SizedBox(height: height*0.025,),
                    Consumer(
                        builder: (context,ref,child) {
                          final passwordVisibility=ref.watch(passwordVisibilityProvider);
                          return SizedBox(
                            width: width*0.8,
                            height: height*0.08,
                            child: TextFormField(
                              cursorColor: primaryColor,
                              autofillHints: const [AutofillHints.password],
                              controller: password,
                              validator: (passCurrentValue) {
                                var passNonNullValue = passCurrentValue ?? '';
                                if (passNonNullValue.isEmpty) {
                                  return ("Please Enter Password");
                                } else if (passNonNullValue.length < 6) {
                                  return ("Password must have\n at least 6 characters");
                                }
                                return null;
                              },
                              focusNode: f2,
                              autofocus: true,
                              obscureText: !passwordVisibility,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: const Color(0xFF57636C),
                                  fontSize:width*0.035,
                                  fontWeight: FontWeight.normal,
                                ),
                                hintText: 'Please Enter Password',
                                hintStyle: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: const Color(0xFF57636C),
                                  fontSize: width*0.035,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: OutlineInputBorder(
                                  borderSide:  BorderSide(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(
                                    color:primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(top: height*0.015,left: width*0.05),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    ref.read(passwordVisibilityProvider.notifier).update((state) => !state);
                                  },
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    passwordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: const Color(0xFF757575),
                                    size: width*0.04,
                                  ),
                                ),
                              ),
                              style:TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: const Color(0xFF1D2429),
                                fontSize:width*0.035,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        }
                    ),
                    SizedBox(height: height*0.1,),
                    Consumer(
                        builder: (context,ref,child) {
                          return GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                getLogin(ref,context);
                              }
                            },
                            child: Container(
                              width: width*0.8,
                              height: height*0.06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(width*0.02),
                                color: primaryColor,
                              ),
                              child: Center(child: Text("Login",style: TextStyle(fontSize: width*0.05,color: Colors.white,fontWeight: FontWeight.bold),)),

                            ),
                          );
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
