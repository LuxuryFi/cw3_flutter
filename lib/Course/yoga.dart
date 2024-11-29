class ClassDetails {
  final String userId;
  final String dayOfWeek;
  final String time;
  final int capacity;
  final int duration;
  final int price;
  final String classType;
  final String description;
  final String teacher;
  final String image;

  ClassDetails({
    required this.userId,
    required this.dayOfWeek,
    required this.time,
    required this.capacity,
    required this.duration,
    required this.price,
    required this.classType,
    required this.description,
    required this.teacher,
    required this.image,
  });

  // To convert JSON to ClassDetails object
  factory ClassDetails.fromJson(Map<String, dynamic> json) {
    return ClassDetails(
      userId: json['userId'],
      dayOfWeek: json['dayOfWeek'],
      time: json['time'],
      capacity: json['capacity'],
      duration: json['duration'],
      price: json['price'],
      classType: json['classType'],
      description: json['description'],
      teacher: json['teacher'],
      image: json['image'],
    );
  }

  // To convert ClassDetails object to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'dayOfWeek': dayOfWeek,
      'time': time,
      'capacity': capacity,
      'duration': duration,
      'price': price,
      'classType': classType,
      'description': description,
      'teacher': teacher,
      'image': image,
    };
  }
}
