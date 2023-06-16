
# Atomic Lite
Atomic Lite is a simple and light weight extension to manage state state in Flutter. 

It is based on the Atomic State pattern. 

Atomic State implies using Atoms as a single source of the state. So no more variables inside controllers, etc.
It's all based on Atoms (ValueNotifiers) and Reducers (functions where we change the state of the Atom).

I dont want to call it a state manager or not even a package because it is very simple and  people could just clone this repo and do their own implementation.

This library was inpired by [Flutterando's ASP package](https://github.com/Flutterando/asp).

It's called Lite because it does not depend on other packages or setups. It's all based on events and ValueNotifiers.
[Flutterando's ASP package](https://github.com/Flutterando/asp) approach is great but it is heavily dependend on [RxNotifer](https://github.com/Flutterando/rx_notifier) and  would like to try the same concept but with a simpler approach.

## Atoms
An Atom is not but an extension of ValueNotifer.


### usage
```dart 
    // atoms.dart

    // Defines an Atom
    final isLoading = Atom(false);
    final cities = Atom(<String>[]);

    // We can set a value in different ways:

    // - using a callable method
    isLoading(true);
    // - using setValue method
    isloading.setValue(true);
    // - using the normal value notifer setter
    isLoading.value = true;

    cities(['London', 'Milan']);

```
#### How to watch the values
There is an an extension on ValueNotifer where we can watch for changes in the Atoms and reflect it in the view.

It's just a simplified way to use ValueListanableBuilder

```dart
    // some_view.dart
    
    isLoading.watchPrimitive((_) =>  CircularProgressIndicator()),
    cities.watchPrimitive((cities) => Column(
            children: cities.map((city) => Text(city)).toList(),
        );
    ),
    
```
 The `watchPrimitive` extension listens to changes in the value and build the widget passed in `onDataChanged` positional attribute, returning the updated value.

 The extension checks for primitive values before updating the widget.

 This ways we dont need to do things like:
 ```dart
    isLoading.watchPrimitive((value) => value ?  CircularProgressIndicator() : SizedBox()),
 ```
 Currently we check if `String` is not empty, `List` is not empty and is a `boolean` is true;

 If your Atom has a custom type or even a `Record`, you can use the  `watch` extension.
 ```dart
    // Custom states
    abstract class MysState();
    class CarsStateLoading extends MysState();
    class CarsStateDone extends MysState();
  
    final cities<MysState>();

    cities.watch((state) {
            if (state is CarsStateLoading) return const CircularProgressIndicator();
            if (state is CarsStateDone) {
                return Column(
                children: state.cars.map((car) => Text(car)).toList(),
                );
            }
            return const SizedBox();
        },
    ),

    // Records
    final someRecord = Atom((message: '', show: false));
    someRecord.watchRecord((value) => value.show ? Text(value.message) : const SizedBox()),
 ```
