import 'package:domain/models/models.dart';
import 'package:siscoca/app/data/services/study/study_service.dart';

class StudyRepository {
  final StudyService _service;

  StudyRepository(this._service);

  /// Retrieves all studies from the data source
  Future<List<Study>> getStudies() => _service.getStudies();

  /// Creates a new study record
  Future<Study> createStudy(Study study) => _service.createStudy(study);

  /// Updates an existing study's information
  Future<Study> updateStudy(int id, Study study) => 
      _service.updateStudy(id, study);

  /// Deletes a study record by ID
  Future<void> deleteStudy(int id) => _service.deleteStudy(id);
}