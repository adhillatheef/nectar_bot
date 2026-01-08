class Ticket {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;
  final String location;
  final DateTime createdAt;
  final String reportedBy;
  final String? assetId;
  final String? contactNumber;
  final String? email;
  final String? preferredDate;
  final String? preferredTime;
  final String? accessRequired;
  final String? sla;
  final List<String> attachments;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.location,
    required this.createdAt,
    required this.reportedBy,
    this.assetId,
    this.contactNumber,
    this.email,
    this.preferredDate,
    this.preferredTime,
    this.accessRequired,
    this.sla,
    this.attachments = const [],
  });
}