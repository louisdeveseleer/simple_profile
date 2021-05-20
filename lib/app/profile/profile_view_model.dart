import 'package:breakthrough_apps_challenge/services/database_CRUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileVMProvider = (DatabaseCRUD databaseCRUD) => ChangeNotifierProvider(
      (ref) => ProfileViewModel(
        databaseCRUD: databaseCRUD,
      ),
    );

class ProfileViewModel with ChangeNotifier {
  final DatabaseCRUD databaseCRUD;
  ProfileViewModel({@required this.databaseCRUD});

  bool isInEditMode = false;
  bool isLoading = false;

  void toggleMode() {
    isInEditMode = !isInEditMode;
    notifyListeners();
  }
}
