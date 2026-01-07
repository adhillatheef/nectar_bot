class Ticket {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String status;
  final String location;
  final DateTime createdAt;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.location,
    required this.createdAt,
  });
}