import 'package:allinone/data/rest_ds.dart';
import 'package:allinone/models/people.dart';
import 'dart:io';

abstract class HomeScreenContract {
  void onGetSuccess(People people);
  void onGetError(String errorTxt);
}

class HomeScreenPresenter {
  HomeScreenContract _view;
  RestDatasource api = new RestDatasource();
  HomeScreenPresenter(this._view);

  doHard(String id) {
    api.hard(id).then((People people) {
      _view.onGetSuccess(people);
    }).catchError((Exception error) => _view.onGetError(error.toString()));
  }
}
