import '../../models/labour.dart';

class MockLabour {
  static List<LabourWorker> initialWorkers = [
    LabourWorker(
      id: 'w1',
      name: 'Ramesh',
      work: 'Harvesting',
      experience: '5 years',
      distance: '3 km away',
      dailyWage: 500.0,
      status: 'Available',
      phone: '+91 98765 43210',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80',
    ),
    LabourWorker(
      id: 'w2',
      name: 'Suresh Kumar',
      work: 'Planting',
      experience: '4 years',
      distance: '5 km away',
      dailyWage: 480.0,
      status: 'Available',
      phone: '+91 98765 43211',
      image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&auto=format&fit=crop&q=80',
    ),
    LabourWorker(
      id: 'w3',
      name: 'Ganesh Patil',
      work: 'Spraying',
      experience: '7 years',
      distance: '2 km away',
      dailyWage: 550.0,
      status: 'Available',
      phone: '+91 98765 43212',
      image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300&auto=format&fit=crop&q=80',
    ),
    LabourWorker(
      id: 'w4',
      name: 'Sunita Bai & Team',
      work: 'Weeding',
      experience: '8 years',
      distance: '4 km away',
      dailyWage: 450.0,
      status: 'Available',
      phone: '+91 98765 43213',
      image: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&auto=format&fit=crop&q=80',
    ),
  ];

  static List<LabourRequest> initialRequests = [
    LabourRequest(
      id: 'lr1',
      workerName: 'Ramesh',
      work: 'Harvesting',
      date: '08 Sep 2026',
      workersNeeded: 3,
      dailyWage: 500.0,
      status: 'Accepted',
      location: 'Pune',
    ),
    LabourRequest(
      id: 'lr2',
      workerName: 'Ganesh Patil',
      work: 'Spraying',
      date: '10 Sep 2026',
      workersNeeded: 1,
      dailyWage: 550.0,
      status: 'Requested',
      location: 'Pune',
    ),
    LabourRequest(
      id: 'lr3',
      workerName: 'Sunita Bai & Team',
      work: 'Weeding',
      date: '12 Sep 2026',
      workersNeeded: 4,
      dailyWage: 450.0,
      status: 'Working',
      location: 'Pune',
    ),
  ];
}
