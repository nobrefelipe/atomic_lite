import 'package:flutter/foundation.dart';

import 'atom.dart';
import 'event_handler.dart';

abstract class AtomicController {
  final EventHandler eventHandler;
  AtomicController.instance(this.eventHandler);

  ///* used to register an Atom event
  @protected
  on(Atom command, Function callback) {
    eventHandler.onNotifier(command, callback);
  }

  ///* used to register String based events
  @protected
  onString(String command, Function callback) {
    eventHandler.on(command, callback);
  }

  ///* eg: controller('someEvent');
  Future<T> call<T>(String event, {dynamic params}) async {
    return await eventHandler.dispatch(event, params: params);
  }

  ///* eg: controller.emit('someEvent');
  Future<T> emit<T>(String event, {dynamic params}) async {
    return await eventHandler.dispatch(event, params: params);
  }

  ///* eg: controller.get(myAtom)
  void get(Atom atom, {dynamic params}) {
    eventHandler.dispatchNotifier(atom, params: params);
  }
}
