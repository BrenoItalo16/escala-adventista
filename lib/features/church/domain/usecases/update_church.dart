import '../entities/church.dart';
import '../repositories/church_repository.dart';

class UpdateChurch {
  final ChurchRepository repository;

  UpdateChurch(this.repository);

  Future<void> call(Church church) async {
    return repository.updateChurch(church);
  }
}
