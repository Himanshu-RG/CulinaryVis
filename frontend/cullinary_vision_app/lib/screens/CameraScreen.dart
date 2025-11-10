import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _controller = CameraController(firstCamera, ResolutionPreset.medium);

      _initializeControllerFuture = _controller!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('⚠️ Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    await _initializeControllerFuture;

    try {
      // Capture the image
      final XFile image = await _controller!.takePicture();
      print('📸 Picture saved to ${image.path}');

      // Send image to Hugging Face API
      await _sendImageToHuggingFace(image.path);
    } catch (e) {
      print('⚠️ Error taking picture: $e');
    }
  }

  Future<void> _sendImageToHuggingFace(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      final uri = Uri.parse('https://himanshuray-aiapp.hf.space/predict/');
      // ✅ Your Hugging Face Space endpoint

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "data": [base64Image],
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final detections = result["data"][0];

        print('✅ Detections: $detections');
        if (detections != null && detections.isNotEmpty) {
          _showResultDialog(List<String>.from(detections));
        } else {
          _showResultDialog(["No objects detected"]);
        }
      } else {
        print('❌ Failed with status: ${response.statusCode}');
        _showResultDialog(["Error: Failed to get detections"]);
      }
    } catch (e) {
      print('⚠️ Error sending image: $e');
      _showResultDialog(["Error: $e"]);
    }
  }

  void _showResultDialog(List<String> results) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detected Objects'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: results
              .map(
                (r) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Chip(
                    label: Text(
                      r,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Ingredients')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _isCameraInitialized) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CameraPreview(_controller!),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: FloatingActionButton(
                    onPressed: _takePicture,
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
