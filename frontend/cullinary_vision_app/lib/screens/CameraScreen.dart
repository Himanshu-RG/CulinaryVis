import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // Controller for the camera
  CameraController? _controller;
  // Future to initialize the controller
  Future<void>? _initializeControllerFuture;

  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize the camera as soon as the widget is created
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // 1. Get a list of available cameras
    final cameras = await availableCameras();
    // 2. Get the first camera from the list (usually the back camera)
    final firstCamera = cameras.first;

    // 3. Create a new CameraController
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium, // Use medium resolution
    );

    // 4. Initialize the controller
    _initializeControllerFuture = _controller!.initialize();

    // 5. Set state to rebuild the UI once initialized
    // We check if it's mounted to avoid errors if user backs out
    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    // 6. Dispose of the controller when the widget is disposed
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    // Wait until the controller is initialized
    await _initializeControllerFuture;

    try {
      // 7. Take the picture and get the file path
      final XFile image = await _controller!.takePicture();

      // TODO: Send this image (image.path) to Person 2's backend function
      print('Picture saved to ${image.path}');

      // Go back to the previous screen (HomeScreen)
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Ingredients')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CameraPreview(_controller!),
                // --- This is the "Take Picture" button ---
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: FloatingActionButton(
                    onPressed: _takePicture, // Call the function
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
              ],
            );
          } else {
            // Otherwise, display a loading indicator
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
