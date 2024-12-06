import '../entities/church.dart';
import '../repositories/church_repository.dart';

class GetChurch {
  final ChurchRepository repository;

  GetChurch(this.repository);

  Future<Church?> call(String id) async {
    return repository.getChurchById(id);
  }
}
