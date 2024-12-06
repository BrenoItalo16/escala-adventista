import '../entities/church.dart';
import '../repositories/church_repository.dart';

class GetChurches {
  final ChurchRepository repository;

  GetChurches(this.repository);

  Future<List<Church>> call() async {
    return repository.getChurches();
  }
}
