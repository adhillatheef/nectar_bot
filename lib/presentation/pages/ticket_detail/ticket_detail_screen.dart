import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/theme/app_colors.dart';
import '../../controllers/ticket_detail/ticket_detail_controller.dart';

class TicketDetailScreen extends StatelessWidget {
  final TicketDetailController controller = Get.put(TicketDetailController());

  TicketDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Ticket Details"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: controller.deleteTicket,
          )
        ],
      ),
      body: Obx(() {
        final t = controller.ticket.value;
        if (t == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. HEADER CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusBadge(t.status),
                      Text(DateFormat('MMM dd, yyyy').format(t.createdAt), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(t.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("ID: #${t.id.substring(0, 8).toUpperCase()}", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. DESCRIPTION
            _buildSectionHeader("Description"),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Text(t.description, style: const TextStyle(fontSize: 15, height: 1.5)),
            ),

            const SizedBox(height: 20),

            // 3. KEY DETAILS GRID
            _buildSectionHeader("Key Details"),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildInfoCard(Icons.category, "Category", t.category),
                _buildInfoCard(Icons.flag, "Priority", t.priority, isHigh: t.priority == 'High'),
                _buildInfoCard(Icons.timer, "SLA", t.sla ?? "Standard"),
                _buildInfoCard(Icons.lock_open, "Access Required", t.accessRequired ?? "No"),
                _buildInfoCard(Icons.location_on, "Location", t.location),
                _buildInfoCard(Icons.qr_code, "Asset ID", t.assetId ?? "N/A"),
              ],
            ),

            const SizedBox(height: 20),

            // 4. SCHEDULE & CONTACT
            _buildSectionHeader("Schedule & Contact"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildRowItem("Preferred Date", t.preferredDate ?? "N/A"),
                  const Divider(),
                  _buildRowItem("Preferred Time", t.preferredTime ?? "N/A"),
                  const Divider(),
                  _buildRowItem("Reported By", t.reportedBy),
                  const Divider(),
                  _buildRowItem("Contact", t.contactNumber ?? "N/A"),
                  const Divider(),
                  _buildRowItem("Email", t.email ?? "N/A"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 5. ATTACHMENTS GALLERY
            _buildSectionHeader("Attachments"),
            Obx(() {
              if (controller.attachments.isEmpty) {
                return const Text("No attachments found", style: TextStyle(color: Colors.grey));
              }
              return SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.attachments.length,
                  itemBuilder: (context, index) {
                    final path = controller.attachments[index];
                    return _buildAttachmentThumbnail(path);
                  },
                ),
              );
            }),

            const SizedBox(height: 30),

            // 6. ACTION BUTTONS
            Row(
              children: [
                _buildStatusButton("Open", t.status == "Open", Colors.blue),
                const SizedBox(width: 10),
                _buildStatusButton("In Progress", t.status == "In Progress", Colors.orange),
                const SizedBox(width: 10),
                _buildStatusButton("Closed", t.status == "Closed", Colors.grey),
              ],
            ),
            const SizedBox(height: 40),
          ],
        );
      }),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, {bool isHigh = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: (isHigh ? Colors.red : AppColors.primaryPurple).withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: isHigh ? Colors.red : AppColors.primaryPurple, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.blue;
    if (status == 'In Progress') color = Colors.orange;
    if (status == 'Closed') color = Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildStatusButton(String status, bool isActive, Color color) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => controller.updateStatus(status),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? color : Colors.white,
          foregroundColor: isActive ? Colors.white : Colors.black87,
          elevation: isActive ? 2 : 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: isActive ? BorderSide.none : BorderSide(color: Colors.grey[300]!),
        ),
        child: Text(status, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  // --- ATTACHMENT DISPLAY LOGIC ---

  Widget _buildAttachmentThumbnail(String path) {
    // Determine type
    bool isVideo = path.toLowerCase().endsWith('.mp4') || path.toLowerCase().endsWith('.mov');
    bool isAudio = path.toLowerCase().endsWith('.m4a');
    bool isImage = !isVideo && !isAudio;

    return GestureDetector(
      onTap: () {
        if (isImage) _showFullScreenImage(path);
        if (isVideo) Get.to(() => _FullScreenVideoPlayer(path: path));
        if (isAudio) _showAudioPlayerDialog(path);
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
          image: isImage ? DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover) : null,
        ),
        child: isImage ? null : Center(
          child: Icon(
            isAudio ? Icons.mic : Icons.play_circle_fill,
            color: isAudio ? AppColors.primaryPurple : Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(String path) {
    Get.to(() => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(child: InteractiveViewer(child: Image.file(File(path)))),
    ));
  }

  void _showAudioPlayerDialog(String path) {
    Get.dialog(
      Dialog(
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
      ),
    );
  }
}

// --- HELPER CLASSES FOR DETAIL VIEW ---

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
      icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: AppColors.primaryPurple),
      onPressed: () async {
        if (isPlaying) {
          await _player.pause();
        } else {
          await _player.play(DeviceFileSource(widget.path));
        }
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