class AppConstants {
  static const String appName = 'AgroWorld';
  static const String appTagline = 'Integrated Agri-Commerce and Farm Services Platform';
  static const String currency = '₹';

  // Farmer Module Names - Exact Simple English Strings
  static const String navHome = 'Home';
  static const String navMarket = 'Market';
  static const String navOrders = 'Orders';
  static const String navNotifications = 'Notifications';
  static const String navProfile = 'Profile';

  // Feature screen titles
  static const String titleMyCrops = 'My Crops';
  static const String titleCheckCropHealth = 'Check Crop Health';
  static const String titleSellCrop = 'Sell Crop';
  static const String titleMyCropSales = 'My Crop Sales';
  static const String titleSellFarmWaste = 'Sell Farm Waste';
  static const String titleFindLabour = 'Find Labour';
  static const String titleMyRequests = 'My Requests';
  static const String titleBuyFarmProducts = 'Buy Farm Products';
  static const String titleFarmContracts = 'Farm Contracts';
  static const String titleMyOrders = 'My Orders';
  static const String titleMarket = 'Market';
  static const String titleNotifications = 'Notifications';
  static const String titleMyProfile = 'My Profile';
  static const String titleHelp = 'Help';

  // Waste Types (Common agricultural residues)
  static const List<String> wasteTypes = [
    'Wheat Straw (गव्हाचा पेंढा)',
    'Rice Straw (तांदळाचा पेंढा)',
    'Sugarcane Trash (उसाची पाचट)',
    'Maize Stalks (मक्याचे देठ)',
    'Cotton Stalks (कापसाचे देठ)',
    'Coconut Shell/Husk Waste (नारळाचे करवंटे/कचरा)',
    'Other (इतर)',
  ];

  static const List<String> wasteUnits = [
    'ton',
    'quintal',
    'kg',
  ];

  static const List<String> wastePriceUnits = [
    '₹/ton',
    '₹/quintal',
    '₹/kg',
    'Total ₹',
  ];

  // Work Types for Labour
  static const List<String> labourWorkTypes = [
    'Harvesting',
    'Weeding',
    'Sowing',
    'Spraying',
    'Tractor/operator',
    'Farm labour',
    'Planting',
    'Other',
  ];

  // Product Categories
  static const List<String> productCategories = [
    'All',
    'Seeds',
    'Fertilizers',
    'Organic inputs',
    'Crop protection products',
    'Farming tools',
    'Irrigation items',
    'Equipment/accessories',
    'Other agricultural products',
  ];
}
