import 'package:flutter/material.dart';

class RemoteVideoSurface extends StatelessWidget {
  final String videoUrl;

  const RemoteVideoSurface({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    // Placeholder using Image.network to simulate video feed
    // In real app this would be RTCVideoView
    return Container(
      color: Colors.black,
      child: Image.network(
        videoUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.black,
          alignment: Alignment.center,
          child:
              const Icon(Icons.videocam_off, color: Colors.white54, size: 64),
        ),
      ),
    );
  }
}
