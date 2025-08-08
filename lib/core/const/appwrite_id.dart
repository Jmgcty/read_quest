import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppWriteConst {
  const AppWriteConst._();
  static final String appWriteProjectID =
      dotenv.env['APPWRITE_PROJECT_ID'] ?? "INVALID";
  static final String appWriteEndPoint =
      dotenv.env['APPWRITE_ENDPOINT'] ?? "INVALID";
  static final String appWriteDatabaseID =
      dotenv.env['APPWRITE_DATABASE_ID'] ?? "INVALID";
  static final String appWriteStorageBucketId =
      dotenv.env['APPWRITE_STORAGE_BUCKET_ID'] ?? "INVALID";
  static final String usersCollectionId =
      dotenv.env['APPWRITE_USER_COLLECTION_ID'] ?? "INVALID";
  static final String membersCollectionId =
      dotenv.env['APPWRITE_MEMBER_COLLECTION_ID'] ?? "INVALID";
  static final String booksCollectionId =
      dotenv.env['APPWRITE_BOOK_COLLECTION_ID'] ?? "INVALID";
}
