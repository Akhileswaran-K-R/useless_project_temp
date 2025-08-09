import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File? _image;
  String? _detectedTime;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  /// Call Flask backend to detect time from image
  Future<String?> detectTimeFromImage(File image) async {
    try {
      setState(() => _isLoading = true);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'http://10.0.2.2:5000/detect-time',
        ), // Change if using phone/emulator
      );
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(responseBody);
        return jsonData['time']?.isNotEmpty == true ? jsonData['time'] : null;
      } else {
        print("Server error: ${response.statusCode} - $responseBody");
        return null;
      }
    } catch (e) {
      print("Error detecting time: $e");
      return null;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Pick image from given source
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _detectedTime = null; // reset previous detection
      });

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
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(
                          26,
                        ), // set radius here
                        child: Image.file(
                          _image!,
                          width: 380,
                          height: 320,
                          fit: BoxFit.cover,
                        ),
                      ),

                  const SizedBox(height: 16),

                  _isLoading
                      ? const CircularProgressIndicator(
                        color: Color.fromRGBO(218, 157, 25, 1),
                      )
                      : _detectedTime != null
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What we detected is:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4), // small space
                          Text(
                            _detectedTime!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      )
                      : Text(
                        "No time available",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                ],
              ),
            ),
          ),

          // Button area
          Container(
            height: 150,
            // color: const Color.fromARGB(255, 119, 114, 114),
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 97, 58, 58),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _showPickerOptions,
                child: const Text(
                  "Add Image",
                  style: TextStyle(
                    color: Color.fromARGB(255, 97, 58, 58),
                    fontSize: 16,
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
