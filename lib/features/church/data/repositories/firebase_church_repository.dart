import '../../../../core/data/datasources/firebase_database_datasource.dart';
import '../../domain/entities/church.dart';
import '../../domain/repositories/church_repository.dart';
import '../models/church_model.dart';

class FirebaseChurchRepository implements ChurchRepository {
  final IFirebaseDatabaseDatasource _firebaseDataSource;
  static const String _collectionPath = 'churches';

  FirebaseChurchRepository({
    required IFirebaseDatabaseDatasource firebaseDataSource,
  }) : _firebaseDataSource = firebaseDataSource;

  @override
  Future<void> createChurch(Church church) async {
    try {
      final churchModel = ChurchModel.fromEntity(church);
      final ref = _firebaseDataSource.getReference(_collectionPath);
      final newChurchRef = ref.push();
      final churchWithId = churchModel.copyWith(id: newChurchRef.key);

      await newChurchRef.set(churchWithId.toJson());
    } catch (e) {
      throw Exception('Erro ao criar igreja: $e');
    }
  }

  @override
  Future<void> deleteChurch(String id) async {
    try {
      await _firebaseDataSource.remove('$_collectionPath/$id');
    } catch (e) {
      throw Exception('Erro ao deletar igreja: $e');
    }
  }

  @override
  Future<Church?> getChurchById(String id) async {
    try {
      final snapshot = await _firebaseDataSource.get('$_collectionPath/$id');
      if (!snapshot.exists || snapshot.value == null) return null;

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data['id'] = id; // Ensure ID is included
      return ChurchModel.fromJson(data).toEntity();
    } catch (e) {
      throw Exception('Erro ao buscar igreja: $e');
    }
  }

  @override
  Future<List<Church>> getChurches() async {
    try {
      final snapshot = await _firebaseDataSource.get(_collectionPath);
      if (!snapshot.exists || snapshot.value == null) return [];

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries.map((e) {
        final churchData = Map<String, dynamic>.from(e.value as Map);
        churchData['id'] = e.key;
        return ChurchModel.fromJson(churchData).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar igrejas: $e');
    }
  }

  @override
  Future<List<Church>> getChurchesByOwnerId(String ownerId) async {
    try {
      final snapshot = await _firebaseDataSource.query(
        _collectionPath,
        orderByChild: 'ownerId',
        equalTo: ownerId,
      );
      if (!snapshot.exists || snapshot.value == null) return [];

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries.map((e) {
        final churchData = Map<String, dynamic>.from(e.value as Map);
        churchData['id'] = e.key;
        return ChurchModel.fromJson(churchData).toEntity();
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar igrejas do usuário: $e');
    }
  }

  @override
  Future<void> updateChurch(Church church) async {
    try {
      if (church.id == null) {
        throw Exception('ID da igreja não pode ser nulo');
      }
      final churchModel = ChurchModel.fromEntity(church);
      await _firebaseDataSource.update(
        '$_collectionPath/${church.id}',
        churchModel.toJson(),
      );
    } catch (e) {
      throw Exception('Erro ao atualizar igreja: $e');
    }
  }

  @override
  Future<void> incrementLikes(String churchId) async {
    try {
      final ref =
          _firebaseDataSource.getReference('$_collectionPath/$churchId');
      final snapshot = await ref.get();
      if (!snapshot.exists || snapshot.value == null) {
        throw Exception('Igreja não encontrada');
      }

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final currentLikes = (data['likesCount'] as int?) ?? 0;
      await ref.update({'likesCount': currentLikes + 1});
    } catch (e) {
      throw Exception('Erro ao incrementar likes: $e');
    }
  }

  @override
  Future<void> decrementLikes(String churchId) async {
    try {
      final ref =
          _firebaseDataSource.getReference('$_collectionPath/$churchId');
      final snapshot = await ref.get();
      if (!snapshot.exists || snapshot.value == null) {
        throw Exception('Igreja não encontrada');
      }

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final currentLikes = (data['likesCount'] as int?) ?? 0;
      await ref.update({'likesCount': currentLikes > 0 ? currentLikes - 1 : 0});
    } catch (e) {
      throw Exception('Erro ao decrementar likes: $e');
    }
  }

  @override
  Future<void> incrementMembers(String churchId) async {
    try {
      final ref =
          _firebaseDataSource.getReference('$_collectionPath/$churchId');
      final snapshot = await ref.get();
      if (!snapshot.exists || snapshot.value == null) {
        throw Exception('Igreja não encontrada');
      }

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final currentMembers = (data['membersCount'] as int?) ?? 0;
      await ref.update({'membersCount': currentMembers + 1});
    } catch (e) {
      throw Exception('Erro ao incrementar membros: $e');
    }
  }

  @override
  Future<void> decrementMembers(String churchId) async {
    try {
      final ref =
          _firebaseDataSource.getReference('$_collectionPath/$churchId');
      final snapshot = await ref.get();
      if (!snapshot.exists || snapshot.value == null) {
        throw Exception('Igreja não encontrada');
      }

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final currentMembers = (data['membersCount'] as int?) ?? 0;
      await ref.update(
          {'membersCount': currentMembers > 0 ? currentMembers - 1 : 0});
    } catch (e) {
      throw Exception('Erro ao decrementar membros: $e');
    }
  }
}
