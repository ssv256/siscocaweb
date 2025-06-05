/// Exception thrown if a storage operation fails.
class StorageException implements Exception {

  const StorageException(this.error);

  /// Error thrown during the storage operation.
  final Object error;
}

/// * Throws a [StorageException] if fails.
abstract class Storage {
 
  Future<String?> read({required String key});
  
  Future<void> write({required String key, required String value});

  Future<void> delete({required String key});

  Future<void> clear();
}
