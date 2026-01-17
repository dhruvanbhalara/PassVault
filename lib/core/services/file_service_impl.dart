import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:passvault/core/services/file_service.dart';

@LazySingleton(as: FileService)
class FileServiceImpl implements FileService {
  @override
  Future<bool> exists(String path) => File(path).exists();

  @override
  Future<String> readAsString(String path) => File(path).readAsString();

  @override
  Future<void> writeAsString(String path, String content) =>
      File(path).writeAsString(content);

  @override
  Future<List<int>> readAsBytes(String path) => File(path).readAsBytes();

  @override
  Future<void> writeAsBytes(String path, List<int> bytes) =>
      File(path).writeAsBytes(bytes);
}
