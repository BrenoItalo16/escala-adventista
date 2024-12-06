import '../entities/church.dart';
import '../repositories/church_repository.dart';

class CreateChurch {
  final ChurchRepository repository;

  CreateChurch(this.repository);

  Future<void> call(Church church) async {
    return repository.createChurch(church);
  }
}
