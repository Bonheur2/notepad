import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class _Stroke {
  final List<Offset> points;
  final Color color;
  final double width;

  _Stroke({required this.points, required this.color, required this.width});
}

class HandwritingCanvasScreen extends StatefulWidget {
  final String? existingSketchPath;

  const HandwritingCanvasScreen({super.key, this.existingSketchPath});

  @override
  State<HandwritingCanvasScreen> createState() => _HandwritingCanvasScreenState();
}

class _HandwritingCanvasScreenState extends State<HandwritingCanvasScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  final List<_Stroke> _strokes = [];
  Color _selectedColor = Colors.black;
  double _strokeWidth = 3;

  ui.Image? _backgroundImage;
  bool _loadingBackground = true;

  static String _colorName(Color color) {
    if (color == Colors.black) return 'black';
    if (color == Colors.red) return 'red';
    if (color == Colors.blue) return 'blue';
    if (color == Colors.green) return 'green';
    return 'custom';
  }

  @override
  void initState() {
    super.initState();
    _loadExistingSketch();
  }

  Future<void> _loadExistingSketch() async {
    final path = widget.existingSketchPath;
    if (path == null) {
      setState(() => _loadingBackground = false);
      return;
    }
    final bytes = await File(path).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    if (mounted) {
      setState(() {
        _backgroundImage = frame.image;
        _loadingBackground = false;
      });
    }
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _strokes.add(_Stroke(
        points: [details.localPosition],
        color: _selectedColor,
        width: _strokeWidth,
      ));
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _strokes.last.points.add(details.localPosition);
    });
  }

  void _undo() {
    if (_strokes.isEmpty) return;
    setState(() => _strokes.removeLast());
  }

  void _clear() {
    setState(() => _strokes.clear());
  }

  Future<void> _saveAndReturn() async {
    if (_strokes.isEmpty) {
      if (mounted) Navigator.of(context).pop(null);
      return;
    }

    final boundary = _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    final dir = await getApplicationDocumentsDirectory();
    final filename = 'sketch_${const Uuid().v4()}.png';
    final file = File('${dir.path}/sketches/$filename');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(pngBytes);

    final oldPath = widget.existingSketchPath;
    if (oldPath != null && oldPath != file.path) {
      final oldFile = File(oldPath);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }
    }

    if (mounted) Navigator.of(context).pop(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Handwriting'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Undo last stroke',
            onPressed: _undo,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear all strokes',
            onPressed: _clear,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save sketch',
            onPressed: _saveAndReturn,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                for (final color in [Colors.black, Colors.red, Colors.blue, Colors.green])
                  Semantics(
                    label: 'Select ${_colorName(color)} pen color',
                    button: true,
                    selected: _selectedColor == color,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor == color
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Semantics(
                    label: 'Pen stroke width',
                    child: Slider(
                      min: 1,
                      max: 12,
                      value: _strokeWidth,
                      onChanged: (v) => setState(() => _strokeWidth = v),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loadingBackground
                ? const Center(child: CircularProgressIndicator())
                : RepaintBoundary(
                    key: _repaintKey,
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: GestureDetector(
                        onPanStart: _onPanStart,
                        onPanUpdate: _onPanUpdate,
                        child: CustomPaint(
                          painter: _SketchPainter(_strokes, _backgroundImage),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SketchPainter extends CustomPainter {
  final List<_Stroke> strokes;
  final ui.Image? backgroundImage;

  _SketchPainter(this.strokes, this.backgroundImage);

  @override
  void paint(Canvas canvas, Size size) {
    final background = backgroundImage;
    if (background != null) {
      canvas.drawImageRect(
        background,
        Rect.fromLTWH(0, 0, background.width.toDouble(), background.height.toDouble()),
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint(),
      );
    }

    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SketchPainter oldDelegate) => true;
}
