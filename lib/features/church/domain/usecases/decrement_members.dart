import '../repositories/church_repository.dart';

class DecrementMembers {
  final ChurchRepository repository;

  DecrementMembers(this.repository);

  Future<void> call(String churchId) async {
    return repository.decrementMembers(churchId);
  }
}
