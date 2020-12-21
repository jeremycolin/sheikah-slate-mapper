import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController cameraController;
  Future<List<CameraDescription>> _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    _initializeCameraControllerFuture = availableCameras();
    _initializeCameraControllerFuture.then((cameras) {
      final firstCamera = cameras[0];
      cameraController = CameraController(firstCamera, ResolutionPreset.medium);
      cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
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
              child: CameraPreview(cameraController));
        }
      },
    );
  }
}
