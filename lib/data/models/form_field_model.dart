class FormFieldModel {
  final String id;
  final String type; // text, single_choice, date, time, etc.
  final String question;
  final bool required;
  final List<String>? options;
  final ValidationModel? validation;

  FormFieldModel({
    required this.id,
    required this.type,
    required this.question,
    required this.required,
    this.options,
    this.validation,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      id: json['id'],
      type: json['type'],
      question: json['question'],
      required: json['required'] ?? false,
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      validation: json['validation'] != null
          ? ValidationModel.fromJson(json['validation'])
          : null,
    );
  }
}

class ValidationModel {
  final String pattern;
  final String message;

  ValidationModel({required this.pattern, required this.message});

  factory ValidationModel.fromJson(Map<String, dynamic> json) {
    return ValidationModel(
      pattern: json['pattern'],
      message: json['message'],
    );
  }
}