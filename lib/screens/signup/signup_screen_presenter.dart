import 'package:allinone/data/rest_ds.dart';
import 'package:allinone/models/user.dart';

abstract class SignupScreenContract {
  void onSignupSuccess(User user);
  void onSignupError(String errorTxt);
}

class SignupScreenPresenter {
  SignupScreenContract _view;
  RestDatasource api = new RestDatasource();
  SignupScreenPresenter(this._view);

  doSignup(String email, String password) {
    api.signup(email, password).then((User user) {
      _view.onSignupSuccess(user);
    }).catchError((Exception error) => _view.onSignupError(error.toString()));
  }
}
