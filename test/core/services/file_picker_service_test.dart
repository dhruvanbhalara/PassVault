import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:passvault/core/services/file_picker_service_impl.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFilePicker extends Mock
    with MockPlatformInterfaceMixin
    implements FilePicker {}

class MockFileSaver extends Mock implements FileSaver {}

class MockFilePickerResult extends Mock implements FilePickerResult {}

class MockPlatformFile extends Mock implements PlatformFile {}

void main() {
  late FilePickerServiceImpl service;
  late MockFilePicker mockFilePicker;
  late MockFileSaver mockFileSaver;

  setUpAll(() {
    registerFallbackValue(FileType.any);
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(<String>[]);
    registerFallbackValue(MimeType.other);
  });

  setUp(() {
    mockFilePicker = MockFilePicker();
    mockFileSaver = MockFileSaver();
    FilePicker.platform = mockFilePicker; // Inject mock platform
    service = FilePickerServiceImpl();
    service.fileSaver = mockFileSaver;
  });

  group('$FilePickerServiceImpl', () {
    test('pickSavePath calls fileSaver.saveAs', () async {
      when(
        () => mockFileSaver.saveAs(
          name: any(named: 'name'),
          bytes: any(named: 'bytes'),
          fileExtension: any(named: 'fileExtension'),
          mimeType: any(named: 'mimeType'),
        ),
      ).thenAnswer((_) async => '/path/to/save.json');

      final result = await service.pickSavePath(
        fileName: 'test.json',
        bytes: [1, 2, 3],
        allowedExtensions: ['json'],
      );

      expect(result, '/path/to/save.json');
      verify(
        () => mockFileSaver.saveAs(
          name: 'test',
          bytes: any(named: 'bytes', that: equals([1, 2, 3])),
          fileExtension: 'json',
          mimeType: MimeType.json,
        ),
      ).called(1);
    });

    test(
      'pickFile calls FilePicker.platform.pickFiles and returns path',
      () async {
        final mockResult = MockFilePickerResult();
        final mockFile = MockPlatformFile();

        when(() => mockFile.path).thenReturn('/path/to/file.json');
        when(() => mockResult.files).thenReturn([mockFile]);
        when(
          () => mockFilePicker.pickFiles(
            type: any(named: 'type'),
            allowedExtensions: any(named: 'allowedExtensions'),
          ),
        ).thenAnswer((_) async => mockResult);

        final result = await service.pickFile(allowedExtensions: ['json']);

        expect(result, '/path/to/file.json');
        verify(
          () => mockFilePicker.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['json'],
          ),
        ).called(1);
      },
    );

    test('pickDirectory calls FilePicker.platform.getDirectoryPath', () async {
      when(
        () => mockFilePicker.getDirectoryPath(),
      ).thenAnswer((_) async => '/path/to/dir');

      final result = await service.pickDirectory();

      expect(result, '/path/to/dir');
      verify(() => mockFilePicker.getDirectoryPath()).called(1);
    });
  });
}
