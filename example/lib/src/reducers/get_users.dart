import '../atoms/atoms.dart';

void getUsers(val) async {
  loading(true);
  await Future.delayed(const Duration(seconds: 2));
  loading(false);
  users(['Felipe', 'Nobre']);
}
