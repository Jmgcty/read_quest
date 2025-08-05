import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/appwrite_id.dart';
import 'package:read_quest/core/handler/appwrite_result_handler.dart';
import 'package:read_quest/core/services/appwrite.dart';
import 'package:read_quest/core/services/pref_storage.dart';
import 'package:read_quest/core/model/user_model.dart';
import 'package:read_quest/core/utils/result_message.dart';
import 'package:read_quest/features/auth/model/auth_model.dart';

class AuthRepository {
  final Client client;
  AuthRepository({required this.client});

  Future<Result> login(AuthModel authModel) async {
    final storagePref = SharedPrefStorage.instance;
    //
    final account = Account(client);
    final database = Databases(client);

    try {
      final user = await database.getDocument(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.usersCollectionId,
        documentId: authModel.uid,
      );

      final email = user.data['email'];

      final sessionID = await storagePref.getAuthSession();
      if (sessionID != null) await account.deleteSession(sessionId: sessionID);

      //
      final session = await account.createEmailPasswordSession(
        email: email,
        password: authModel.password,
      );

      await storagePref.setAuthSession(session.$id);
      return Result.success();
    } on AppwriteException catch (e) {
      log("AppwriteException: ${e.message} - ${e.type}");
      await storagePref.removeAuthSession();
      return Result.error(resultMessage(e.type!));
    } catch (e) {
      log("Unknown error: ${e.toString()}");
      return Result.error(e.toString());
    }
  }

  // Register
  Future<Result> register(AuthModel authModel, UserModel userModel) async {
    final account = Account(client);
    final database = Databases(client);
    try {
      // Step 1: Create the user in Appwrite Authentication

      await account.create(
        userId: userModel.uid,
        name: userModel.name,
        email: userModel.email,
        password: authModel.password,
      );

      // Step 2: Try to create the document in the database
      await database.createDocument(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.usersCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );

      await database.createDocument(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.membersCollectionId,
        documentId: userModel.uid,
        data: {'user': userModel.uid},
      );

      return await login(authModel);
    } on AppwriteException catch (e) {
      log("AppwriteException: ${e.message} - ${e.type}");
      await account.deleteIdentity(identityId: userModel.uid);
      return Result.error(resultMessage(e.type!));
    } catch (e) {
      log("Unknown error: ${e.toString()}");
      return Result.error("Unknown error: ${e.toString()}");
    }
  }

  Future<User?> getCurrentUser() async {
    final account = Account(client);
    try {
      final user = await account.get();
      return user;
    } on AppwriteException {
      return null;
    }
  }
}

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(client: ref.read(appwriteClientProvider)),
);
