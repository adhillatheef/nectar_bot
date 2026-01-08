import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isBot;
  final String? attachmentPath;
  final String? attachmentType;

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
    bool isImage = attachmentPath != null && (attachmentType == 'image' || _checkExt(attachmentPath!, ['jpg', 'png', 'jpeg']));
    bool isVideo = attachmentPath != null && (attachmentType == 'video' || _checkExt(attachmentPath!, ['mp4', 'mov']));
    bool isAudio = attachmentPath != null && (attachmentType == 'audio' || _checkExt(attachmentPath!, ['m4a', 'mp3']));

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // BOT AVATAR
          if (isBot) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/nectar_logo.png'),
              child: null,
            ),
            const SizedBox(width: 8),
          ],

          // BUBBLE CONTENT
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                // Gradient for User, White for Bot
                gradient: isBot ? null : AppColors.primaryGradient,
                color: isBot ? Colors.white : null,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isBot ? const Radius.circular(4) : const Radius.circular(20),
                  bottomRight: isBot ? const Radius.circular(20) : const Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isImage) _ImageThumbnail(path: attachmentPath!),
                  if (isVideo) _VideoThumbnail(path: attachmentPath!),
                  if (isAudio) _AudioPlayerWidget(path: attachmentPath!, isBot: isBot),

                  if (text.isNotEmpty)
                    Text(
                      text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isBot ? AppColors.textPrimary : Colors.white,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _checkExt(String path, List<String> exts) {
    final ext = path.toLowerCase().split('.').last;
    return exts.contains(ext);
  }
}

// --- THUMBNAILS ---

class _ImageThumbnail extends StatelessWidget {
  final String path;
  const _ImageThumbnail({required this.path});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => _FullScreenViewer(child: Image.file(File(path)))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Image.file(File(path), fit: BoxFit.cover),
      ),
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  final String path;
  const _VideoThumbnail({required this.path});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => _FullScreenVideoPlayer(path: path)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
        ),
      ),
    );
  }
}

class _AudioPlayerWidget extends StatefulWidget {
  final String path;
  final bool isBot;
  const _AudioPlayerWidget({required this.path, required this.isBot});
  @override
  State<_AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<_AudioPlayerWidget> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isBot ? AppColors.nectarPurple : Colors.white;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          color: color,
          onPressed: () async {
            if (isPlaying) {
              await _player.pause();
            } else {
              await _player.play(DeviceFileSource(widget.path));
            }
            setState(() => isPlaying = !isPlaying);
          },
        ),
        Text("Audio Note", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// Reuse your FullScreenVideoPlayer logic here...
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

// Place _FullScreenVideoPlayer class here (same as before)
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
      setState(() {
        _cc = ChewieController(videoPlayerController: _vc, autoPlay: true, looping: false);
      });
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
      body: Center(
        child: _cc != null ? Chewie(controller: _cc!) : const CircularProgressIndicator(),
      ),
    );
  }
}