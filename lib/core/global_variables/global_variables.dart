import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uae_task/models/user_model.dart';
/// mediaQuery variables
double height=0;
double width=0;

/// userModel provider
final userProvider = StateProvider<UserModel?>((ref) {
  return null;
});

  /// search function
setSearchParam(String search){
  List<String> searchList=[];
  for(int i=0;i<=search.length;i++){
    for(int j=i+1;j<=search.length;j++){
      searchList.add(search.substring(i,j).toUpperCase().trim());
    }
  }
  return searchList;
}