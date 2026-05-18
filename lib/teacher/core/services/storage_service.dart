import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageUploadResult {
  final String? downloadUrl;
  final String? errorMessage;

  const StorageUploadResult.success(this.downloadUrl) : errorMessage = null;

  const StorageUploadResult.failure(this.errorMessage) : downloadUrl = null;

  bool get isSuccess => downloadUrl != null && downloadUrl!.isNotEmpty;
}

class StorageService {
  static final StorageService _singleton = StorageService._internal();

  factory StorageService() => _singleton;

  StorageService._internal();

  List<String> get _candidateBuckets {
    final options = Firebase.app().options;
    final projectId = options.projectId;
    final configured = options.storageBucket;

    return {
      if (configured != null && configured.isNotEmpty) configured,
      if (projectId != null && projectId.isNotEmpty)
        '$projectId.firebasestorage.app',
      if (projectId != null && projectId.isNotEmpty) '$projectId.appspot.com',
    }.toList();
  }

  FirebaseStorage _storageForBucket(String bucket) {
    final normalized = bucket.replaceFirst(RegExp(r'^gs://'), '');
    return FirebaseStorage.instanceFor(bucket: normalized);
  }

  Future<StorageUploadResult> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    Object? lastError;

    for (final bucket in _candidateBuckets) {
      try {
        debugPrint('StorageService: trying bucket "$bucket"');
        final storage = _storageForBucket(bucket);
        final ref = storage.ref().child('profile_images/$userId/avatar.jpg');

        final snapshot = await ref.putFile(
          imageFile,
          SettableMetadata(contentType: 'image/jpeg'),
        );

        final url = await snapshot.ref.getDownloadURL();
        debugPrint('StorageService: upload OK on bucket "$bucket"');
        return StorageUploadResult.success(url);
      } catch (e, stack) {
        lastError = e;
        debugPrint('StorageService: bucket "$bucket" failed: $e');
        debugPrint(stack.toString());
      }
    }

    final message = _mapError(lastError);
    return StorageUploadResult.failure(message);
  }

  String _mapError(Object? error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'object-not-found':
        case 'bucket-not-found':
          return 'Firebase Storage is not set up. Open Firebase Console → Storage → Get started, then try again.';
        case 'unauthorized':
        case 'permission-denied':
          return 'Storage permission denied. Check Firebase Storage security rules.';
        case 'unauthenticated':
          return 'Please sign in again before uploading a photo.';
        default:
          return error.message ?? 'Could not upload profile photo.';
      }
    }
    return 'Could not upload profile photo. Please try again.';
  }
}
