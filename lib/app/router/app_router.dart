import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/account_screen.dart';
import '../../features/chat/presentation/screens/chat_home_screen.dart';
import '../../features/chat/presentation/screens/chat_thread_screen.dart';
import '../../features/notes/presentation/screens/handwriting_canvas_screen.dart';
import '../../features/notes/presentation/screens/home_screen.dart';
import '../../features/notes/presentation/screens/note_editor_screen.dart';
import '../../features/notes/presentation/screens/note_history_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/note',
      builder: (context, state) => const NoteEditorScreen(),
    ),
    GoRoute(
      path: '/note/:id',
      builder: (context, state) => NoteEditorScreen(
        noteId: state.pathParameters['id'],
      ),
    ),
    GoRoute(
      path: '/note/:id/history',
      builder: (context, state) => NoteHistoryScreen(
        noteId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/note/:id/sketch',
      builder: (context, state) => HandwritingCanvasScreen(
        existingSketchPath: state.extra as String?,
      ),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountScreen(),
    ),
    GoRoute(
      path: '/friends',
      builder: (context, state) => const ChatHomeScreen(),
    ),
    GoRoute(
      path: '/chat/:chatId',
      builder: (context, state) => ChatThreadScreen(
        chatId: state.pathParameters['chatId']!,
        friendDisplayName: state.extra as String?,
      ),
    ),
  ],
);
