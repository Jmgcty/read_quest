import 'dart:async';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/appwrite_id.dart';
import 'package:read_quest/core/handler/appwrite_result_handler.dart';
import 'package:read_quest/core/services/appwrite.dart';
import 'package:read_quest/core/model/user_model.dart';
import 'package:read_quest/core/utils/enum/member_enum.dart';
import 'package:read_quest/core/model/member_model.dart';
import 'package:read_quest/core/utils/result_message.dart';

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

  Stream<List<MemberModel>> getRealTimeAcceptedMembers() async* {
    try {
      final realtime = Realtime(client);
      final acceptedMembers = <MemberModel>[];

      // Initial fetch for accepted members
      final databases = Databases(client);
      final initial = await databases.listDocuments(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.membersCollectionId,
      );

      acceptedMembers.addAll(
        initial.documents
            .map((e) => MemberModel.fromJson(e.data))
            .where(
              (member) => member.status.name == MemberStatus.accepted.name,
            ),
      );

      yield acceptedMembers; // Yield the initial accepted members list

      // Realtime subscription (no filtering in channel)
      final subscription = realtime.subscribe([
        'databases.${AppWriteConst.appWriteDatabaseID}.collections.${AppWriteConst.membersCollectionId}.documents.*',
      ]);

      await for (final event in subscription.stream) {
        final data = Map<String, dynamic>.from(event.payload);
        final member = MemberModel.fromJson(data);
        final docId = member.user.uid;

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
          if (member.status.name == MemberStatus.accepted.name) {
            final index = acceptedMembers.indexWhere(
              (m) => m.user.uid == docId,
            );
            if (index == -1) {
              acceptedMembers.add(member);
              changed = true;
            } else if (acceptedMembers[index] != member) {
              acceptedMembers[index] = member;
              changed = true;
            }
          }
        }

        if (isUpdate || member.status.name != MemberStatus.accepted.name) {
          final originalLength = acceptedMembers.length;
          acceptedMembers.removeWhere((m) => m.user.uid == docId);
          final removed = acceptedMembers.length != originalLength;
          if (removed) changed = true;
        } else {
          final index = acceptedMembers.indexWhere((m) => m.user.uid == docId);
          if (index == -1) {
            acceptedMembers.add(member);
            changed = true;
          } else if (acceptedMembers[index] != member) {
            acceptedMembers[index] = member;
            changed = true;
          }
        }

        if (changed) {
          yield List.unmodifiable(acceptedMembers);
        }
      }
    } catch (e) {
      log("Error: ${e.toString()}");
      yield []; // In case of any error, yield an empty list
    }
  }

  Stream<List<MemberModel>> getRealTimePendingMembers() async* {
    try {
      final realtime = Realtime(client);
      final pendingMembers = <MemberModel>[];

      // Initial fetch for pending members
      final databases = Databases(client);
      final initial = await databases.listDocuments(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.membersCollectionId,
      );

      pendingMembers.addAll(
        initial.documents
            .map((e) => MemberModel.fromJson(e.data))
            .where((member) => member.status.name == MemberStatus.pending.name),
      );

      yield pendingMembers; // Yield the initial pending members list

      // Realtime subscription (no filtering in channel)
      final subscription = realtime.subscribe([
        'databases.${AppWriteConst.appWriteDatabaseID}.collections.${AppWriteConst.membersCollectionId}.documents.*',
      ]);

      await for (final event in subscription.stream) {
        final data = Map<String, dynamic>.from(event.payload);
        final member = MemberModel.fromJson(data);
        final docId = member.user.uid;

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
          if (member.status.name == MemberStatus.pending.name) {
            final index = pendingMembers.indexWhere((m) => m.user.uid == docId);
            if (index == -1) {
              pendingMembers.add(member);
              changed = true;
            } else if (pendingMembers[index] != member) {
              pendingMembers[index] = member;
              changed = true;
            }
          }
        }

        if (isUpdate || member.status.name != MemberStatus.pending.name) {
          final originalLength = pendingMembers.length;
          pendingMembers.removeWhere((m) => m.user.uid == docId);
          final removed = pendingMembers.length != originalLength;
          if (removed) changed = true;
        } else {
          final index = pendingMembers.indexWhere((m) => m.user.uid == docId);
          if (index == -1) {
            pendingMembers.add(member);
            changed = true;
          } else if (pendingMembers[index] != member) {
            pendingMembers[index] = member;
            changed = true;
          }
        }

        if (changed) {
          yield List.unmodifiable(pendingMembers);
        }
      }
    } catch (e) {
      log("Error: ${e.toString()}");
      yield []; // In case of any error, yield an empty list
    }
  }

  Future<Result> updateMemberStatus(MemberModel member) async {
    final database = Databases(client);

    try {
      await database.updateDocument(
        databaseId: AppWriteConst.appWriteDatabaseID,
        collectionId: AppWriteConst.membersCollectionId,
        documentId: member.user.uid,
        data: member.toMap(),
      );
      return Result.success();
    } on AppwriteException catch (e) {
      log("AppwriteException: ${e.message} - ${e.type}");
      return Result.error(resultMessage(e.type!));
    } catch (e) {
      log("Unknown error: ${e.toString()}");
      return Result.error("Unknown error: ${e.toString()}");
    }
  }
}

final memberRepositoryProvider = Provider(
  (ref) => MemberRepository(client: ref.read(appwriteClientProvider)),
);
