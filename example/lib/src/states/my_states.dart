sealed class CarsState {}

class CarsStateDone extends CarsState {
  final List<String> cars;
  CarsStateDone(this.cars);
}

class CarsStateInitial extends CarsState {}

class CarsStateLoading extends CarsState {}
