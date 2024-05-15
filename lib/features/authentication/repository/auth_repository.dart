import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uae_task/core/constants/firebase_constants.dart';
import 'package:uae_task/core/providers/firebase_providers.dart';
import 'package:uae_task/models/user_model.dart';
import '../../../core/failure.dart';
import '../../../core/type_def.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(firestore: ref.watch(firestoreProvider));
});

class AuthRepository{
  final FirebaseFirestore _firestore;
  AuthRepository({
    required FirebaseFirestore firestore
}):_firestore=firestore;

  CollectionReference get _user=> _firestore.collection(FirebaseConstants.userCollections);

  /// userLogin
  FutureEither<UserModel> userLogin({required String userName,required String password}) async {
    try{
      QuerySnapshot snapshot=await _user.where("name",isEqualTo: userName).where("password",isEqualTo: password).get();

      if(snapshot.docs.isNotEmpty){
        DocumentSnapshot snap = snapshot.docs.first;
        UserModel user = UserModel.fromMap(snap.data() as Map<String, dynamic>);
        if (user.name == userName && user.password == password) {
          return right(user);
        } else {
          if (user.name != userName) {
            throw "Invalid UserName";
          } else {
            throw "Invalid Password";
          }
        }
      }
      else
        {
          throw "Invalid User name Password";
        }
    }
    on FirebaseException catch( em ){
      throw em.message!;
    }
    catch (e){
      return left(Failure(e.toString()));
    }
  }
  /// user stream
  Stream<UserModel> userStream({required String id})
  {
    return _user.doc(id).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String,dynamic>));
  }
  /// logged User
  getLoggedUser(String id) async {
    DocumentSnapshot admin = await _user.doc(id).get();
    UserModel userModel = UserModel.fromMap(admin.data() as Map<String,dynamic>);
    return userModel;
  }
}