import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/theme/app_colors.dart';

class TicketAttachmentGallery extends StatelessWidget {
  final List<String> attachments;

  const TicketAttachmentGallery({Key? key, required this.attachments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
            "No attachments",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _buildThumbnail(attachments[index]);
        },
      ),
    );
  }

  Widget _buildThumbnail(String path) {
    bool isVideo = path.toLowerCase().endsWith('.mp4') || path.toLowerCase().endsWith('.mov');
    bool isAudio = path.toLowerCase().endsWith('.m4a') || path.toLowerCase().endsWith('.mp3');
    bool isImage = !isVideo && !isAudio;

    return GestureDetector(
      onTap: () {
        if (isImage) Get.to(() => _FullScreenViewer(child: Image.file(File(path))));
        if (isVideo) Get.to(() => _FullScreenVideoPlayer(path: path));
        if (isAudio) _showAudioPlayerDialog(path);
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          image: isImage ? DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover) : null,
        ),
        child: isImage ? null : Center(
          child: Icon(
            isAudio ? Icons.mic : Icons.play_circle_fill,
            color: AppColors.nectarPurple,
            size: 32,
          ),
        ),
      ),
    );
  }

  void _showAudioPlayerDialog(String path) {
    Get.dialog(Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Audio Note", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _SimpleAudioPlayer(path: path),
          ],
        ),
      ),
    ));
  }
}

// --- HELPER CLASSES FOR MEDIA PLAYBACK ---

class _FullScreenViewer extends StatelessWidget {
  final Widget child;
  const _FullScreenViewer({required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(child: InteractiveViewer(child: child)),
    );
  }
}

class _SimpleAudioPlayer extends StatefulWidget {
  final String path;
  const _SimpleAudioPlayer({required this.path});
  @override
  State<_SimpleAudioPlayer> createState() => _SimpleAudioPlayerState();
}

class _SimpleAudioPlayerState extends State<_SimpleAudioPlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;
  @override
  void dispose() { _player.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 48,
      icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: AppColors.nectarPurple),
      onPressed: () async {
        if (isPlaying) await _player.pause();
        else await _player.play(DeviceFileSource(widget.path));
        setState(() => isPlaying = !isPlaying);
      },
    );
  }
}

class _FullScreenVideoPlayer extends StatefulWidget {
  final String path;
  const _FullScreenVideoPlayer({required this.path});
  @override
  State<_FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<_FullScreenVideoPlayer> {
  late VideoPlayerController _vc;
  ChewieController? _cc;
  @override
  void initState() {
    super.initState();
    _vc = VideoPlayerController.file(File(widget.path))..initialize().then((_) {
      setState(() => _cc = ChewieController(videoPlayerController: _vc, autoPlay: true, looping: false));
    });
  }
  @override
  void dispose() { _vc.dispose(); _cc?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(child: _cc != null ? Chewie(controller: _cc!) : const CircularProgressIndicator()),
    );
  }
}