import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/appwrite_id.dart';
import 'package:read_quest/core/handler/appwrite_result_handler.dart';
import 'package:read_quest/core/model/book_model.dart';
import 'package:read_quest/core/model/user_model.dart';
import 'package:read_quest/core/services/appwrite.dart';
import 'package:read_quest/core/utils/result_message.dart';
import 'package:uuid/uuid.dart';

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
    final account = Account(client);
    final databases = Databases(client);
    final storage = Storage(client);

    bookModel = bookModel.copyWith(id: bookModel.generateID());
    File newFile;
    File? cover;
    try {
      newFile = await storage.createFile(
        bucketId: AppWriteConst.appWriteStorageBucketId,
        fileId: ID.custom("${bookModel.id}_f"),
        file: InputFile.fromPath(path: bookModel.file),
      );

      if (bookModel.cover != null) {
        cover = await storage.createFile(
          bucketId: AppWriteConst.appWriteStorageBucketId,
          fileId: ID.custom("${bookModel.id}_c"),
          file: InputFile.fromPath(path: bookModel.cover!),
        );
      }

      final uploader = await account.get();
      final user = UserModel(
        uid: uploader.$id,
        email: uploader.email,
        name: uploader.name,
      );

      //
      bookModel = bookModel.copyWith(
        uploader: user,
        accepted_at: bookModel.getCurrentPHDateTime(),
      );

      bookModel = bookModel.copyWith(file: newFile.$id, cover: cover?.$id);

      await databases.createDocument(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.booksCollectionId,
        documentId: bookModel.id,
        data: bookModel.toMap(),
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
