abstract class FileService {
  Future<bool> exists(String path);
  Future<String> readAsString(String path);
  Future<void> writeAsString(String path, String content);
  Future<List<int>> readAsBytes(String path);
  Future<void> writeAsBytes(String path, List<int> bytes);
}
