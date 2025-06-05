import 'package:api/api.dart';
import 'package:domain/models/study/study.dart';

class StudyService {
  Future<List<Study>> getStudies() async {
    try {
      final (data, error) = await StudyApi.getStudies();
      if (error.isNotEmpty) {
        throw StudyException('Failed to fetch studies: $error');
      }
      return data?.map((json) => Study.fromJson(json)).toList() ?? [];
    } catch (e) {
      throw StudyException('Error fetching studies: $e');
    }
  }

  Future<Study> createStudy(Study study) async {
    try {
      final (data, error) = await StudyApi.postStudy(study.toJson());
      if (error.isNotEmpty) {
        throw StudyException('Failed to create study: $error');
      }
      return Study.fromJson(data!);
    } catch (e) {
      throw StudyException('Error creating study: $e');
    }
  }

  Future<Study> updateStudy(int id, Study study) async {
    try {
      final (data, error) = await StudyApi.putStudy(id, study.toJson());
      if (error.isNotEmpty) {
        throw StudyException('Failed to update study: $error');
      }
      return Study.fromJson(data!);
    } catch (e) {
      throw StudyException('Error updating study: $e');
    }
  }

  Future<void> deleteStudy(int id) async {
    try {
      final error = await StudyApi.deleteStudy(id);
      if (error.isNotEmpty) {
        throw StudyException('Failed to delete study: $error');
      }
    } catch (e) {
      throw StudyException('Error deleting study: $e');
    }
  }
}

class StudyException implements Exception {
  final String message;
  StudyException(this.message);

  @override
  String toString() => 'StudyException: $message';
}