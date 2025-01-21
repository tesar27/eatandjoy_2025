import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:enj/src/appwrite/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

final restaurantsApiProvider = Provider<RestaurantsApi>((ref) {
  final databases = ref.watch(databaseProvider);
  return RestaurantsApi(databases);
});

class RestaurantsApi {
  final Databases databases;

  RestaurantsApi(this.databases);

  Future<List<Document>> getRestaurants() async {
    try {
      final result = await databases.listDocuments(
        databaseId: AppwriteConfig.databaseId!,
        collectionId: 'your-restaurants-collection-id',
      );
      return result.documents;
    } catch (e) {
      print('Error fetching restaurants: $e');
      throw Exception('Failed to fetch restaurants');
    }
  }
}
