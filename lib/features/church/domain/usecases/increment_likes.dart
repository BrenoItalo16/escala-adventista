import '../repositories/church_repository.dart';

class IncrementLikes {
  final ChurchRepository repository;

  IncrementLikes(this.repository);

  Future<void> call(String churchId) async {
    return repository.incrementLikes(churchId);
  }
}
