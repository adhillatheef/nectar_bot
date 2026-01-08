import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/theme/app_colors.dart';

class TicketAttachmentGallery extends StatelessWidget {
  final List<String> attachments;

  const TicketAttachmentGallery({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.nexusPanel.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: const Text(
          "NO EVIDENCE FILES UPLOADED",
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 1.0, fontFamily: 'Courier'),
          textAlign: TextAlign.center,
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _buildTechThumbnail(attachments[index]);
        },
      ),
    );
  }

  Widget _buildTechThumbnail(String path) {
    // Determine type
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
        width: 110,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          image: isImage ? DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover, opacity: 0.8) : null,
        ),
        child: Stack(
          children: [
            // Center Icon for Non-Images
            if (isVideo || isAudio)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle, border: Border.all(color: AppColors.nexusTeal)),
                  child: Icon(isAudio ? Icons.mic : Icons.play_arrow, color: AppColors.nexusTeal, size: 24),
                ),
              ),

            // File Label Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(11)),
                ),
                child: Text(
                  path.split('/').last,
                  style: const TextStyle(color: Colors.white70, fontSize: 8, fontFamily: 'Courier'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showAudioPlayerDialog(String path) {
    Get.dialog(Dialog(
      backgroundColor: AppColors.nexusPanel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.nexusTeal)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("AUDIO LOG", style: TextStyle(color: AppColors.nexusTeal, fontWeight: FontWeight.bold, fontFamily: 'Courier')),
            const SizedBox(height: 16),
            _SimpleAudioPlayer(path: path),
          ],
        ),
      ),
    ));
  }
}

// --- HELPER CLASSES (Keep these exactly as they are) ---

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
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 48,
      icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: AppColors.nexusTeal),
      onPressed: () async {
        if (isPlaying)
          await _player.pause();
        else
          await _player.play(DeviceFileSource(widget.path));
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
    _vc = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() => _cc = ChewieController(videoPlayerController: _vc, autoPlay: true, looping: false));
      });
  }

  @override
  void dispose() {
    _vc.dispose();
    _cc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(child: _cc != null ? Chewie(controller: _cc!) : const CircularProgressIndicator(color: AppColors.nexusTeal)),
    );
  }
}
