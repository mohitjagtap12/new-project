class LabourWorker {
  final String id;
  final String name;
  final String work;
  final String experience;
  final String location;
  final String distance;
  final double dailyWage;
  final double hourlyRate;
  final String status; // 'Available', 'Booked', 'Busy'
  final double rating;
  final int reviewsCount;
  final String phone;
  final String image;
  final String about;
  final List<String> skills;
  final int completedJobs;

  LabourWorker({
    required this.id,
    required this.name,
    required this.work,
    required this.experience,
    this.location = 'Baramati, Pune',
    required this.distance,
    required this.dailyWage,
    this.hourlyRate = 70.0,
    required this.status,
    this.rating = 4.8,
    this.reviewsCount = 24,
    required this.phone,
    required this.image,
    this.about = 'Experienced agricultural worker skilled in all seasonal farming operations.',
    this.skills = const [],
    this.completedJobs = 35,
  });

  bool get isAvailable => status.toLowerCase() == 'available';
}

class LabourRequest {
  final String id;
  final String? workerId;
  final String workerName;
  final String? workerPhone;
  final String? workerImage;
  final String work;
  final String? cropDescription;
  final String date;
  final String duration;
  final int workersNeeded;
  final double dailyWage;
  final double? totalAmount;
  final String status; // 'Pending', 'Accepted', 'Rejected', 'Cancelled', 'Completed'
  final String location;
  final String? notes;
  final String? createdAt;

  LabourRequest({
    required this.id,
    this.workerId,
    required this.workerName,
    this.workerPhone,
    this.workerImage,
    required this.work,
    this.cropDescription,
    required this.date,
    this.duration = 'Full Day (8 hrs)',
    required this.workersNeeded,
    required this.dailyWage,
    this.totalAmount,
    required this.status,
    required this.location,
    this.notes,
    this.createdAt,
  });

  double get total => totalAmount ?? (dailyWage * workersNeeded);
  bool get isPending => status.toLowerCase() == 'pending' || status.toLowerCase() == 'requested';
  bool get isAccepted => status.toLowerCase() == 'accepted';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isRejected => status.toLowerCase() == 'rejected';

  LabourRequest copyWith({
    String? id,
    String? workerId,
    String? workerName,
    String? workerPhone,
    String? workerImage,
    String? work,
    String? cropDescription,
    String? date,
    String? duration,
    int? workersNeeded,
    double? dailyWage,
    double? totalAmount,
    String? status,
    String? location,
    String? notes,
    String? createdAt,
  }) {
    return LabourRequest(
      id: id ?? this.id,
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      workerPhone: workerPhone ?? this.workerPhone,
      workerImage: workerImage ?? this.workerImage,
      work: work ?? this.work,
      cropDescription: cropDescription ?? this.cropDescription,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      workersNeeded: workersNeeded ?? this.workersNeeded,
      dailyWage: dailyWage ?? this.dailyWage,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
