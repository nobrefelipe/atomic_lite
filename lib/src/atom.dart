import 'package:flutter/foundation.dart';

class Atom<T> extends ValueNotifier<T> {
  Atom(this._value) : super(_value);

  @override
  T get value {
    return _value;
  }

  T _value;

  /// The current value stored in this notifier.
  @override
  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }

  void setValue(T newValue) {
    _value = newValue;
    notifyListeners();
  }

  void emit(T newValue) {
    _value = newValue;
    notifyListeners();
  }

  /// Re-call all the registered listeners.
  void call(T newValue) {
    _value = newValue;
    notifyListeners();
  }
}
