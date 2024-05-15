import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../failure.dart';
import '../providers/firebase_providers.dart';
import '../type_def.dart';

final storageRepositoryProvider=Provider((ref) =>
    StorageRepository(firebaseStorage:ref.watch(storageProvider)));
class StorageRepository{
  final FirebaseStorage _firebaseStorage;
  StorageRepository({required FirebaseStorage firebaseStorage}):_firebaseStorage=firebaseStorage;

  FutureEither<String> getImageUrl({
    required String path,
    required File? file
  })async{
    try{
      final ref=_firebaseStorage.ref().child(path);
      UploadTask uploadTask=ref.putFile(file!);
      final snapshot =await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    }catch(e){
      return left(Failure(e.toString()));
    }
    }
}