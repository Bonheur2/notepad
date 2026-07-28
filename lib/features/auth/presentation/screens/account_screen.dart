import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/core_providers.dart';
import '../../../../app/providers/sync_providers.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'That password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'user-not-found':
        return 'No account found with that email.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }

  Future<void> _createAccount() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Enter an email and password.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    final authService = ref.read(authServiceProvider);
    try {
      User user;
      try {
        user = await authService.linkWithEmail(email, password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          user = await authService.signInWithEmail(email, password);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'That email already has an account — signed in to it instead. '
                  'Notes created anonymously on this device before now will not '
                  'appear under this account.',
                ),
              ),
            );
          }
        } else {
          rethrow;
        }
      }

      await ref.read(userProfileRepositoryProvider).ensureProfile(
            uid: user.uid,
            email: user.email ?? email,
            displayName: email.split('@').first,
          );
    } on FirebaseAuthException catch (e) {
      if (mounted) setState(() => _error = _mapAuthError(e));
    } catch (e) {
      // Auth succeeded but the profile write failed (e.g. Firestore rules not
      // deployed yet) — surface it instead of silently swallowing it, since
      // the account would otherwise be unfindable by email.
      if (mounted) {
        setState(() => _error = 'Signed in, but saving your profile failed: $e');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  bool _profileChecked = false;

  void _ensureProfileForSignedInUser(User user) {
    if (_profileChecked) return;
    _profileChecked = true;
    final email = user.email;
    if (email == null || email.isEmpty) return;
    Future.microtask(() => ref.read(userProfileRepositoryProvider).ensureProfile(
          uid: user.uid,
          email: email,
          displayName: email.split('@').first,
        ));
  }

  Future<void> _signOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'You\'ll be switched to a fresh anonymous session. Notes on this '
          'device stay put, but new notes will sync under the new session '
          'instead of this account until you sign in again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final authService = ref.read(authServiceProvider);
    await authService.signOut();
    await authService.ensureSignedIn();
    ref.invalidate(syncEngineProvider);
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (user) {
          final isAnonymous = user?.isAnonymous ?? true;
          final email = user?.email;

          if (!isAnonymous && email != null && email.isNotEmpty) {
            _ensureProfileForSignedInUser(user!);
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 32),
                  const SizedBox(height: 12),
                  Text('Signed in as $email', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Friends can find you by this email address.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: _signOut,
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create an account to add friends and chat',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Your existing notes on this device stay exactly as they are.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _submitting ? null : _createAccount,
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create account'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
