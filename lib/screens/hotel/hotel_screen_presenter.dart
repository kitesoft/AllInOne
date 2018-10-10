import 'package:allinone/data/rest_ds.dart';
import 'package:allinone/models/king.dart';

abstract class HotelScreenContract {
  void onGetNotificationSuccess(King king);
  void onGetNotificationError(String errorTxt);
}

class HotelScreenPresenter {
  HotelScreenContract _view;
  RestDatasource api = new RestDatasource();
  HotelScreenPresenter(this._view);

 doRocky(String _fcmtoken) {
    api.rocky(_fcmtoken).then((King king) {
      _view.onGetNotificationSuccess(king);
    }).catchError((Exception error) => _view.onGetNotificationError(error.toString()));
  }
}