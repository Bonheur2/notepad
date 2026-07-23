import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_service.dart';
import '../../core/database/app_database.dart';
import '../../core/encryption/encryption_service.dart';
import '../../core/encryption/key_management_service.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/voice/voice_input_service.dart';
import '../../features/auth/data/user_profile_repository.dart';
import '../../features/export/export_service.dart';
import '../../features/notes/data/repositories/note_repository.dart';
import '../../features/notes/data/repositories/note_revision_repository.dart';
import '../../features/tasks/data/repositories/task_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final noteRepositoryProvider = Provider<NoteRepository>(
  (ref) => NoteRepository(ref.watch(databaseProvider)),
);

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepository(ref.watch(databaseProvider)),
);

final noteRevisionRepositoryProvider = Provider<NoteRevisionRepository>(
  (ref) => NoteRevisionRepository(ref.watch(databaseProvider)),
);

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authServiceProvider).authStateChanges(),
);

final userProfileRepositoryProvider = Provider<UserProfileRepository>(
  (ref) => UserProfileRepository(),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final notificationInitProvider = FutureProvider<void>(
  (ref) => ref.watch(notificationServiceProvider).init(),
);

final keyManagementServiceProvider = Provider<KeyManagementService>(
  (ref) => KeyManagementService(),
);

final encryptionServiceProvider = Provider<EncryptionService>(
  (ref) => EncryptionService(ref.watch(keyManagementServiceProvider)),
);

final exportServiceProvider = Provider<ExportService>((ref) => ExportService());

final voiceInputServiceProvider = Provider<VoiceInputService>(
  (ref) => VoiceInputService(),
);
