import '../entities/church.dart';

abstract class ChurchRepository {
  Future<List<Church>> getChurches();
  Future<Church?> getChurchById(String id);
  Future<List<Church>> getChurchesByOwnerId(String ownerId);
  Future<void> createChurch(Church church);
  Future<void> updateChurch(Church church);
  Future<void> deleteChurch(String id);
  Future<void> incrementLikes(String churchId);
  Future<void> decrementLikes(String churchId);
  Future<void> incrementMembers(String churchId);
  Future<void> decrementMembers(String churchId);
}
