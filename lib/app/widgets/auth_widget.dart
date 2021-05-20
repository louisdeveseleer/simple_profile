import 'package:breakthrough_apps_challenge/app/top_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({
    Key key,
    @required this.builder,
  }) : super(key: key);
  final Function(String uid) builder;

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

  Widget signIn(BuildContext context) {
    context.read(authServiceProvider).signInAnonymously();
    return _loadingWidget();
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final authStateChanges = watch(authStateChangesProvider);
    return authStateChanges.when(
      data: (user) => user != null ? builder(user.uid) : signIn(context),
      loading: _loadingWidget,
      error: _errorWidget,
    );
  }
}
