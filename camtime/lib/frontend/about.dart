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

  Widget _buildProfileCard({
    required String name,
    required String linkedinUrl,
    required String githubUrl,
    required String imageUrl,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.business, color: Colors.blue),
                  onPressed: () => _launchURL(linkedinUrl),
                ),
                IconButton(
                  icon: const Icon(Icons.code, color: Colors.black),
                  onPressed: () => _launchURL(githubUrl),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2c3e50), Color.fromARGB(255, 196, 205, 211)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Developed By",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              _buildProfileCard(
                name: "Abhai Sankar P R",
                linkedinUrl:
                    "https://www.linkedin.com/in/abhai-sankar-p-r-2410b3296",
                githubUrl: "https://github.com/AbhaiSankarPR",
                imageUrl:
                    "https://media.licdn.com/dms/image/v2/D5603AQEYqxKpzEjqSg/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1697304107980?e=1757548800&v=beta&t=uvnetN5HPA07Nt9I6k2Fj7WJndUQNcIJQs8UgpUcCLE", // Replace with actual profile pic URL
              ),
              const SizedBox(height: 20),
              _buildProfileCard(
                name: "Akhileswaran K R",
                linkedinUrl:
                    "https://www.linkedin.com/in/akhileswaran-k-r/",
                githubUrl: "https://github.com/Akhileswaran-K-R",
                imageUrl:
                    "https://media.licdn.com/dms/image/v2/D4D03AQHcZYkWmQQwkA/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1728323545216?e=1757548800&v=beta&t=pR4oCY5rUBAw00AD26xZK5aZEycUviz3EDmM-WhLu1o", // Replace with actual profile pic URL
              ),
            ],
          ),
        ),
      ),
    );
  }
}
