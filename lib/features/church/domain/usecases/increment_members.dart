import '../repositories/church_repository.dart';

class IncrementMembers {
  final ChurchRepository repository;

  IncrementMembers(this.repository);

  Future<void> call(String churchId) async {
    return repository.incrementMembers(churchId);
  }
}
