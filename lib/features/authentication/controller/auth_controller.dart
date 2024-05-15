import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uae_task/core/global_variables/global_variables.dart';
import 'package:uae_task/features/authentication/repository/auth_repository.dart';
import 'package:uae_task/features/products/screen/product_screen.dart';
import '../../../core/utils.dart';
import '../../../models/user_model.dart';
import '../../home_screen/screen/home_screen.dart';
import '../screen/login_screen.dart';


final authControllerProvider = NotifierProvider<AuthController,bool>(() => AuthController(),);
final userStreamProvider = StreamProvider.family.autoDispose((ref,String id) {
 return ref.watch(authControllerProvider.notifier).userStream(id: id);
});
class AuthController extends Notifier<bool>{
  @override
  bool build() {
    // TODO: implement build
    return false;
  }
  AuthRepository get _authRepository=>ref.read(authRepositoryProvider);

  /// user login
   userLogin({required String userName,required String password,required BuildContext context}) async {
     state==true;
     final user=await _authRepository.userLogin(userName: userName, password: password);
     user.fold((l) => showSnackBarOfFailure(context,l.message), (user) async {
       ref.watch(userProvider.notifier).update((state) => user);
       SharedPreferences prefs = await SharedPreferences.getInstance();
       prefs.setString('uid', user.id);
       if(context.mounted) {
        if(user.role=="Admin") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (route) => false);
        }
        else{
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => ProductScreen(),
              ),
                  (route) => false);
        }
      }
     });
     state=false;
  }
  /// logout
  Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('uid');
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen(),), (route) => false);
  }
  /// user stream
  Stream<UserModel> userStream({required String id})
  {
    return _authRepository.userStream(id: id);
  }
  /// logged user
  getLoggedUser(String id){
    return _authRepository.getLoggedUser(id);
  }
}