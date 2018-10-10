import 'package:allinone/data/rest_ds.dart';
import 'package:allinone/models/photos.dart';
import 'dart:io';

abstract class ProductScreenContract {
  void onGetPhotosSuccess(Photos photos);
  void onGetPhotosError(String errorTxt);
}

class ProductScreenPresenter {
  ProductScreenContract _view;
  RestDatasource api = new RestDatasource();
  ProductScreenPresenter(this._view);

  doHeavy() {
    api.heavy().then((Photos photos) {
      _view.onGetPhotosSuccess(photos);
    }).catchError((Exception error) => _view.onGetPhotosError(error.toString()));
  }
}