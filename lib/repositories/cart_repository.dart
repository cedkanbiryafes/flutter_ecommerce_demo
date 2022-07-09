import 'package:dio/dio.dart';
import 'package:ecom/floor/daos/cart_dao.dart';
import 'package:ecom/floor/db/app_database.dart';
import 'package:ecom/floor/entities/cart_item.dart';
import 'package:ecom/models/request/products_request.dart';
import 'package:ecom/models/response/product_entity.dart';

import '../models/response/products_response.dart';
import '../network/endpoints/products_endpoint.dart';

class CartRepository {
  late CartDao _cartDao;

  CartRepository() {
    init();
  }

  init() async {
    _cartDao = await AppDatabase.instance.cartDao;
  }

  Future<void> addToCart(ProductEntity product) async {
    final oldItem = await _cartDao.getCartItem(product.id);
    if (oldItem != null) {
      return _cartDao.updateCartItem(CartItem.fromProduct(product, oldItem.quantity + 1));
    } else {
      return _cartDao.insertCartItem(CartItem.fromProduct(product, 1));
    }
  }

  Stream<List<CartItem>> getAllCartItems() => _cartDao.getAllCartItems();
}