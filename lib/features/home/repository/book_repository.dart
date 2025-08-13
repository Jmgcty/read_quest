import 'dart:async';
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

  Stream<List<BookModel>> getRealTimeAcceptedBooks() async* {
    try {
      final realtime = Realtime(client);

      // Initial fetch for accepted books
      final databases = Databases(client);
      final initial = await databases.listDocuments(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.booksCollectionId,
        queries: [Query.isNotNull('accepted_at')],
      );

      List<BookModel> acceptedBooks = initial.documents
          .map((e) => BookModel.fromJson(e.data))
          .where(
            (book) => book.accepted_at != null,
          ) // Filter only accepted books
          .toList();

      yield acceptedBooks; // Yield the initial accepted books list

      // Realtime subscription (no filtering in channel)
      final subscription = realtime.subscribe([
        'databases.${AppWriteConst.appWriteDatabaseID}.collections.${AppWriteConst.booksCollectionId}.documents.*',
      ]);

      await for (final event in subscription.stream) {
        final data = Map<String, dynamic>.from(event.payload);

        final book = BookModel.fromJson(data);
        final docId = book.id;

        final isCreate = event.events.any(
          (e) => e.contains('documents.$docId.create'),
        );
        final isUpdate = event.events.any(
          (e) => e.contains('documents.$docId.update'),
        );
        // final isDelete = event.events.any(
        //   (e) => e.contains('documents.$docId.delete'),
        // );

        bool changed = false;

        if (isCreate || isUpdate) {
          if (book.accepted_at != null || acceptedBooks.isNotEmpty) {
            final index = acceptedBooks.indexWhere((b) => b.id == docId);
            if (index == -1) {
              acceptedBooks.add(book);
              changed = true;
            } else if (acceptedBooks[index] != book) {
              acceptedBooks[index] = book;
              changed = true;
            }
          }
        }

        if (isUpdate || book.accepted_at == null || book.accepted_at!.isEmpty) {
          final originalLength = acceptedBooks.length;
          acceptedBooks.removeWhere((b) => b.id == docId);
          final removed = acceptedBooks.length != originalLength;
          if (removed) changed = true;
        } else {
          final index = acceptedBooks.indexWhere((b) => b.id == docId);
          if (index == -1) {
            acceptedBooks.add(book);
            changed = true;
          } else if (acceptedBooks[index] != book) {
            acceptedBooks[index] = book;
            changed = true;
          }
        }

        if (changed) {
          yield List.unmodifiable(acceptedBooks);
        }
      }
    } on AppwriteException catch (e) {
      log("AppwriteException: ${e.message}");
      yield [];
    } catch (e) {
      log("Error: ${e.toString()}");
      yield [];
    }
  }

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

  Future<List<BookModel>> fetchBooks() async {
    try {
      final databases = Databases(client);
      final initial = await databases.listDocuments(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.booksCollectionId,
        queries: [
          Query.and([Query.isNotNull('accepted_at'), Query.isNotNull('file')]),
        ],
      );

      return initial.documents.map((e) => BookModel.fromJson(e.data)).toList();
    } on AppwriteException catch (e) {
      log('Error fetching books: $e');

      return [];
    } catch (e) {
      log("Unknown error: ${e.toString()}");
      return [];
    }
  }
}

final bookRepositoryProvider = Provider(
  (ref) => BookRepository(client: ref.read(appwriteClientProvider)),
);
