import '../repositories/church_repository.dart';

class DecrementLikes {
  final ChurchRepository repository;

  DecrementLikes(this.repository);

  Future<void> call(String churchId) async {
    return repository.decrementLikes(churchId);
  }
}
