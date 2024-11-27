import 'package:product_x/services/api_service.dart';
import '../models/product.dart';

abstract class ProductRepositoryBase {
  Future<List<Product>> fetchProducts();
}

class ProductRepository implements ProductRepositoryBase {
  final ApiService apiService;

  ProductRepository({required this.apiService});
  @override
  Future<List<Product>> fetchProducts() async {
    final data = await apiService.get('1b7aa6f6-7757-49a3-9a08-363d5959ac2d');
    return (data as List).map((item) => Product.fromJson(item)).toList();
  }
}
