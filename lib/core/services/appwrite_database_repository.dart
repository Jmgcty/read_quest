import 'package:appwrite/appwrite.dart';

class DatabaseRepository {
  final Client client;
  late Databases databases;

  DatabaseRepository({required this.client}) {
    databases = Databases(client);
  }
}
