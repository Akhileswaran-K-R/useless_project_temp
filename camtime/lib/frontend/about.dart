import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Developed by:\nAbhai Sankar P R & Akhileswaran K R",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.code, color: Colors.black),
                onPressed: () => _launchURL("https://github.com/YOUR_GITHUB"),
              ),
              IconButton(
                icon: const Icon(Icons.business, color: Colors.blue),
                onPressed: () =>
                    _launchURL("https://linkedin.com/in/YOUR_LINKEDIN"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
