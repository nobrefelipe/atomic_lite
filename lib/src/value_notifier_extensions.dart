import 'package:flutter/cupertino.dart';

extension AtomicLiteValueNotifierExtensions<T> on ValueNotifier<T> {
  /// Watch for changes in the value and build the widget passed in [onDataChanged], returning the updated value.
  ///
  ///
  /// To avoid checking the values in the view, we do it here so we are sure to only return the given widget if the value is valid.
  Widget watchPrimitive(Widget Function(T) onDataChanged) {
    return ValueListenableBuilder(
      valueListenable: this,
      builder: (_, value, __) {
        ///* Workround for List types
        ///* We need to explicitly define the list type in order to it to work on the switch below
        if (value is List && value.isNotEmpty) {
          return onDataChanged(value);
        }

        return switch (value.runtimeType) {
          bool => (value as bool) ? onDataChanged(value) : const SizedBox(),
          String => (value as String).isNotEmpty ? onDataChanged(value) : const SizedBox(),

          ///! this doesnt work because we need to explicitly define the list type
          //const (List) => (value as List).isNotEmpty ? onDataChanged(value) : const SizedBox(),
          _ => const SizedBox(),
        };
      },
    );
  }

  /// If you have your own state, you can use this extension to build the widget based on the given state.
  Widget watch(Widget Function(T) onDataChanged) {
    return ValueListenableBuilder(
      valueListenable: this,
      builder: (_, value, __) => onDataChanged(value),
    );
  }
}
