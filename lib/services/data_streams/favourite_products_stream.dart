import 'package:e_commerce_app_flutter/services/data_streams/data_stream.dart';
import 'package:e_commerce_app_flutter/services/database/user_database_helper.dart';

class FavouriteProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final favProductsFuture = UserDatabaseHelper().usersFavouriteProductsList;
    favProductsFuture.then((favProducts) {
      if (favProducts == null) {
        addData([]);
        print("No Products to show here");
      } else {
        addData(favProducts.cast<String>());
      }
    }).catchError((e) {
      addError(e);
    });
  }
}
