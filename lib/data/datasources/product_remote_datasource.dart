import 'package:dartz/dartz.dart';
import 'package:flutter_app/common/global_variables.dart';
import 'package:flutter_app/data/models/products_response_model.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDatasource {
  Future<Either<String, ProductsResponseModel>> getProducts() async {
    final headers = {
      'Accept': 'application/json',
      'Content_Type': 'application/json',
    };
    final response = await http.get(
      Uri.parse('${GlobalVariables.baseUrl}/api/products'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Right(ProductsResponseModel.fromJson(response.body));
    } else {
      return Left('Server Error');
    }
  }
}
