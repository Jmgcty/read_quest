import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/appwrite_collection_id.dart';

final appwriteClientProvider = Provider<Client>((ref) {
  return Client()
    ..setEndpoint(AppWriteConst.appWriteEndPoint)
    ..setProject(AppWriteConst.appWriteProjectID);
});
