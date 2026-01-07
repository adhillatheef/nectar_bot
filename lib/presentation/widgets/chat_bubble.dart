import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../core/theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isBot;
  final String? attachmentPath;
  final String? attachmentType; // 'image', 'video', 'audio'

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isBot,
    this.attachmentPath,
    this.attachmentType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine content type safely
    bool isImage = attachmentPath != null && (attachmentType == 'image' || _isImageFile(attachmentPath!));
    bool isVideo = attachmentPath != null && (attachmentType == 'video' || _isVideoFile(attachmentPath!));
    bool isAudio = attachmentPath != null && (attachmentType == 'audio' || _isAudioFile(attachmentPath!));

    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isBot ? AppColors.botBubble : AppColors.userBubble,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isBot ? Radius.zero : const Radius.circular(16),
            bottomRight: isBot ? const Radius.circular(16) : Radius.zero,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image
            if (isImage) _ImageBubble(path: attachmentPath!),

            // 2. Video
            if (isVideo) _VideoBubble(path: attachmentPath!),

            // 3. Audio
            if (isAudio) _AudioBubble(path: attachmentPath!, isBot: isBot),

            // 4. Text
            if (text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper logic to double-check types if 'attachmentType' is null (resume scenario)
  bool _isImageFile(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.jpg') || ext.endsWith('.jpeg') || ext.endsWith('.png') || ext.endsWith('.heic');
  }

  bool _isVideoFile(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.mp4') || ext.endsWith('.mov') || ext.endsWith('.avi');
  }

  bool _isAudioFile(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith('.m4a') || ext.endsWith('.mp3') || ext.endsWith('.aac');
  }
}

// --- SUB-WIDGETS ---

class _ImageBubble extends StatelessWidget {
  final String path;
  const _ImageBubble({required this.path});

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    return GestureDetector(
      onTap: () {
        if (file.existsSync()) {
          Get.to(() => Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
            body: Center(child: InteractiveViewer(child: Image.file(file))),
          ));
        } else {
          Get.snackbar("Error", "File not found on device storage");
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Hero(
            tag: path,
            child: Image.file(
              file,
              height: 150,
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // THIS CONTAINER PREVENTS THE "EMPTY BUBBLE"
                return Container(
                  height: 150,
                  width: 200,
                  color: Colors.grey[200],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image_rounded, color: Colors.grey, size: 32),
                      SizedBox(height: 4),
                      Text("Image unavailable", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ... (_VideoBubble and _AudioBubble remain the same as previous) ...
// Copy them from the previous response or keep your existing ones.
class _VideoBubble extends StatelessWidget {
  final String path;
  const _VideoBubble({required this.path});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => _FullScreenVideoPlayer(path: path));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        width: 200,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
              SizedBox(height: 8),
              Text("Tap to Play Video", style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioBubble extends StatefulWidget {
  final String path;
  final bool isBot;
  const _AudioBubble({required this.path, required this.isBot});
  @override
  State<_AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<_AudioBubble> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => isPlaying = state == PlayerState.playing);
    });
    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => duration = d);
    });
    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => position = p);
    });
    _audioPlayer.setSourceDeviceFile(widget.path);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatTime(Duration d) {
    final min = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
            color: AppColors.primaryPurple,
            iconSize: 32,
            onPressed: () async {
              if (isPlaying) {
                await _audioPlayer.pause();
              } else {
                await _audioPlayer.play(DeviceFileSource(widget.path));
              }
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    trackHeight: 2,
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    activeColor: AppColors.primaryPurple,
                    inactiveColor: Colors.grey[300],
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(position);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatTime(position), style: const TextStyle(fontSize: 10)),
                      Text(_formatTime(duration), style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(widget.path));
    _videoPlayerController.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
          aspectRatio: _videoPlayerController.value.aspectRatio,
        );
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(
        child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(),
      ),
    );
  }
}