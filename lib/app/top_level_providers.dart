import 'package:breakthrough_apps_challenge/services/auth_service.dart';
import 'package:breakthrough_apps_challenge/services/firebase_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateChangesProvider = StreamProvider<User>(
    (ref) => ref.watch(authServiceProvider).authStateChanges());

final storageServiceProvider =
    Provider<FirebaseStorageService>((ref) => FirebaseStorageService());

// final databaseProvider = Provider<DatabaseCRUD>((ref) {
//   final authState = ref.watch(authStateChangesProvider);
//   String uid;
//   uid = authState.data?.value?.uid;
//   if (uid != null) {
//     return DatabaseCRUD(uid: uid);
//   }
//   return null;
// });
