import 'package:flutter/material.dart';

/// TODO : move description to README and create better documentation
///
///  EventHandler
///
///  Register events (callbacks) based on events registered.
///
///  Events can be of type String or ValueNotifier
///
/// To register an event use:
///
/// The [on] method for Strings
///
/// And the [onNotifier]  method for ValueNotifers
///
/// Registering events:
///
/// ```dart
/// final eventHandler = EventHandler();
/// //Register a String based event
/// eventHandler.on('MyEvent', () => print('my event'));
/// //Register a ValueNotifer based event
/// eventHandler.onNotifier(myNotifier, () => print('my event'));
/// ```
///
/// Dispatching events:
/// Dispatch 'MyEvent' passing some arguments.
/// This will invoque the callback registered when the event was created and pass the argument to the it.
/// ```dart
/// eventHandler.dispath('MyEvent', params:{'some-value':true});
/// ```
///
class EventHandler {
  EventHandler._privateConstructor();
  static final EventHandler _instance = EventHandler._privateConstructor();
  factory EventHandler() {
    return _instance;
  }

  final Map<String, Function> _commands = {};

  /// Register a String based event
  void on(String command, Function callback) {
    _commands.putIfAbsent(command, () => callback);
  }

  /// Dispatch a String based command
  Future<T?> dispatch<T>(String command, {dynamic params}) async {
    if (!_commands.containsKey(command)) return null;
    return await _commands[command]!(params);
  }

  /// Dispatch a String based command and remove it from [_commands]
  Future dispatchOnce(String command, {dynamic params}) async {
    if (!_commands.containsKey(command)) return;
    final result = await _commands[command]!(params);
    _commands.remove(command);
    return result;
  }

  ///* Register a [ValueNotifier] based event
  void onNotifier(ValueNotifier notifier, Function callback) {
    _commands.putIfAbsent(notifier.hashCode.toString(), () => callback);
  }

  /// Dispatch a [ValueNotifier] based command
  void dispatchNotifier(ValueNotifier notifier, {dynamic params}) async {
    if (!_commands.containsKey(notifier.hashCode.toString())) return;
    notifier.value = await _commands[notifier.hashCode.toString()]!(params);
  }

  void clearEvents() => _commands.clear();
}
