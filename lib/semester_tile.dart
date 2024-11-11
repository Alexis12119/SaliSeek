import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SemesterTile extends StatelessWidget {
  final String title;
  final String? url;
  
  const SemesterTile(this.title, {this.url, super.key});

  Future<void> _launchURL(BuildContext context) async {
    if (url != null) {
      try {
        final Uri uri = Uri.parse(url!);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Could not launch $url'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error launching URL: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: url != null ? () => _launchURL(context) : null,
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              ),
              if (url != null)
                const Icon(
                  Icons.link,
                  size: 16,
                  color: Colors.blue,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
