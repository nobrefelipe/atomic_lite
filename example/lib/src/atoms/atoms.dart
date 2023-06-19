import 'package:atomic_lite/atomic_lite.dart';

import '../states/my_states.dart';

final loading = Atom(false);

final carsState = Atom<CarsState>(CarsStateInitial());
final users = Atom(<String>[]);

final title = Atom('HOME');

final cities = Atom(<String>[]);
final citiesLoading = Atom(false);

final someRecord = Atom((message: '', show: false));
