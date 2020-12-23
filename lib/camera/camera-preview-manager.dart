import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewManager extends StatefulWidget {
  @override
  _CameraPreviewManagerState createState() => _CameraPreviewManagerState();
}

class _CameraPreviewManagerState extends State<CameraPreviewManager> {
  CameraController cameraController;
  Future<List<CameraDescription>> _initializeCameraControllerFuture;

  double _minAvailableZoom;
  double _maxAvailableZoom;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();

    _initializeCameraControllerFuture = availableCameras();
    _initializeCameraControllerFuture.then((cameras) {
      final firstCamera = cameras[0];
      cameraController = CameraController(firstCamera, ResolutionPreset.medium, enableAudio: false);
      cameraController.initialize().then((_) async {
        _maxAvailableZoom = await cameraController.getMaxZoomLevel();
        _minAvailableZoom = await cameraController.getMinZoomLevel();
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (_pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale).clamp(_minAvailableZoom, _maxAvailableZoom);

    await cameraController.setZoomLevel(_currentScale);
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
      future: _initializeCameraControllerFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || !cameraController.value.isInitialized) {
          return Center(child: CircularProgressIndicator());
        } else {
          return AspectRatio(
              aspectRatio: cameraController.value.aspectRatio,
              child: Listener(
                onPointerDown: (_) => _pointers++,
                onPointerUp: (_) => _pointers--,
                child: GestureDetector(
                  onScaleStart: _handleScaleStart,
                  onScaleUpdate: _handleScaleUpdate,
                  child: CameraPreview(cameraController),
                ),
              ));
          // child: CameraPreview(cameraController));
        }
      },
    );
  }
}
