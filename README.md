
# Atomic Lite
Atomic Lite is a simple and light weight extension to manage state state in Flutter. 

It is based on the Atomic State pattern. 

Atomic State implies using Atoms as a single source of the state. So no more variables inside controllers, etc.
It's all based on Atoms (ValueNotifiers) and Reducers (functions where we change the state of the Atom).

I dont want to call it a state manager or not even a package because it is very simple and  people could just clone this repo and do their own implementation.

This library was inpired by [Flutterando's ASP package](https://github.com/Flutterando/asp).

It's called Lite because it does not depend on other packages or setups. It's all based on events and ValueNotifiers.
[Flutterando's ASP package](https://github.com/Flutterando/asp) approach is great but it is heavily dependend on [RxNotifer](https://github.com/Flutterando/rx_notifier) and I would like to try the same concept but with a simpler approach.

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
    sealed class MysState();
    class StateLoading extends MysState();
    class StateDone extends MysState();
    
    // Atom
    final cities = Atom<MysState>();

    // View
    cities.watch((state) {
        return switch (state) {
            StateLoading() => const CircularProgressIndicator(),
            StateDone(cities: final cities) => Column(
                children: cities.map((city) => Text(city)).toList(),
            ),
            _ => const SizedBox(),
        };
        }
    ),
   

    // Records
    final someRecord = Atom((message: '', show: false));
    someRecord.watch((value) => value.show ? Text(value.message) : const SizedBox()),
 ```

## Reducers
The simplest way we can reduce the buisiness logic to output the state is by using functions that updates the value of an `Atom`.

```dart
    //my_atoms.dart
    final cities = Atom(<String>[]);

    // get_city_reducer.dart
    void getCities() async {
        final response = await MyGetCittyRepository.get();
        // your business logic here...
        cities.seValue(response.cities);
    }
    
```

For more robust solutions we can also use the `AtomicController` class to create controllers.

`AtomicController` has some useful method to register and trigger events.

```dart
    // cities_reducer.dart
    void getCities(dynamic params) async{
        final response = await MyGetCityRepository.get();
        // your business logic here...

        // not that in this case we dont need to use  cities.seValue.
        // becase the onAtom tirgger bellow will automatic set the value of cities to the returned data.
        return response.cities;
    }

    // cities_controller.dart
    class CitiesController extends AtomicController {
        // receive the getCities reducer by dependecy injection
        // this way we can pass any function to perform the task, making it easy to test.
        final Function getCities;

        CitiesController.instance(
            // AtomicController requires an intance of EventHandler. 
            // EventHandler is the responsible for registering and firing events.
            super.eventHandler, {
            required this.getCities,
        }) : super.instance() {
            // onAtom is a trigger to emit the event and invoque the registered reducer.
            // once the reducer is finished it will update the Atom's value with the returned data.
            onAtom(cities, getCities);
        }
    }


    // my_cties_view.dart

    final eventHandler = EventHandler();
    final citiesController = CitiesController(eventHandler, getCities: getCitiesFromMock);
    
    // Use the GET method passing the Atom name to trigger the reducer registered above.
    // not that we can pass parameters using the params attribute.
    citiesController.get(cities, params: {'some_filter': "123"});

```