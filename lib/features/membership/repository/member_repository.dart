import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/appwrite_id.dart';
import 'package:read_quest/core/handler/appwrite_result_handler.dart';
import 'package:read_quest/core/services/appwrite.dart';
import 'package:read_quest/core/model/user_model.dart';
import 'package:read_quest/core/utils/enum/member_enum.dart';
import 'package:read_quest/core/model/member_model.dart';

class MemberRepository {
  final Client client;

  MemberRepository({required this.client});

  Future<Result> joinGroup(UserTypes userType) async {
    final account = Account(client);
    final database = Databases(client);
    try {
      final user = await account.get();
      final userModel = UserModel.fromAppWrite(user);
      final member = MemberModel(
        user: userModel,
        role: userType,
        status: MemberStatus.pending,
      );

      //
      await database.updateDocument(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.membersCollectionId,
        documentId: user.$id,
        data: member.toMap(),
      );
      return Result.success();
    } on AppwriteException catch (e) {
      log("AppwriteException: ${e.message}");
      //
      return Result.error("AppwriteException: ${e.type} - ${e.message}");
    } catch (e) {
      log("Unknown error: ${e.toString()}");
      //
      return Result.error("Unknown error: ${e.toString()}");
    }
  }

  Future<MemberModel?> getMembership() async {
    final account = Account(client);
    final database = Databases(client);
    try {
      final user = await account.get();
      final document = await database.getDocument(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.membersCollectionId,
        documentId: user.$id,
      );
      return MemberModel.fromJson(document.data);
    } on AppwriteException catch (e) {
      log("AppwriteException: ${e.message}");
      //
      return null;
    } catch (e) {
      log("Unknown error: ${e.toString()}");
      //
      return null;
    }
  }

  Stream<MemberModel?> getMembershipByCurrentUser() async* {
    final account = Account(client);
    final databases = Databases(client);
    final realtime = Realtime(client);

    MemberModel? previous;

    try {
      final user = await account.get();

      // Fetch current state once
      final doc = await databases.getDocument(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.membersCollectionId,
        documentId: user.$id,
      );

      //
      final current = MemberModel.fromJson(doc.data);

      yield current;
      previous = current;

      // Setup realtime subscription
      final subscription = realtime.subscribe([
        'databases.${AppWriteConst.appWriteDatabaseID}.collections.${AppWriteConst.membersCollectionId}.documents.${user.$id}',
      ]);

      await for (final event in subscription.stream) {
        final data = event.payload;
        final updated = MemberModel.fromJson(Map<String, dynamic>.from(data));

        // Only yield if the data has changed
        if (updated != previous) {
          yield updated;
          previous = updated;
        }
      }
    } catch (e) {
      log("Unknown error: ${e.toString()}");
      yield null;
    }
  }

  Future<List<MemberModel>> getAllAcceptedMembers() async {
    try {
      final database = Databases(client);
      final members = await database.listDocuments(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.membersCollectionId,
        queries: [Query.contains('status', MemberStatus.accepted.name)],
      );
      return members.documents
          .map((e) => MemberModel.fromJson(e.data))
          .toList();
    } on AppwriteException catch (e) {
      log("AppwriteException: ${e.message}");
      return [];
    } catch (e) {
      log("Unknown error: ${e.toString()}");
      return [];
    }
  }

  Stream<List<MemberModel>> getAllRealtimeAcceptedMembers() async* {
    try {
      final databases = Databases(client);
      final realtime = Realtime(client);

      // Initial fetch
      final initial = await databases.listDocuments(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.membersCollectionId,
        queries: [Query.equal('status', MemberStatus.accepted.name)],
      );

      List<MemberModel> currentMembers = initial.documents
          .map((e) => MemberModel.fromJson(e.data))
          .toList();

      yield currentMembers;

      // Realtime subscription (no filtering in channel)
      final subscription = realtime.subscribe([
        'databases.${AppWriteConst.appWriteDatabaseID}.collections.${AppWriteConst.membersCollectionId}.documents.*',
      ]);

      await for (final event in subscription.stream) {
        final eventType = event.events.first;

        final data = Map<String, dynamic>.from(event.payload);
        final member = MemberModel.fromJson(data);

        final isAccepted = member.status.name == MemberStatus.accepted.name;

        // Handle event type
        if (eventType.contains('.create')) {
          if (isAccepted) {
            currentMembers.add(member);
          }
        } else if (eventType.contains('.update')) {
          final index = currentMembers.indexWhere(
            (m) => m.user.uid == member.user.uid,
          );

          if (isAccepted) {
            if (index != -1) {
              currentMembers[index] = member;
            } else {
              currentMembers.add(member);
            }
          } else {
            if (index != -1) {
              currentMembers.removeAt(index);
            }
          }
        } else if (eventType.contains('.delete')) {
          currentMembers.removeWhere((m) => m.user.uid == member.user.uid);
        }

        yield List<MemberModel>.from(currentMembers);
      }
    } on AppwriteException catch (e) {
      log("AppwriteException: ${e.message}");
      yield [];
    } catch (e) {
      log("Unknown error: ${e.toString()}");
      yield [];
    }
  }
}

final memberRepositoryProvider = Provider(
  (ref) => MemberRepository(client: ref.read(appwriteClientProvider)),
);
