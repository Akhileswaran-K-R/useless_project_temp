import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File? _image;
  String? _detectedTime;
  final ImagePicker _picker = ImagePicker();

  /// Mock clock detection function (replace with your real logic)
  Future<String> detectTimeFromImage(File image) async {
    // TODO: Replace with actual detection logic (ML, OCR, etc.)
    await Future.delayed(const Duration(seconds: 1)); // simulate processing
    return "03:45 PM"; // mock detected time
  }

  /// Pick image from given source
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _detectedTime = null; // reset previous detection
      });

      // Call your clock detection logic
      final detected = await detectTimeFromImage(_image!);
      setState(() {
        _detectedTime = detected;
      });
    }
  }

  /// Bottom sheet for choosing Camera or Gallery
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Image display area
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image == null
                      ? const Text(
                        "No image selected",
                        style: TextStyle(fontSize: 18),
                      )
                      : Image.file(_image!),

                  const SizedBox(height: 16),

                  // Show detected time if available
                  // Show detected time or fallback message
                  Text(
                    _detectedTime != null
                        ? "Detected Time: $_detectedTime"
                        : "No time available",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _detectedTime != null ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Button area
          Container(
            height: 80,
            color: const Color.fromARGB(255, 119, 114, 114),
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _showPickerOptions,
                child: const Text(
                  "Add Image",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
