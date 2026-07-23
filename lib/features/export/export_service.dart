import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  Future<File> _writeToTempFile(String filename, List<int> bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> exportMarkdown(String title, String content) async {
    final safeTitle = _sanitizeFilename(title);
    final bytes = utf8.encode('# $title\n\n$content');
    final file = await _writeToTempFile('$safeTitle.md', bytes);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: title),
    );
  }

  Future<void> exportPdf(String title, String content) async {
    final safeTitle = _sanitizeFilename(title);
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, text: title),
          pw.Paragraph(text: content),
        ],
      ),
    );

    final bytes = await doc.save();
    final file = await _writeToTempFile('$safeTitle.pdf', bytes);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: title),
    );
  }

  Future<void> exportDocx(String title, String content) async {
    final safeTitle = _sanitizeFilename(title);
    final bytes = _buildMinimalDocx(title, content);
    final file = await _writeToTempFile('$safeTitle.docx', bytes);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: title),
    );
  }

  String _sanitizeFilename(String input) {
    final cleaned = input.trim().replaceAll(RegExp(r'[^\w\s-]'), '');
    return cleaned.isEmpty ? 'note' : cleaned.replaceAll(' ', '_');
  }

  /// Builds a minimal but valid .docx file (OOXML inside a zip archive).
  /// Content is plain-text — each line of the body becomes its own paragraph.
  List<int> _buildMinimalDocx(String title, String content) {
    final archive = Archive();

    void addTextFile(String path, String content) {
      final bytes = utf8.encode(content);
      archive.addFile(ArchiveFile(path, bytes.length, bytes));
    }

    addTextFile('[Content_Types].xml', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>''');

    addTextFile('_rels/.rels', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>''');

    final bodyParagraphs = StringBuffer();
    bodyParagraphs.writeln(
      '<w:p><w:pPr><w:pStyle w:val="Title"/></w:pPr><w:r><w:t xml:space="preserve">${_xmlEscape(title)}</w:t></w:r></w:p>',
    );
    for (final line in content.split('\n')) {
      bodyParagraphs.writeln(
        '<w:p><w:r><w:t xml:space="preserve">${_xmlEscape(line)}</w:t></w:r></w:p>',
      );
    }

    addTextFile('word/document.xml', '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
<w:body>
$bodyParagraphs
<w:sectPr/>
</w:body>
</w:document>''');

    final zipBytes = ZipEncoder().encode(archive);
    return zipBytes;
  }

  String _xmlEscape(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}