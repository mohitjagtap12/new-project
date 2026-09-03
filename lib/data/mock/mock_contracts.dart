import '../../models/contract.dart';

class MockContracts {
  static List<FarmContract> initialContracts = [
    FarmContract(
      id: 'fc1',
      company: 'ABC Foods Pvt Ltd',
      crop: 'Tomato',
      quantity: '1000 kg',
      price: 30.0,
      location: 'Pune',
      lastDate: '20 September 2026',
      quality: 'Grade A Red Ripe, Minimum 60mm diameter',
      contractPeriod: 'October 2026 - January 2027',
      companyDetails: 'ABC Foods is a leading food processing & sauce manufacturer with 15 processing units.',
      status: 'Available',
    ),
    FarmContract(
      id: 'fc2',
      company: 'Golden Harvest Flours',
      crop: 'Wheat',
      quantity: '5000 kg',
      price: 34.0,
      location: 'Pune',
      lastDate: '25 September 2026',
      quality: 'Protein > 12%, Moisture < 11%, No husk impurities',
      contractPeriod: 'November 2026 - February 2027',
      companyDetails: 'FMCG flour miller supplying premium packaged atta across Western India.',
      status: 'Under Review',
    ),
    FarmContract(
      id: 'fc3',
      company: 'Sahyadri Sugar Mills Co-op',
      crop: 'Sugarcane',
      quantity: '50 tons',
      price: 3200.0, // per ton
      location: 'Pune',
      lastDate: '30 October 2026',
      quality: 'Brix > 19, Freshly harvested within 24 hours',
      contractPeriod: 'December 2026 - March 2027',
      companyDetails: 'Government certified sugar mill with prompt direct bank settlement for cooperative farmers.',
      status: 'Available',
    ),
  ];
}
