class LabourWorker {
  final String id;
  final String name;
  final String work;
  final String experience;
  final String distance;
  final double dailyWage;
  final String status; // 'Available', 'Booked'
  final String phone;
  final String image;

  LabourWorker({
    required this.id,
    required this.name,
    required this.work,
    required this.experience,
    required this.distance,
    required this.dailyWage,
    required this.status,
    required this.phone,
    required this.image,
  });
}

class LabourRequest {
  final String id;
  final String workerName;
  final String work;
  final String date;
  final int workersNeeded;
  final double dailyWage;
  final String status; // 'Requested', 'Accepted', 'Working', 'Completed', 'Cancelled'
  final String location;

  LabourRequest({
    required this.id,
    required this.workerName,
    required this.work,
    required this.date,
    required this.workersNeeded,
    required this.dailyWage,
    required this.status,
    required this.location,
  });
}
