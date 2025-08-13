import 'dart:developer';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_quest/core/const/appwrite_id.dart';
import 'package:read_quest/core/services/appwrite.dart';

class AppwriteFileService {
  final Client client;

  AppwriteFileService({required this.client});

  Future<Uint8List?> getImage({String? fileId}) async {
    if (fileId == null) return null;

    try {
      final storage = Storage(client);
      final response = await storage.getFileDownload(
        bucketId: AppWriteConst.appWriteStorageBucketId,
        fileId: fileId,
      );

      return response;
    } catch (e) {
      log('Failed to fetch image: $e');
      return null;
    }
  }

  Future<Uint8List?> getFile({String? fileId}) async {
    if (fileId == null) return null;

    try {
      final storage = Storage(client);
      final response = await storage.getFileDownload(
        bucketId: AppWriteConst.appWriteStorageBucketId,
        fileId: fileId,
      );

      return response;
    } catch (e) {
      log('Failed to fetch image: $e');
      return null;
    }
  }
}

final appwriteFileServiceProvider = Provider(
  (ref) => AppwriteFileService(client: ref.read(appwriteClientProvider)),
);

final appwriteImageProvider = FutureProvider.family<Uint8List?, String?>((
  ref,
  fileId,
) async {
  return ref.read(appwriteFileServiceProvider).getImage(fileId: fileId);
});

final appwriteFileProvider = FutureProvider.autoDispose
    .family<Uint8List?, String?>((ref, fileId) async {
      return ref.read(appwriteFileServiceProvider).getFile(fileId: fileId);
    });
