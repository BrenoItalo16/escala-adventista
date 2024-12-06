import '../repositories/church_repository.dart';

class DeleteChurch {
  final ChurchRepository repository;

  DeleteChurch(this.repository);

  Future<void> call(String id) async {
    return repository.deleteChurch(id);
  }
}
