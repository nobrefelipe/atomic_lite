import 'package:atomic_lite/atomic_lite.dart';

import 'atoms/atoms.dart';
import 'reducers/get_users.dart';
import 'states/my_states.dart';

class HomeController extends AtomicController {
  final Function getCities;

  HomeController.instance(
    super.eventHandler, {
    required this.getCities,
  }) : super.instance() {
    onString('getUsers', getUsers);
    on(cities, getCities);
  }
}

class CarsController extends AtomicController {
  CarsController.instance(super.eventHandler) : super.instance() {
    onString('getCars', _getCars);
  }

  Future _getCars(_) async {
    carsState(CarsStateLoading());
    await Future.delayed(const Duration(seconds: 2));
    carsState(
      CarsStateDone(["audi", "ferrari", "ford"]),
    );
  }
}
