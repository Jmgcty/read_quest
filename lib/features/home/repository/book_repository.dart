import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/appwrite_collection_id.dart';
import 'package:read_quest/core/handler/appwrite_result_handler.dart';
import 'package:read_quest/core/model/book_model.dart';
import 'package:read_quest/core/services/appwrite.dart';
import 'package:read_quest/core/utils/result_message.dart';

class BookRepository {
  final Client client;
  BookRepository({required this.client});

  // Future<List<BookModel>> getAllAcceptedBooks() async {
  //   final databases = Databases(client);
  //   final storage = Storage(client);

  //   try {
  //     final books = await databases.listDocuments(
  //       databaseId: AppWriteConst.appWriteDatabaseID,
  //       collectionId: AppWriteConst.booksCollectionId,
  //       queries: [Query.isNotNull('accepted_at')],
  //     );

  //   } on AppwriteException catch (e) {
  //     log("AppwriteException: ${e.message}");
  //   } catch (e) {
  //     log("Unknown error: ${e.toString()}");
  //   }
  // }

  Future<Result> uploadBook(BookModel bookModel) async {
    final databases = Databases(client);
    final storage = Storage(client);
    try {
      final doc = await databases.createDocument(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.booksCollectionId,
        documentId: bookModel.generateID(),
        data: bookModel.toMap(),
      );

      await storage.createFile(
        bucketId: AppWriteConst.appWriteStorageBucketId,
        fileId: doc.$id,
        file: InputFile.fromPath(path: bookModel.file),
      );
      return Result.success();
    } on AppwriteException catch (e) {
      log("AppwriteException: ${e.message}");
      return Result.error(resultMessage(e.type!));
    } catch (e) {
      log("Unknown error: ${e.toString()}");
      return Result.error("Unknown error: ${e.toString()}");
    }
  }
}

final bookRepositoryProvider = Provider(
  (ref) => BookRepository(client: ref.read(appwriteClientProvider)),
);
