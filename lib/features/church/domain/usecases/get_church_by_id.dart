import '../entities/church.dart';
import '../repositories/church_repository.dart';

class GetChurchById {
  final ChurchRepository repository;

  GetChurchById(this.repository);

  Future<Church?> call(String id) async {
    return await repository.getChurchById(id);
  }
}
