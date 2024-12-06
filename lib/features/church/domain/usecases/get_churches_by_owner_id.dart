import '../entities/church.dart';
import '../repositories/church_repository.dart';

class GetChurchesByOwnerId {
  final ChurchRepository repository;

  GetChurchesByOwnerId(this.repository);

  Future<List<Church>> call(String ownerId) async {
    return await repository.getChurchesByOwnerId(ownerId);
  }
}
