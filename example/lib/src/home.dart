import 'package:atomic_lite/atomic_lite.dart';
import 'package:flutter/material.dart';

import 'atoms/atoms.dart';
import 'home_controller.dart';
import 'states/my_states.dart';

Future getCitiesFake(params) async {
  citiesLoading(true);
  await Future.delayed(const Duration(seconds: 2));
  someRecord.setValue((message: 'Some Record', show: true));
  citiesLoading(false);
  return ['Oxford', 'Lugano', 'Lisboa'];
}

class AtomicHome extends StatefulWidget {
  const AtomicHome({super.key});

  @override
  State<AtomicHome> createState() => _AtomicHomeState();
}

class _AtomicHomeState extends State<AtomicHome> {
  late EventHandler eventHandler;
  late HomeController userController;
  late CarsController carsController;

  @override
  void initState() {
    super.initState();
    eventHandler = EventHandler();
    userController = HomeController.instance(eventHandler, getCities: getCitiesFake);
    carsController = CarsController.instance(eventHandler);
    // Listenable.merge([cities, citiesLoading]).addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title.watch((value) => Text(value, style: const TextStyle(fontSize: 40))),
      ),
      body: Center(
        child: SizedBox(
          height: 400,
          child: Column(
            children: [
              FilledButton(
                child: const Text('Get Cities'),
                onPressed: () async {
                  userController.get(cities, params: {'some_filter': "123"});
                },
              ),
              someRecord.watch((value) => value.show ? Text(value.message) : const SizedBox()),
              citiesLoading.watchPrimitive((_) => const CircularProgressIndicator()),
              cities.watchPrimitive((cities) {
                return Column(
                  children: cities.map((city) => Text(city)).toList(),
                );
              }),
              FilledButton(
                child: const Text('Get Users'),
                onPressed: () async {
                  /// we can call methods directly
                  eventHandler.dispatch('getUsers');

                  /// or we can use a controller
                  // final List<String> res = await userController('getUsers');

                  /// or we can call them directly
                  // final List<String> res = await getUsers(null);
                },
              ),
              ListenableBuilder(
                listenable: Listenable.merge([users, loading]),
                builder: (_, __) {
                  if (loading.value) return const CircularProgressIndicator();
                  if (users.value.isNotEmpty) {
                    return Column(
                      children: users.value.map((user) => Text(user)).toList(),
                    );
                  }
                  return const SizedBox();
                },
              ),
              FilledButton(
                child: const Text('Get Cars'),
                onPressed: () => carsController('getCars'),
              ),
              carsState.watch((state) {
                return switch (state) {
                  CarsStateLoading() => const CircularProgressIndicator(),
                  CarsStateDone(cars: final cars) => Column(
                      children: cars.map((car) => Text(car)).toList(),
                    ),
                  _ => const SizedBox(),
                };
              }),
            ],
          ),
        ),
      ),
    );
  }
}
