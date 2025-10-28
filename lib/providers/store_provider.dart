import 'package:flutter_riverpod/legacy.dart';
import 'package:store_keeper_app/models/store_models.dart' ;
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ProductNotifier extends StateNotifier<List<Product>>{
  ProductNotifier() : super([]);

  ///add function
  void addProduct(Product product){
    state = [...state , product];
  }

  /// View all products
  List<Product>getAllProducts(){
    return state;
  }

  //clear all products
  void clearProducts(){
    state = [];
  }

  //delete product by index
  void deleteProduct(int index){
    if(index < 0 || index >= state.length) return ;
    final updatedList = [...state];
    updatedList.removeAt(index);
    state = updatedList ;
  }
  
  //edit product by index
  void editProduct(int index , Product updatedProduct){
    if(index < 0 || index >=state.length) return ;
    final updatedList = [...state] ;
    updatedList[index] = updatedProduct ;
    state = updatedList ;
  }
 
}

final productProvider = StateNotifierProvider<ProductNotifier,List<Product>>((ref){
  return ProductNotifier();
});