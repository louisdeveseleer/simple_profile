import 'package:breakthrough_apps_challenge/app/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({
    Key key,
    @required this.child,
  }) : super(key: key);
  final Widget child;

  Widget _loadingWidget() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _errorWidget(_, __) {
    return const Scaffold(
        body: Center(
      child: Text('Something went wrong.'),
    ));
  }

  Widget _signIn(BuildContext context) {
    context.read(authServiceProvider).signInAnonymously();
    return _loadingWidget();
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final authStateChanges = watch(authStateChangesProvider);
    return authStateChanges.when(
      data: (user) => user != null ? child : _signIn(context),
      loading: _loadingWidget,
      error: _errorWidget,
    );
  }
}
