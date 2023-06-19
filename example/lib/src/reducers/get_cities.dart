import '../atoms/atoms.dart';

Future getCities(_) async {
  citiesLoading(true);
  await Future.delayed(const Duration(seconds: 2));
  citiesLoading(false);
  title("PAGE TITLE");
  return ['Milan', 'London', 'Oxford'];
}
