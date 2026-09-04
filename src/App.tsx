import React, { useState } from 'react';
import {
  Sprout,
  ShoppingCart,
  Users,
  Store,
  Bell,
  User,
  Plus,
  Trash2,
  Edit,
  ArrowLeft,
  Calendar,
  Layers,
  Search,
  CheckCircle2,
  AlertTriangle,
  FileText,
  Phone,
  HelpCircle,
  TrendingUp,
  Package,
  Clock,
  ShieldCheck,
  ChevronRight,
  Maximize2,
  Smartphone,
  Monitor,
  Code2,
  DollarSign,
  MapPin,
  Camera,
  HeartPulse,
  Truck,
  Eye,
  EyeOff,
  LogOut,
  Lock,
  UserPlus
} from 'lucide-react';

// Initial Mock Crops
const initialCrops = [
  {
    id: 'c1',
    name: 'Tomato',
    variety: 'Abhinav F1 Hybrid',
    area: '2 Acres',
    unit: 'Acres',
    location: 'Baramati, Pune',
    plantingDate: '10 June 2026',
    expectedHarvest: '15 September 2026',
    status: 'Growing',
    image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    notes: 'Planted with drip irrigation. Applied organic vermicompost.',
  },
  {
    id: 'c2',
    name: 'Wheat',
    variety: 'Sharbati HD-2967',
    area: '3.5 Acres',
    unit: 'Acres',
    location: 'Shirur, Pune',
    plantingDate: '15 November 2025',
    expectedHarvest: '20 March 2026',
    status: 'Ready for Harvest',
    image: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
    notes: 'Grain filling complete. Combine harvester scheduled.',
  },
  {
    id: 'c3',
    name: 'Onion',
    variety: 'Nasik Red (Fursungi)',
    area: '1.5 Acres',
    unit: 'Acres',
    location: 'Dindori, Nashik',
    plantingDate: '01 July 2026',
    expectedHarvest: '25 October 2026',
    status: 'Growing',
    image: 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=600&auto=format&fit=crop&q=80',
    notes: 'Raised beds with mulching sheet. Good canopy growth.',
  },
  {
    id: 'c4',
    name: 'Sugarcane',
    variety: 'Co-86032 (Nira)',
    area: '4 Acres',
    unit: 'Acres',
    location: 'Phaltan, Satara',
    plantingDate: '05 January 2026',
    expectedHarvest: '10 December 2026',
    status: 'Growing',
    image: 'https://images.unsplash.com/photo-1543083477-4f785aeafaa9?w=600&auto=format&fit=crop&q=80',
    notes: 'Inter-cultivation complete. Fertigation weekly.',
  },
];

const initialCropSales = [
  {
    id: 'cs1',
    cropId: 'c1',
    cropName: 'Tomato',
    variety: 'Abhinav F1 Hybrid',
    quantity: '500',
    unit: 'kg',
    price: 25,
    priceUnit: '₹/kg',
    availableDate: '15 Sep 2026',
    location: 'Baramati, Pune',
    status: 'Active',
    image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    description: 'Fresh farm-harvested red ripe tomatoes. High shelf life and grade-A quality.',
    postedDate: '01 Sep 2026',
  },
  {
    id: 'cs2',
    cropId: 'c2',
    cropName: 'Wheat',
    variety: 'Sharbati HD-2967',
    quantity: '1200',
    unit: 'kg',
    price: 32,
    priceUnit: '₹/kg',
    availableDate: '20 Mar 2026',
    location: 'Shirur, Pune',
    status: 'Sold',
    image: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
    description: 'Cleaned grade-A Sharbati wheat grains, ready for direct milling.',
    postedDate: '25 Aug 2026',
  },
  {
    id: 'cs3',
    cropId: null,
    cropName: 'Maize',
    variety: 'African Tall',
    quantity: '800',
    unit: 'kg',
    price: 22,
    priceUnit: '₹/kg',
    availableDate: '10 Oct 2026',
    location: 'Baramati, Pune',
    status: 'Active',
    image: 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=600&auto=format&fit=crop&q=80',
    description: 'Yellow feed maize dried to 12% moisture. Stored in dry aerated bags.',
    postedDate: '03 Sep 2026',
  },
];

const initialWorkers = [
  {
    id: 'w1',
    name: 'Ramesh Shinde',
    work: 'Harvesting',
    skills: ['Harvesting', 'Crop Cutting', 'Grading', 'Field Clearing'],
    experience: '6 years',
    location: 'Baramati, Pune',
    distance: '3 km away',
    dailyWage: 500,
    hourlyRate: 70,
    status: 'Available',
    rating: 4.9,
    reviewsCount: 34,
    phone: '+91 98765 43210',
    image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80',
    about: 'Experienced in paddy, soybean, onion, and vegetable harvesting. Leads a hardworking 5-person crew.',
    completedJobs: 48,
  },
  {
    id: 'w2',
    name: 'Suresh Patil',
    work: 'Sowing',
    skills: ['Sowing', 'Seedbed Prep', 'Transplantation', 'Nursery Care'],
    experience: '5 years',
    location: 'Shirur, Pune',
    distance: '5 km away',
    dailyWage: 480,
    hourlyRate: 65,
    status: 'Available',
    rating: 4.7,
    reviewsCount: 22,
    phone: '+91 98765 43211',
    image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&auto=format&fit=crop&q=80',
    about: 'Specialist in precision seed sowing, furrow spacing, and seedling transplantation for onions and tomatoes.',
    completedJobs: 36,
  },
  {
    id: 'w3',
    name: 'Ganesh Patil',
    work: 'Spraying',
    skills: ['Pesticide Spraying', 'Fertilizer Drenching', 'Fungicide Care'],
    experience: '7 years',
    location: 'Daund, Pune',
    distance: '2 km away',
    dailyWage: 550,
    hourlyRate: 80,
    status: 'Available',
    rating: 4.8,
    reviewsCount: 41,
    phone: '+91 98765 43212',
    image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300&auto=format&fit=crop&q=80',
    about: 'Equipped with modern battery-powered sprayers. Certified in safe pesticide handling and uniform foliar application.',
    completedJobs: 54,
  },
  {
    id: 'w4',
    name: 'Sunita Bai & Team',
    work: 'Weeding',
    skills: ['Manual Weeding', 'Interculture', 'Root Soil Care', 'Mulching'],
    experience: '8 years',
    location: 'Indapur, Pune',
    distance: '4 km away',
    dailyWage: 450,
    hourlyRate: 60,
    status: 'Available',
    rating: 4.9,
    reviewsCount: 52,
    phone: '+91 98765 43213',
    image: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&auto=format&fit=crop&q=80',
    about: 'Dedicated group of experienced farm women specializing in meticulous weed removal without damaging delicate crop roots.',
    completedJobs: 65,
  },
  {
    id: 'w5',
    name: 'Vitthal Jadhav',
    work: 'Tractor/operator',
    skills: ['Tractor Driving', 'Deep Plowing', 'Rotavator', 'Land Leveling'],
    experience: '10 years',
    location: 'Baramati, Pune',
    distance: '6 km away',
    dailyWage: 800,
    hourlyRate: 120,
    status: 'Available',
    rating: 4.9,
    reviewsCount: 60,
    phone: '+91 98765 43214',
    image: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300&auto=format&fit=crop&q=80',
    about: 'Licensed heavy machinery & tractor driver with 10 years experience operating 45-55 HP tractors with rotavator and cultivators.',
    completedJobs: 82,
  },
  {
    id: 'w6',
    name: 'Balasaheb More',
    work: 'Farm labour',
    skills: ['General Farm Work', 'Canal Irrigation', 'Drip Maintenance', 'Loading'],
    experience: '4 years',
    location: 'Shirur, Pune',
    distance: '7 km away',
    dailyWage: 450,
    hourlyRate: 60,
    status: 'Booked',
    rating: 4.6,
    reviewsCount: 19,
    phone: '+91 98765 43215',
    image: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=300&auto=format&fit=crop&q=80',
    about: 'Reliable all-round farm helper. Skilled in ridge preparation, channel cleaning, drip line flush, and loading produce.',
    completedJobs: 29,
  },
];

const initialLabourRequests = [
  {
    id: 'lr1',
    workerId: 'w1',
    workerName: 'Ramesh Shinde',
    workerPhone: '+91 98765 43210',
    workerImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80',
    work: 'Harvesting',
    cropDescription: 'Tomato harvest in 2-acre field, sorting into crates',
    date: '08 Sep 2026',
    duration: 'Full Day (8 hrs)',
    workersNeeded: 3,
    dailyWage: 500,
    totalAmount: 1500,
    status: 'Accepted',
    location: 'Baramati, Pune',
    notes: 'Need to start early at 6:30 AM to beat midday heat. Crates will be provided.',
    createdAt: '03 Sep 2026',
  },
  {
    id: 'lr2',
    workerId: 'w3',
    workerName: 'Ganesh Patil',
    workerPhone: '+91 98765 43212',
    workerImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300&auto=format&fit=crop&q=80',
    work: 'Spraying',
    cropDescription: 'Foliar nutrition & preventive spray on pomegranate orchard',
    date: '10 Sep 2026',
    duration: 'Half Day (4 hrs)',
    workersNeeded: 1,
    dailyWage: 550,
    totalAmount: 550,
    status: 'Pending',
    location: 'Baramati, Pune',
    notes: 'Chemicals and clean water drums are ready at the farm borehole.',
    createdAt: '04 Sep 2026',
  },
  {
    id: 'lr3',
    workerId: 'w4',
    workerName: 'Sunita Bai & Team',
    workerPhone: '+91 98765 43213',
    workerImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&auto=format&fit=crop&q=80',
    work: 'Weeding',
    cropDescription: 'Manual weeding of onion beds before second watering',
    date: '12 Sep 2026',
    duration: 'Full Day (8 hrs)',
    workersNeeded: 4,
    dailyWage: 450,
    totalAmount: 1800,
    status: 'Completed',
    location: 'Indapur, Pune',
    notes: 'Completed successfully with excellent weed clearance.',
    createdAt: '28 Aug 2026',
  },
  {
    id: 'lr4',
    workerId: 'w5',
    workerName: 'Vitthal Jadhav',
    workerPhone: '+91 98765 43214',
    workerImage: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300&auto=format&fit=crop&q=80',
    work: 'Tractor/operator',
    cropDescription: 'Deep tilling and rotavator pulverizing for wheat seedbed',
    date: '15 Sep 2026',
    duration: 'Full Day (8 hrs)',
    workersNeeded: 1,
    dailyWage: 800,
    totalAmount: 800,
    status: 'Pending',
    location: 'Indapur, Pune',
    notes: '3-acre plot. Farm diesel and lubricants provided on site.',
    createdAt: '04 Sep 2026',
  },
];

const initialProducts = [
  {
    id: 'p1',
    name: 'Tomato Seeds F1 Hybrid (Abhinav)',
    category: 'Seeds',
    price: 450,
    priceUnit: 'packet (10g)',
    availableQuantity: 50,
    quantityUnit: 'packets',
    sellerName: 'Kisan Beej Bhandar',
    sellerLocation: 'Pune',
    description:
      'High disease resistance hybrid tomato seeds with deep red firm fruits. Suitable for long transport and heavy yield up to 35-40 tons per acre.',
    image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.8,
    reviewsCount: 38,
    specifications: {
      'Brand': 'Syngenta / Abhinav',
      'Germination': '85% Minimum',
      'Physical Purity': '98%',
      'Genetic Purity': '95%',
      'Maturity': '65-70 days after transplanting',
      'Suitable Season': 'Kharif, Rabi & Summer',
    },
    features: [
      'Resistant to Tomato Leaf Curl Virus (ToLCV)',
      'Firm and attractive deep red fruits',
      'Excellent shelf life for long-distance transport',
      'High harvest yield potential',
    ],
  },
  {
    id: 'p2',
    name: 'Wheat Certified Seeds (HD-2967)',
    category: 'Seeds',
    price: 980,
    priceUnit: '40 kg bag',
    availableQuantity: 120,
    quantityUnit: 'bags',
    sellerName: 'Maharashtra Krishi Kendra',
    sellerLocation: 'Baramati',
    description:
      'State certified high-tillering wheat seed. Demonstrates superior resistance to yellow rust and drought stress with bold lustrous grains.',
    image: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.7,
    reviewsCount: 52,
    specifications: {
      'Seed Class': 'Certified Class I',
      'Bag Weight': '40 kg',
      'Germination Rate': '88%',
      'Average Yield': '22-25 quintals/acre',
      'Recommended Sowing': 'Nov 1 - Nov 25',
    },
    features: [
      'Drought tolerant and heat resistant',
      'Profuse tillering capacity',
      'Lustrous and high-protein amber grain',
    ],
  },
  {
    id: 'p3',
    name: 'Onion Seeds (Fursungi Gavran Selection)',
    category: 'Seeds',
    price: 1250,
    priceUnit: '500g tin',
    availableQuantity: 35,
    quantityUnit: 'tins',
    sellerName: 'Swastik Agro Agency',
    sellerLocation: 'Pune',
    description:
      'Premier Maharashtra Fursungi onion seed producing uniform globe-shaped light red bulbs. Renowned for outstanding storage ability exceeding 6 months.',
    image: 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=600&auto=format&fit=crop&q=80',
    status: 'Limited Stock',
    rating: 4.9,
    reviewsCount: 29,
    specifications: {
      'Variety': 'Fursungi Gavran',
      'Bulb Shape': 'Medium Round Globe',
      'Bulb Color': 'Light Red / Pink',
      'Storage Life': '6+ Months',
      'Harvest Window': '110-120 days from transplant',
    },
    features: [
      'Extremely low bolting tendency',
      'High pungency and solid dry matter',
      'Excellent keeping quality under ambient farm sheds',
    ],
  },
  {
    id: 'p4',
    name: 'NPK 19:19:19 100% Water Soluble Fertilizer',
    category: 'Fertilizers',
    price: 1450,
    priceUnit: '25 kg bag',
    availableQuantity: 65,
    quantityUnit: 'bags',
    sellerName: 'Green Earth Bio Agro',
    sellerLocation: 'Pune',
    description:
      'Fully water-soluble balanced NPK fertilizer with micronutrients. Ideal for fertigation via drip systems and foliar spray during vegetative growth.',
    image: 'https://images.unsplash.com/photo-1628352081506-83c43123ed6d?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.8,
    reviewsCount: 44,
    specifications: {
      'Nitrogen (N)': '19%',
      'Phosphorus (P2O5)': '19%',
      'Potassium (K2O)': '19%',
      'Solubility': '100% Water Soluble',
      'Application Mode': 'Drip fertigation & Foliar spray',
    },
    features: [
      'Instant plant uptake and root absorption',
      'Promotes lush vegetative growth and branching',
      'Compatible with most agro-chemicals',
    ],
  },
  {
    id: 'p5',
    name: 'Urea (Neem Coated 46% N)',
    category: 'Fertilizers',
    price: 267,
    priceUnit: '45 kg bag',
    availableQuantity: 150,
    quantityUnit: 'bags',
    sellerName: 'Sahyadri Kisan Seva',
    sellerLocation: 'Baramati',
    description:
      'Government authorized neem-coated urea fertilizer. Slow release nitrogen formulation prevents leaching and ensures maximum nutrient efficiency.',
    image: 'https://images.unsplash.com/photo-1585314062340-f1a5a7c9328d?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.6,
    reviewsCount: 88,
    specifications: {
      'Nitrogen Content': '46% Minimum',
      'Moisture': '1% Maximum',
      'Packaging': '45 kg standard bag',
      'Type': 'Neem oil coated granules',
    },
    features: [
      'Slow nitrogen release mechanism',
      'Inhibits soil pest activity due to neem coat',
      'Cost effective basal and top-dress fertilizer',
    ],
  },
  {
    id: 'p6',
    name: 'Pure Vermicompost (गांडूळ खत)',
    category: 'Organic inputs',
    price: 420,
    priceUnit: '50 kg bag',
    availableQuantity: 90,
    quantityUnit: 'bags',
    sellerName: 'Nisarga Organic Farms',
    sellerLocation: 'Baramati',
    description:
      '100% organic earthworm manure enriched with beneficial micro-organisms, humic acid, and organic carbon. Revitalizes degraded farm soils.',
    image: 'https://images.unsplash.com/photo-1592417817098-8f3d691026c0?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.9,
    reviewsCount: 61,
    specifications: {
      'Organic Carbon': '16-18%',
      'Moisture Content': '20-25%',
      'Earthworm Species': 'Eisenia Fetida',
      'Odor': 'Earthy forest scent',
      'Form': 'Fine granular dark compost',
    },
    features: [
      'Improves soil water-holding capacity',
      'Enhances root aeration and microbial population',
      '100% chemical and pathogen free',
    ],
  },
  {
    id: 'p7',
    name: 'Panchagavya Organic Bio-Stimulant',
    category: 'Organic inputs',
    price: 550,
    priceUnit: '5 Litre can',
    availableQuantity: 30,
    quantityUnit: 'cans',
    sellerName: 'Desi Cow Krishi Trust',
    sellerLocation: 'Pune',
    description:
      'Traditional fermented preparation from indigenous Gir cow dung, urine, milk, curd, and ghee. Acts as a natural growth promoter and tonic.',
    image: 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.8,
    reviewsCount: 22,
    specifications: {
      'Source': 'Indigenous Gir Cow',
      'Volume': '5 Litres',
      'Dosage': '30-40 ml per 15L water spray',
      'Shelf Life': '6 Months',
    },
    features: [
      'Triggers prolific flowering and fruit setting',
      'Strengthens natural crop immunity against pests',
      'Certified organic agricultural input',
    ],
  },
  {
    id: 'p8',
    name: 'Neem Oil Pest Repellent (10,000 PPM 1L)',
    category: 'Crop protection products',
    price: 380,
    priceUnit: '1 Litre bottle',
    availableQuantity: 100,
    quantityUnit: 'bottles',
    sellerName: 'Krishi Vikas Kendra',
    sellerLocation: 'Pune',
    description:
      'Pure cold-pressed neem seed oil with high 10,000 ppm Azadirachtin. Effectively deters chewing insects, caterpillars, aphids, and whiteflies.',
    image: 'https://images.unsplash.com/photo-1607613009820-a29f7bb81c04?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.7,
    reviewsCount: 47,
    specifications: {
      'Azadirachtin Active': '10,000 PPM (1% EC)',
      'Extraction': 'Cold Pressed Kernel Extraction',
      'Pack Size': '1 Litre',
      'Target': 'Aphids, Jassids, Thrips, Whiteflies',
    },
    features: [
      'Zero residue on food crops',
      'Safe for pollinators and earthworms',
      'Multi-stage repellent, antifeedant, and oviposition deterrent',
    ],
  },
  {
    id: 'p9',
    name: 'Broad Spectrum Fungicide (Mancozeb 75% WP)',
    category: 'Crop protection products',
    price: 480,
    priceUnit: '1 kg packet',
    availableQuantity: 55,
    quantityUnit: 'packets',
    sellerName: 'Kisan Beej Bhandar',
    sellerLocation: 'Pune',
    description:
      'Contact protective fungicide that provides reliable defence against downy mildew, blight, blast, and leaf spots across fruits and vegetables.',
    image: 'https://images.unsplash.com/photo-1530595467537-0b5996c41f2d?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.6,
    reviewsCount: 33,
    specifications: {
      'Active Ingredient': 'Mancozeb 75% WP',
      'Class': 'Dithiocarbamate',
      'Dose': '2-2.5 g per litre water',
      'Weight': '1 kg',
    },
    features: [
      'Multi-site action prevents fungal resistance',
      'Provides supplementary zinc and manganese nutrition',
      'Fast rain-fast adherence to foliage',
    ],
  },
  {
    id: 'p10',
    name: 'Battery Knapsack Sprayer (16L Dual Motor)',
    category: 'Farming tools',
    price: 2400,
    priceUnit: '1 unit',
    availableQuantity: 25,
    quantityUnit: 'units',
    sellerName: 'Maharashtra Agro Tools',
    sellerLocation: 'Pune',
    description:
      'High capacity 16-litre rechargeable knapsack sprayer. Features heavy-duty dual 12V motors, pressure regulator, and 4 multi-spray brass nozzles.',
    image: 'https://images.unsplash.com/photo-1589923188900-85dae523342b?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.8,
    reviewsCount: 65,
    specifications: {
      'Tank Capacity': '16 Litres',
      'Battery': '12V 8Ah Rechargeable Lead-Acid',
      'Working Pressure': '0.2 - 0.45 MPa',
      'Spraying Duration': '5-6 hours per charge',
      'Included Accessories': 'Telescopic lance, 4 nozzles, charger',
    },
    features: [
      'Dual motor design delivers strong mist spray',
      'Padded ergonomic shoulder straps for comfort',
      'Voltmeter battery level indicator on body',
    ],
  },
  {
    id: 'p11',
    name: 'Heavy Duty Hand Weeder & Hoe Tool',
    category: 'Farming tools',
    price: 350,
    priceUnit: '1 unit',
    availableQuantity: 70,
    quantityUnit: 'units',
    sellerName: 'Patil Iron Works',
    sellerLocation: 'Baramati',
    description:
      'Forged carbon steel hand weeder with ergonomic rubberized wooden handle. Ideal for inter-row weeding and loosening soil crust.',
    image: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.5,
    reviewsCount: 30,
    specifications: {
      'Material': 'High Carbon Forged Steel',
      'Handle': 'Hardwood with anti-slip grip',
      'Blade Width': '75 mm',
      'Total Length': '380 mm',
    },
    features: [
      'Sharp beveled cutting edge roots out stubborn weeds',
      'Rust-resistant black powder coating',
      'Lightweight yet indestructible design',
    ],
  },
  {
    id: 'p12',
    name: 'Drip Irrigation Lateral Pipe (16mm 400m)',
    category: 'Irrigation items',
    price: 1850,
    priceUnit: '400m bundle',
    availableQuantity: 40,
    quantityUnit: 'bundles',
    sellerName: 'Jal Shakti Irrigation',
    sellerLocation: 'Pune',
    description:
      'Premium virgin polymer UV-stabilized 16mm drip lateral pipe. Designed for high pressure and withstands harsh Indian summer sun without cracking.',
    image: 'https://images.unsplash.com/photo-1563514227147-6d2ff665a6a0?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.9,
    reviewsCount: 41,
    specifications: {
      'Outer Diameter': '16 mm (Class 2)',
      'Bundle Length': '400 meters',
      'Pressure Rating': '2.5 kg/cm²',
      'Material': 'Virgin LLDPE with Carbon Black UV Stabilizer',
    },
    features: [
      'Resistant to fertilizers and acid cleaning',
      'Smooth interior prevents mineral scaling',
      'BIS standard certified tubing',
    ],
  },
  {
    id: 'p13',
    name: 'Rain Gun Sprinkler 1.5 Inch (30m Radius)',
    category: 'Irrigation items',
    price: 2100,
    priceUnit: '1 unit',
    availableQuantity: 14,
    quantityUnit: 'units',
    sellerName: 'Jal Shakti Irrigation',
    sellerLocation: 'Pune',
    description:
      'High throw 1.5-inch agricultural impact sprinkler gun. Covers up to 30 meters radius with uniform droplet distribution for sugarcane, maize, and fodder.',
    image: 'https://images.unsplash.com/photo-1515150144380-bca9f1650ed9?w=600&auto=format&fit=crop&q=80',
    status: 'Limited Stock',
    rating: 4.7,
    reviewsCount: 19,
    specifications: {
      'Inlet Connection': '1.5 inch BSP Female Thread',
      'Nozzle Sizes': '10mm, 12mm, 14mm interchange',
      'Trajectory Angle': '23°',
      'Operating Pressure': '2.0 - 5.0 bar',
    },
    features: [
      'Adjustable part-circle or 360° full circle coverage',
      'Durable aluminum die-cast body with brass bushings',
      'Saves up to 50% water compared to flood irrigation',
    ],
  },
  {
    id: 'p14',
    name: 'Heavy Duty Agro Tarpaulin Sheet (24x18 ft)',
    category: 'Equipment/accessories',
    price: 1650,
    priceUnit: '1 sheet',
    availableQuantity: 35,
    quantityUnit: 'sheets',
    sellerName: 'Swastik Agro Agency',
    sellerLocation: 'Baramati',
    description:
      'Multi-layered 100% waterproof HDPE tarpaulin sheet with ultrasonic sealed reinforced eyelets. Essential for grain drying and protecting crops from rain.',
    image: 'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.7,
    reviewsCount: 36,
    specifications: {
      'Dimensions': '24 ft x 18 ft',
      'Material Density': '200 GSM Heavy Duty',
      'Color': 'Blue / Silver UV reflective',
      'Eyelet Spacing': 'Every 3 feet along reinforced hems',
    },
    features: [
      '100% waterproof and weatherproof',
      'Puncture and tear resistant multi-layer cross weave',
      'UV stabilized against solar degradation',
    ],
  },
  {
    id: 'p15',
    name: 'Soil Moisture & pH 2-in-1 Field Tester',
    category: 'Equipment/accessories',
    price: 750,
    priceUnit: '1 unit',
    availableQuantity: 22,
    quantityUnit: 'units',
    sellerName: 'Maharashtra Krishi Kendra',
    sellerLocation: 'Pune',
    description:
      'Battery-free dual probe instantaneous soil tester. Accurately determines root moisture levels and soil pH to prevent overwatering and fertilizer lockup.',
    image: 'https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.6,
    reviewsCount: 27,
    specifications: {
      'Probe Length': '200 mm dual metallic sensor',
      'pH Range': '3.5 - 8.0 pH',
      'Moisture Scale': '1 - 10 (Dry to Wet)',
      'Power Requirement': 'Zero batteries required',
    },
    features: [
      'Instant reading in under 60 seconds',
      'Helps optimize irrigation frequency',
      'Sturdy probe suitable for hard black soil',
    ],
  },
  {
    id: 'p16',
    name: 'Silver & Black Agricultural Mulching Film',
    category: 'Other agricultural products',
    price: 1950,
    priceUnit: '400m roll (1.2m width)',
    availableQuantity: 30,
    quantityUnit: 'rolls',
    sellerName: 'Sahyadri Kisan Seva',
    sellerLocation: 'Pune',
    description:
      '25-micron UV-stabilized dual-color mulching film. Blocks weed germination, moderates root zone temperature, and conserves 40% soil moisture.',
    image: 'https://images.unsplash.com/photo-1589923188900-85dae523342b?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.8,
    reviewsCount: 31,
    specifications: {
      'Thickness': '25 Micron',
      'Width': '1.2 meters (4 feet)',
      'Roll Length': '400 meters',
      'Color': 'Silver (Upper) / Black (Soil facing)',
    },
    features: [
      'Silver side reflects sunlight to deter whiteflies and aphids',
      'Black side completely halts weed photosynthesis',
      'Reduces soil compaction and crusting',
    ],
  },
  {
    id: 'p17',
    name: 'High Capacity Cattle Fodder Silage Bag',
    category: 'Other agricultural products',
    price: 580,
    priceUnit: '1 bag (1000kg cap)',
    availableQuantity: 45,
    quantityUnit: 'bags',
    sellerName: 'Desi Cow Krishi Trust',
    sellerLocation: 'Baramati',
    description:
      'Heavy gauge airtight anaerobic fermentation bag for maize silage and green cattle fodder storage. Keeps silage fresh and nutritious for 12+ months.',
    image: 'https://images.unsplash.com/photo-1546445317-29f4545e9d53?w=600&auto=format&fit=crop&q=80',
    status: 'In Stock',
    rating: 4.7,
    reviewsCount: 18,
    specifications: {
      'Capacity': '1,000 kg (1 Ton)',
      'Thickness': '150 Micron Heavy UV Grade',
      'Size': '6 ft height x 4 ft diameter',
    },
    features: [
      '100% airtight anaerobic seal',
      'Preserves green fodder nutrients for off-season feeding',
      'Reusable for multiple seasons',
    ],
  },
];

const initialContracts = [
  {
    id: 'fc1',
    company: 'ABC Foods Pvt Ltd',
    crop: 'Tomato',
    quantity: '1000 kg',
    price: 30,
    location: 'Pune',
    lastDate: '20 September 2026',
    quality: 'Grade A Red Ripe, Minimum 60mm diameter',
    contractPeriod: 'October 2026 - January 2027',
    companyDetails: 'ABC Foods is a leading food processing & sauce manufacturer with 15 processing units.',
    status: 'Available',
  },
  {
    id: 'fc2',
    company: 'Golden Harvest Flours',
    crop: 'Wheat',
    quantity: '5000 kg',
    price: 34,
    location: 'Pune',
    lastDate: '25 September 2026',
    quality: 'Protein > 12%, Moisture < 11%, No impurities',
    contractPeriod: 'November 2026 - February 2027',
    companyDetails: 'FMCG flour miller supplying premium packaged atta across Western India.',
    status: 'Under Review',
  },
];

const initialOrders = [
  {
    orderNumber: 'ORD-BUY-8921',
    itemTitle: 'Tomato Seeds F1 Hybrid',
    category: 'Farm Product',
    quantity: '2 packets',
    price: 900,
    counterParty: 'ABC Agro Store',
    address: 'Plot 14, Gat No. 234, Baramati Road, Pune',
    date: '02 Sep 2026',
    status: 'On the Way',
    isBuying: true,
  },
  {
    orderNumber: 'ORD-SELL-1044',
    itemTitle: 'Tomato (Fresh Harvest)',
    category: 'Crop',
    quantity: '500 kg',
    price: 12500,
    counterParty: 'Reliance Fresh APMC Buyer',
    address: 'Farm Gate Pick Up, Gate No. 234, Pune',
    date: '01 Sep 2026',
    status: 'Accepted',
    isBuying: false,
  },
];

export default function App() {
  const [platform, setPlatform] = useState<'android' | 'windows'>('android');
  const [authScreen, setAuthScreen] = useState<'splash' | 'login' | 'register' | 'authenticated'>('splash');
  const [farmerUser, setFarmerUser] = useState({
    name: 'Suresh Patil',
    mobile: '9876543210',
    village: 'Haveli',
    district: 'Pune',
    state: 'Maharashtra',
    farmSize: '5 Acres',
    mainCrops: 'Tomato, Wheat, Onion',
  });
  const [currentRoute, setCurrentRoute] = useState<string>('home');
  const [crops, setCrops] = useState(initialCrops);
  const [cropSales, setCropSales] = useState(initialCropSales);
  const [cropForSale, setCropForSale] = useState<any>(null);
  const [saleToEdit, setSaleToEdit] = useState<any>(null);
  const [selectedSale, setSelectedSale] = useState<any>(null);
  const [selectedCrop, setSelectedCrop] = useState(initialCrops[0]);
  const [cropToEdit, setCropToEdit] = useState<any>(null);
  const [labourWorkers] = useState(initialWorkers);
  const [labourRequests, setLabourRequests] = useState(initialLabourRequests);
  const [products] = useState(initialProducts);
  const [selectedProduct, setSelectedProduct] = useState(initialProducts[0]);
  const [cart, setCart] = useState<{ product: any; quantity: number }[]>([
    { product: initialProducts[0], quantity: 2 },
  ]);
  const [contracts, setContracts] = useState(initialContracts);
  const [selectedContract, setSelectedContract] = useState(initialContracts[0]);
  const [orders, setOrders] = useState(initialOrders);
  const [selectedOrder, setSelectedOrder] = useState(initialOrders[0]);
  const [notifications, setNotifications] = useState([
    { id: '1', title: 'Labour Request Accepted', message: 'Ramesh accepted your request for harvesting.', time: '10 mins ago', isRead: false },
    { id: '2', title: 'New Buyer for Tomato', message: 'ABC Foods viewed your crop.', time: '2 hours ago', isRead: false },
    { id: '3', title: 'Order Shipped', message: 'Your seed order is on the way.', time: 'Yesterday', isRead: true },
  ]);
  const [toastMsg, setToastMsg] = useState<string | null>(null);
  const [healthResult, setHealthResult] = useState<any>(null);
  const [showCodeInspector, setShowCodeInspector] = useState(false);

  const showToast = (msg: string) => {
    setToastMsg(msg);
    setTimeout(() => setToastMsg(null), 2500);
  };

  const unreadNotifCount = notifications.filter((n) => !n.isRead).length;

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100 flex flex-col font-sans">
      {/* Top Engine Toolbar */}
      <header className="bg-slate-950 border-b border-slate-800 px-4 py-3 flex flex-wrap items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <div className="w-9 h-9 rounded-xl bg-emerald-600 flex items-center justify-center text-white shadow-md">
            <Sprout className="w-5 h-5" />
          </div>
          <div>
            <h1 className="text-base font-bold tracking-tight text-white flex items-center gap-2">
              AgroWorld
              <span className="text-xs px-2 py-0.5 rounded-full bg-emerald-500/20 text-emerald-400 font-semibold border border-emerald-500/30">
                Flutter Farmer Module
              </span>
            </h1>
            <p className="text-xs text-slate-400">Pure Dart & Material 3 Architecture</p>
          </div>
        </div>

        {/* Platform View Switcher */}
        <div className="flex items-center bg-slate-900 p-1 rounded-xl border border-slate-800">
          <button
            onClick={() => setPlatform('android')}
            className={`flex items-center gap-2 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all ${
              platform === 'android'
                ? 'bg-emerald-600 text-white shadow-sm'
                : 'text-slate-400 hover:text-slate-200'
            }`}
          >
            <Smartphone className="w-4 h-4" />
            Android Phone
          </button>
          <button
            onClick={() => setPlatform('windows')}
            className={`flex items-center gap-2 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all ${
              platform === 'windows'
                ? 'bg-emerald-600 text-white shadow-sm'
                : 'text-slate-400 hover:text-slate-200'
            }`}
          >
            <Monitor className="w-4 h-4" />
            Windows Desktop
          </button>
        </div>

        {/* Auth Step Switcher */}
        <div className="flex items-center bg-slate-900 p-1 rounded-xl border border-slate-800 text-xs">
          <span className="text-[11px] text-slate-400 px-2 font-medium">Auth State:</span>
          {(['splash', 'login', 'register', 'authenticated'] as const).map((step) => (
            <button
              key={step}
              onClick={() => setAuthScreen(step)}
              className={`px-2.5 py-1 rounded-lg text-xs font-semibold transition-colors capitalize ${
                authScreen === step ? 'bg-emerald-600 text-white shadow-sm' : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              {step === 'authenticated' ? 'Dashboard' : step}
            </button>
          ))}
        </div>

        {/* Action Controls */}
        <div className="flex items-center gap-2">
          <button
            onClick={() => setShowCodeInspector(!showCodeInspector)}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-xs font-semibold text-slate-200 border border-slate-700 transition-colors"
          >
            <Code2 className="w-4 h-4 text-emerald-400" />
            {showCodeInspector ? 'Hide Dart Code' : 'Flutter Source'}
          </button>
        </div>
      </header>

      {/* Main Sandbox Stage */}
      <div className="flex-1 flex overflow-hidden">
        {/* Device Canvas Frame */}
        <main className="flex-1 bg-slate-950/70 p-4 md:p-8 flex items-center justify-center overflow-auto">
          {platform === 'android' ? (
            /* Android Phone Device Frame */
            <div className="w-[380px] h-[780px] max-h-[92vh] bg-white rounded-[42px] border-[10px] border-slate-800 shadow-2xl flex flex-col overflow-hidden text-slate-800 relative">
              {/* Android Notch Bar */}
              <div className="bg-slate-900 text-white text-[11px] px-6 py-1.5 flex justify-between items-center select-none">
                <span>9:41</span>
                <div className="w-20 h-3.5 bg-slate-800 rounded-full mx-auto"></div>
                <div className="flex items-center gap-1.5">
                  <span className="text-[10px]">5G</span>
                  <div className="w-4 h-2 border border-white/80 rounded-sm p-0.5">
                    <div className="w-full h-full bg-white"></div>
                  </div>
                </div>
              </div>

              {authScreen === 'splash' ? (
                <div className="flex-1 overflow-y-auto bg-white flex flex-col">
                  <SplashView onComplete={() => setAuthScreen('login')} />
                </div>
              ) : authScreen === 'login' ? (
                <div className="flex-1 overflow-y-auto bg-slate-50 flex flex-col">
                  <LoginView
                    onLogin={() => {
                      setAuthScreen('authenticated');
                      showToast('Login successful! Welcome to AgroWorld.');
                    }}
                    onGoToRegister={() => setAuthScreen('register')}
                    showToast={showToast}
                  />
                </div>
              ) : authScreen === 'register' ? (
                <div className="flex-1 overflow-y-auto bg-slate-50 flex flex-col">
                  <RegisterView
                    onRegisterSuccess={(newUser: any) => {
                      setFarmerUser((prev) => ({ ...prev, ...newUser }));
                      setAuthScreen('login');
                      showToast('Account created successfully! Please login.');
                    }}
                    onBackToLogin={() => setAuthScreen('login')}
                    showToast={showToast}
                  />
                </div>
              ) : (
                <>
                  {/* Mobile AppBar */}
                  <div className="bg-white border-b border-slate-100 px-4 py-3 flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      {currentRoute !== 'home' && (
                        <button
                          onClick={() => setCurrentRoute('home')}
                          className="p-1 -ml-1 text-slate-700 hover:bg-slate-100 rounded-full"
                        >
                          <ArrowLeft className="w-5 h-5" />
                        </button>
                      )}
                      <span className="font-bold text-base text-emerald-800 flex items-center gap-1">
                        {currentRoute === 'home' ? (
                          <>
                            <Sprout className="w-5 h-5 text-emerald-700" /> AgroWorld
                          </>
                        ) : (
                          currentRoute.replace(/_/g, ' ').toUpperCase()
                        )}
                      </span>
                    </div>
                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => setCurrentRoute('notifications')}
                        className="p-1.5 text-slate-600 hover:bg-slate-100 rounded-full relative"
                      >
                        <Bell className="w-5 h-5" />
                        {unreadNotifCount > 0 && (
                          <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
                        )}
                      </button>
                      <button
                        onClick={() => setCurrentRoute('profile')}
                        className="w-7 h-7 rounded-full bg-emerald-100 border border-emerald-300 text-emerald-800 font-bold text-xs flex items-center justify-center"
                      >
                        {farmerUser.name.split(' ').map((n: string) => n[0]).join('').slice(0, 2) || 'SP'}
                      </button>
                    </div>
                  </div>

                  {/* Mobile Screen Body */}
                  <div className="flex-1 overflow-y-auto bg-slate-50">
                    {renderScreenContent({
                      currentRoute,
                      setCurrentRoute,
                      farmerUser,
                      setFarmerUser,
                      handleLogout: () => {
                        setAuthScreen('login');
                        showToast('Logged out successfully');
                      },
                      crops,
                      setCrops,
                      cropSales,
                      setCropSales,
                      cropForSale,
                      setCropForSale,
                      saleToEdit,
                      setSaleToEdit,
                      selectedSale,
                      setSelectedSale,
                      selectedCrop,
                      setSelectedCrop,
                      cropToEdit,
                      setCropToEdit,
                      labourWorkers,
                      labourRequests,
                      setLabourRequests,
                      products,
                      selectedProduct,
                      setSelectedProduct,
                      cart,
                      setCart,
                      contracts,
                      setContracts,
                      selectedContract,
                      setSelectedContract,
                      orders,
                      setOrders,
                      selectedOrder,
                      setSelectedOrder,
                      notifications,
                      setNotifications,
                      healthResult,
                      setHealthResult,
                      showToast,
                    })}
                  </div>

                  {/* Material 3 Mobile Navigation Bar */}
                  <nav className="bg-white border-t border-slate-200 px-3 py-2 flex justify-around items-center text-[10px] font-semibold text-slate-600 select-none">
                    <button
                      onClick={() => setCurrentRoute('home')}
                      className={`flex flex-col items-center gap-1 p-1 rounded-xl ${
                        currentRoute === 'home' ? 'text-emerald-700 font-bold' : 'hover:text-slate-900'
                      }`}
                    >
                      <div
                        className={`px-3 py-1 rounded-full ${
                          currentRoute === 'home' ? 'bg-emerald-100 text-emerald-800' : ''
                        }`}
                      >
                        <Sprout className="w-4 h-4" />
                      </div>
                      Home
                    </button>
                    <button
                      onClick={() => setCurrentRoute('market')}
                      className={`flex flex-col items-center gap-1 p-1 rounded-xl ${
                        currentRoute === 'market' ? 'text-emerald-700 font-bold' : 'hover:text-slate-900'
                      }`}
                    >
                      <div
                        className={`px-3 py-1 rounded-full ${
                          currentRoute === 'market' ? 'bg-emerald-100 text-emerald-800' : ''
                        }`}
                      >
                        <Store className="w-4 h-4" />
                      </div>
                      Market
                    </button>
                    <button
                      onClick={() => setCurrentRoute('orders')}
                      className={`flex flex-col items-center gap-1 p-1 rounded-xl ${
                        currentRoute === 'orders' ? 'text-emerald-700 font-bold' : 'hover:text-slate-900'
                      }`}
                    >
                      <div
                        className={`px-3 py-1 rounded-full ${
                          currentRoute === 'orders' ? 'bg-emerald-100 text-emerald-800' : ''
                        }`}
                      >
                        <Package className="w-4 h-4" />
                      </div>
                      Orders
                    </button>
                    <button
                      onClick={() => setCurrentRoute('profile')}
                      className={`flex flex-col items-center gap-1 p-1 rounded-xl ${
                        currentRoute === 'profile' ? 'text-emerald-700 font-bold' : 'hover:text-slate-900'
                      }`}
                    >
                      <div
                        className={`px-3 py-1 rounded-full ${
                          currentRoute === 'profile' ? 'bg-emerald-100 text-emerald-800' : ''
                        }`}
                      >
                        <User className="w-4 h-4" />
                      </div>
                      Profile
                    </button>
                  </nav>
                </>
              )}
            </div>
          ) : (
            /* Windows Desktop Device Frame */
            <div className="w-[1050px] h-[720px] max-w-[95vw] max-h-[90vh] bg-white rounded-xl shadow-2xl border border-slate-700 flex flex-col overflow-hidden text-slate-800">
              {/* Windows Window Header */}
              <div className="bg-slate-900 text-slate-300 text-xs px-4 py-2 flex items-center justify-between border-b border-slate-800 select-none">
                <div className="flex items-center gap-2 font-medium">
                  <Sprout className="w-4 h-4 text-emerald-400" />
                  <span>AgroWorld - Farmer Module (Windows Desktop App)</span>
                </div>
                <div className="flex items-center gap-3">
                  <span className="w-3 h-0.5 bg-slate-400 cursor-pointer"></span>
                  <Maximize2 className="w-3 h-3 text-slate-400 cursor-pointer" />
                  <span className="w-3.5 h-3.5 text-slate-400 flex items-center justify-center font-mono cursor-pointer hover:text-red-400">
                    ✕
                  </span>
                </div>
              </div>

              {/* Windows Desktop Content */}
              {authScreen === 'splash' ? (
                <div className="flex-1 flex items-center justify-center bg-slate-100 p-8 overflow-y-auto">
                  <div className="w-full max-w-md bg-white rounded-2xl shadow-md border border-slate-200 overflow-hidden">
                    <SplashView onComplete={() => setAuthScreen('login')} />
                  </div>
                </div>
              ) : authScreen === 'login' ? (
                <div className="flex-1 flex items-center justify-center bg-slate-100 p-8 overflow-y-auto">
                  <div className="w-full max-w-md bg-white rounded-2xl shadow-md border border-slate-200 overflow-hidden">
                    <LoginView
                      onLogin={() => {
                        setAuthScreen('authenticated');
                        showToast('Login successful! Welcome to AgroWorld.');
                      }}
                      onGoToRegister={() => setAuthScreen('register')}
                      showToast={showToast}
                    />
                  </div>
                </div>
              ) : authScreen === 'register' ? (
                <div className="flex-1 flex items-center justify-center bg-slate-100 p-8 overflow-y-auto">
                  <div className="w-full max-w-lg bg-white rounded-2xl shadow-md border border-slate-200 overflow-hidden">
                    <RegisterView
                      onRegisterSuccess={(newUser: any) => {
                        setFarmerUser((prev) => ({ ...prev, ...newUser }));
                        setAuthScreen('login');
                        showToast('Account created successfully! Please login.');
                      }}
                      onBackToLogin={() => setAuthScreen('login')}
                      showToast={showToast}
                    />
                  </div>
                </div>
              ) : (
                <div className="flex-1 flex overflow-hidden">
                  {/* Desktop Sidebar */}
                  <aside className="w-64 bg-slate-50 border-r border-slate-200 flex flex-col justify-between p-3">
                    <div className="space-y-1">
                      <div className="px-3 py-2 text-xs font-bold text-slate-400 uppercase tracking-wider">
                        Farmer Navigation
                      </div>
                      {[
                        { id: 'home', label: 'Dashboard', icon: Sprout },
                        { id: 'crops', label: 'My Crops', icon: Layers },
                        { id: 'sell_crop', label: 'Sell Crop', icon: DollarSign },
                        { id: 'farm_waste', label: 'Sell Farm Waste', icon: Trash2 },
                        { id: 'labour', label: 'Find Labour', icon: Users },
                        { id: 'products', label: 'Buy Farm Products', icon: ShoppingCart },
                        { id: 'contracts', label: 'Farm Contracts', icon: FileText },
                        { id: 'orders', label: 'My Orders', icon: Package },
                        { id: 'crop_health', label: 'Check Crop Health', icon: HeartPulse },
                        { id: 'market', label: 'Market', icon: Store },
                        { id: 'notifications', label: 'Notifications', icon: Bell, badge: unreadNotifCount },
                        { id: 'profile', label: 'My Profile', icon: User },
                        { id: 'help', label: 'Help', icon: HelpCircle },
                      ].map((nav) => {
                        const Icon = nav.icon;
                        const isActive = currentRoute === nav.id;
                        return (
                          <button
                            key={nav.id}
                            onClick={() => setCurrentRoute(nav.id)}
                            className={`w-full flex items-center justify-between px-3 py-2 rounded-lg text-xs font-semibold transition-colors ${
                              isActive
                                ? 'bg-emerald-600 text-white shadow-sm'
                                : 'text-slate-600 hover:bg-slate-200/60'
                            }`}
                          >
                            <div className="flex items-center gap-2.5">
                              <Icon className="w-4 h-4" />
                              {nav.label}
                            </div>
                            {nav.badge ? (
                              <span className="px-1.5 py-0.5 rounded-full bg-red-500 text-white text-[10px]">
                                {nav.badge}
                              </span>
                            ) : null}
                          </button>
                        );
                      })}
                    </div>

                    {/* Desktop User Footer with Logout */}
                    <div className="p-3 bg-white rounded-lg border border-slate-200 flex items-center justify-between gap-2">
                      <div className="flex items-center gap-2.5 overflow-hidden">
                        <div className="w-8 h-8 rounded-full bg-emerald-100 text-emerald-800 font-bold flex items-center justify-center text-xs flex-shrink-0">
                          {farmerUser.name.split(' ').map((n: string) => n[0]).join('').slice(0, 2) || 'SP'}
                        </div>
                        <div className="overflow-hidden">
                          <p className="text-xs font-bold text-slate-800 truncate">{farmerUser.name}</p>
                          <p className="text-[10px] text-slate-500 truncate">{farmerUser.village}, {farmerUser.district}</p>
                        </div>
                      </div>
                      <button
                        onClick={() => {
                          setAuthScreen('login');
                          showToast('Logged out successfully');
                        }}
                        title="Logout"
                        className="p-1.5 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors cursor-pointer"
                      >
                        <LogOut className="w-4 h-4" />
                      </button>
                    </div>
                  </aside>

                  {/* Desktop Screen Body */}
                  <div className="flex-1 overflow-y-auto p-6 bg-slate-100/70">
                    {renderScreenContent({
                      currentRoute,
                      setCurrentRoute,
                      farmerUser,
                      setFarmerUser,
                      handleLogout: () => {
                        setAuthScreen('login');
                        showToast('Logged out successfully');
                      },
                      crops,
                      setCrops,
                      cropSales,
                      setCropSales,
                      cropForSale,
                      setCropForSale,
                      saleToEdit,
                      setSaleToEdit,
                      selectedSale,
                      setSelectedSale,
                      selectedCrop,
                      setSelectedCrop,
                      cropToEdit,
                      setCropToEdit,
                      labourWorkers,
                      labourRequests,
                      setLabourRequests,
                      products,
                      selectedProduct,
                      setSelectedProduct,
                      cart,
                      setCart,
                      contracts,
                      setContracts,
                      selectedContract,
                      setSelectedContract,
                      orders,
                      setOrders,
                      selectedOrder,
                      setSelectedOrder,
                      notifications,
                      setNotifications,
                      healthResult,
                      setHealthResult,
                      showToast,
                    })}
                  </div>
                </div>
              )}
            </div>
          )}
        </main>

        {/* Flutter Source Code Inspector Drawer */}
        {showCodeInspector && (
          <aside className="w-96 bg-slate-950 border-l border-slate-800 flex flex-col h-full text-xs">
            <div className="p-4 border-b border-slate-800 flex justify-between items-center">
              <div className="flex items-center gap-2 text-white font-bold">
                <Code2 className="w-4 h-4 text-emerald-400" />
                <span>Flutter Architecture</span>
              </div>
              <span className="text-[10px] px-2 py-0.5 rounded bg-slate-800 text-slate-300">
                lib/ & pubspec.yaml
              </span>
            </div>
            <div className="p-4 space-y-4 overflow-y-auto flex-1 font-mono text-[11px] text-slate-300">
              <div className="space-y-1">
                <p className="text-emerald-400 font-bold">📁 lib/core/</p>
                <p className="pl-4 text-slate-400">theme/app_theme.dart (Material 3)</p>
                <p className="pl-4 text-slate-400">constants/app_constants.dart</p>
                <p className="pl-4 text-slate-400">utils/app_utils.dart</p>
              </div>
              <div className="space-y-1">
                <p className="text-emerald-400 font-bold">📁 lib/models/</p>
                <p className="pl-4 text-slate-400">crop.dart, labour.dart, product.dart</p>
                <p className="pl-4 text-slate-400">contract.dart, order.dart, notification.dart</p>
              </div>
              <div className="space-y-1">
                <p className="text-emerald-400 font-bold">📁 lib/features/auth/</p>
                <p className="pl-4 text-slate-400">splash/splash_screen.dart</p>
                <p className="pl-4 text-slate-400">login/login_screen.dart</p>
                <p className="pl-4 text-slate-400">register/register_screen.dart</p>
                <p className="pl-4 text-slate-400">services/auth_service.dart</p>
              </div>
              <div className="space-y-1">
                <p className="text-emerald-400 font-bold">📁 lib/features/farmer/</p>
                <p className="pl-4 text-slate-400">dashboard/farmer_dashboard_screen.dart</p>
                <p className="pl-4 text-slate-400">crops/my_crops_screen.dart</p>
                <p className="pl-4 text-slate-400">crops/add_crop_screen.dart</p>
                <p className="pl-4 text-slate-400">crops/crop_details_screen.dart</p>
                <p className="pl-4 text-slate-400">crop_health/check_crop_health_screen.dart</p>
                <p className="pl-4 text-slate-400">sell_crop/sell_crop_screen.dart</p>
                <p className="pl-4 text-slate-400">farm_waste/sell_farm_waste_screen.dart</p>
                <p className="pl-4 text-slate-400">labour/find_labour_screen.dart</p>
                <p className="pl-4 text-slate-400">products/buy_farm_products_screen.dart</p>
                <p className="pl-4 text-slate-400">contracts/farm_contracts_screen.dart</p>
                <p className="pl-4 text-slate-400">orders/my_orders_screen.dart</p>
                <p className="pl-4 text-slate-400">market/market_screen.dart</p>
                <p className="pl-4 text-slate-400">notifications/notifications_screen.dart</p>
                <p className="pl-4 text-slate-400">profile/my_profile_screen.dart</p>
                <p className="pl-4 text-slate-400">help/help_screen.dart</p>
              </div>
              <div className="p-3 bg-slate-900 rounded-lg border border-slate-800 text-slate-400 text-[10px] leading-relaxed">
                <p className="font-bold text-slate-200 mb-1">Target Platforms Configured:</p>
                <p>• Android (build.gradle, AndroidManifest.xml)</p>
                <p>• Windows Desktop (CMakeLists.txt, runner/main.cpp)</p>
              </div>
            </div>
          </aside>
        )}
      </div>

      {/* Floating Notification Toast */}
      {toastMsg && (
        <div className="fixed bottom-6 right-6 bg-emerald-700 text-white px-4 py-2.5 rounded-xl shadow-xl flex items-center gap-2 text-sm font-semibold z-50 animate-bounce">
          <CheckCircle2 className="w-5 h-5 text-emerald-200" />
          {toastMsg}
        </div>
      )}
    </div>
  );
}

// Router & Screen Renderer
function renderScreenContent(props: any) {
  const { currentRoute, setCurrentRoute } = props;

  switch (currentRoute) {
    case 'home':
      return <DashboardView {...props} />;
    case 'crops':
      return <MyCropsView {...props} />;
    case 'add_crop':
      return <AddCropView {...props} />;
    case 'crop_details':
      return <CropDetailsView {...props} />;
    case 'crop_health':
      return <CropHealthView {...props} />;
    case 'crop_health_result':
      return <CropHealthResultView {...props} />;
    case 'sell_crop':
      return <SellCropView {...props} />;
    case 'my_crop_sales':
      return <MyCropSalesView {...props} />;
    case 'sale_details':
      return <CropSaleDetailsView {...props} />;
    case 'farm_waste':
      return <FarmWasteView {...props} />;
    case 'labour':
      return <LabourView {...props} />;
    case 'products':
      return <ProductsView {...props} />;
    case 'product_details':
      return <ProductDetailsView {...props} />;
    case 'cart':
      return <CartView {...props} />;
    case 'checkout':
      return <CheckoutView {...props} />;
    case 'contracts':
      return <ContractsView {...props} />;
    case 'orders':
      return <OrdersView {...props} />;
    case 'market':
      return <MarketView {...props} />;
    case 'notifications':
      return <NotificationsView {...props} />;
    case 'profile':
      return <ProfileView {...props} />;
    case 'help':
      return <HelpView {...props} />;
    default:
      return <DashboardView {...props} />;
  }
}

// 1. Dashboard View
function DashboardView(props: any) {
  const { crops, orders, labourRequests, cropSales, setCurrentRoute, farmerUser, setCropForSale, setSaleToEdit } = props;
  const firstName = farmerUser?.name ? farmerUser.name.split(' ')[0] : 'Farmer';

  return (
    <div className="p-4 space-y-4">
      {/* Hello Farmer Banner */}
      <div className="bg-gradient-to-r from-emerald-800 to-emerald-700 rounded-2xl p-5 text-white shadow-md flex items-center justify-between">
        <div>
          <h2 className="text-xl font-black tracking-tight">Hello, {firstName}!</h2>
          <p className="text-xs text-emerald-100 mt-1">Manage your farm easily</p>
        </div>
        <div className="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center">
          <Sprout className="w-7 h-7 text-white" />
        </div>
      </div>

      {/* 4 Summary Cards */}
      <div className="grid grid-cols-2 gap-3">
        <div
          onClick={() => setCurrentRoute('crops')}
          className="bg-white p-3.5 rounded-xl border border-slate-200 hover:border-emerald-500 cursor-pointer transition-all shadow-sm"
        >
          <div className="w-8 h-8 rounded-lg bg-emerald-100 text-emerald-800 flex items-center justify-center mb-2">
            <Layers className="w-4 h-4" />
          </div>
          <p className="text-2xl font-black text-slate-800">{crops.length}</p>
          <p className="text-xs font-semibold text-slate-500 mt-0.5">My Crops</p>
        </div>

        <div
          onClick={() => setCurrentRoute('orders')}
          className="bg-white p-3.5 rounded-xl border border-slate-200 hover:border-emerald-500 cursor-pointer transition-all shadow-sm"
        >
          <div className="w-8 h-8 rounded-lg bg-blue-100 text-blue-800 flex items-center justify-center mb-2">
            <Package className="w-4 h-4" />
          </div>
          <p className="text-2xl font-black text-slate-800">{orders.length}</p>
          <p className="text-xs font-semibold text-slate-500 mt-0.5">My Orders</p>
        </div>

        <div
          onClick={() => setCurrentRoute('labour')}
          className="bg-white p-3.5 rounded-xl border border-slate-200 hover:border-emerald-500 cursor-pointer transition-all shadow-sm"
        >
          <div className="w-8 h-8 rounded-lg bg-amber-100 text-amber-800 flex items-center justify-center mb-2">
            <Users className="w-4 h-4" />
          </div>
          <p className="text-2xl font-black text-slate-800">{labourRequests.length}</p>
          <p className="text-xs font-semibold text-slate-500 mt-0.5">Labour Requests</p>
        </div>

        <div
          onClick={() => setCurrentRoute('my_crop_sales')}
          className="bg-white p-3.5 rounded-xl border border-slate-200 hover:border-emerald-500 cursor-pointer transition-all shadow-sm"
        >
          <div className="w-8 h-8 rounded-lg bg-purple-100 text-purple-800 flex items-center justify-center mb-2">
            <DollarSign className="w-4 h-4" />
          </div>
          <p className="text-2xl font-black text-slate-800">
            {cropSales.filter((s: any) => s.status !== 'Cancelled').length}
          </p>
          <p className="text-xs font-semibold text-slate-500 mt-0.5">Crop Sales</p>
        </div>
      </div>

      {/* Quick Actions Header */}
      <div>
        <h3 className="text-sm font-bold text-slate-800 mb-2.5">Quick Actions</h3>
        <div className="grid grid-cols-2 gap-2.5">
          <button
            onClick={() => setCurrentRoute('add_crop')}
            className="flex items-center gap-2 p-3 bg-white rounded-xl border border-slate-200 text-left hover:bg-slate-50 font-semibold text-xs text-slate-800 shadow-sm"
          >
            <div className="w-7 h-7 rounded-lg bg-emerald-100 text-emerald-800 flex items-center justify-center">
              <Plus className="w-4 h-4" />
            </div>
            + Add Crop
          </button>
          <button
            onClick={() => {
              if (props.setCropForSale) props.setCropForSale(null);
              if (props.setSaleToEdit) props.setSaleToEdit(null);
              setCurrentRoute('sell_crop');
            }}
            className="flex items-center gap-2 p-3 bg-white rounded-xl border border-slate-200 text-left hover:bg-slate-50 font-semibold text-xs text-slate-800 shadow-sm"
          >
            <div className="w-7 h-7 rounded-lg bg-amber-100 text-amber-800 flex items-center justify-center">
              <DollarSign className="w-4 h-4" />
            </div>
            Sell Crop
          </button>
          <button
            onClick={() => setCurrentRoute('labour')}
            className="flex items-center gap-2 p-3 bg-white rounded-xl border border-slate-200 text-left hover:bg-slate-50 font-semibold text-xs text-slate-800 shadow-sm"
          >
            <div className="w-7 h-7 rounded-lg bg-blue-100 text-blue-800 flex items-center justify-center">
              <Users className="w-4 h-4" />
            </div>
            Find Labour
          </button>
          <button
            onClick={() => setCurrentRoute('crop_health')}
            className="flex items-center gap-2 p-3 bg-white rounded-xl border border-slate-200 text-left hover:bg-slate-50 font-semibold text-xs text-slate-800 shadow-sm"
          >
            <div className="w-7 h-7 rounded-lg bg-teal-100 text-teal-800 flex items-center justify-center">
              <HeartPulse className="w-4 h-4" />
            </div>
            Crop Health
          </button>
          <button
            onClick={() => setCurrentRoute('farm_waste')}
            className="flex items-center gap-2 p-3 bg-white rounded-xl border border-slate-200 text-left hover:bg-slate-50 font-semibold text-xs text-slate-800 shadow-sm"
          >
            <div className="w-7 h-7 rounded-lg bg-stone-200 text-stone-800 flex items-center justify-center">
              <Trash2 className="w-4 h-4" />
            </div>
            Sell Waste
          </button>
          <button
            onClick={() => setCurrentRoute('products')}
            className="flex items-center gap-2 p-3 bg-white rounded-xl border border-slate-200 text-left hover:bg-slate-50 font-semibold text-xs text-slate-800 shadow-sm"
          >
            <div className="w-7 h-7 rounded-lg bg-blue-100 text-blue-800 flex items-center justify-center">
              <ShoppingCart className="w-4 h-4" />
            </div>
            Buy Products
          </button>
          <button
            onClick={() => setCurrentRoute('contracts')}
            className="flex items-center gap-2 p-3 bg-white rounded-xl border border-slate-200 text-left hover:bg-slate-50 font-semibold text-xs text-slate-800 shadow-sm"
          >
            <div className="w-7 h-7 rounded-lg bg-indigo-100 text-indigo-800 flex items-center justify-center">
              <FileText className="w-4 h-4" />
            </div>
            Farm Contracts
          </button>
          <button
            onClick={() => setCurrentRoute('market')}
            className="flex items-center gap-2 p-3 bg-white rounded-xl border border-slate-200 text-left hover:bg-slate-50 font-semibold text-xs text-slate-800 shadow-sm"
          >
            <div className="w-7 h-7 rounded-lg bg-amber-100 text-amber-800 flex items-center justify-center">
              <Store className="w-4 h-4" />
            </div>
            Market
          </button>
        </div>
      </div>
    </div>
  );
}

// 2. My Crops View
function MyCropsView({ crops, setCurrentRoute, setSelectedCrop, setCropToEdit }: any) {
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('All');

  const filteredCrops = crops.filter((crop: any) => {
    const matchesStatus = statusFilter === 'All' || crop.status === statusFilter;
    const q = searchTerm.toLowerCase().trim();
    const matchesSearch =
      q === '' ||
      crop.name.toLowerCase().includes(q) ||
      crop.variety.toLowerCase().includes(q) ||
      (crop.location && crop.location.toLowerCase().includes(q));
    return matchesStatus && matchesSearch;
  });

  const statuses = ['All', 'Growing', 'Ready for Harvest', 'Harvested'];

  return (
    <div className="p-4 space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-bold text-slate-800">My Crops</h2>
          <p className="text-xs text-slate-500">Track and manage your cultivated crops</p>
        </div>
        <button
          onClick={() => {
            if (setCropToEdit) setCropToEdit(null);
            setCurrentRoute('add_crop');
          }}
          className="flex items-center gap-1.5 bg-emerald-700 hover:bg-emerald-800 text-white text-xs font-bold px-3.5 py-2 rounded-lg shadow-sm transition"
        >
          <Plus className="w-4 h-4" /> Add Crop
        </button>
      </div>

      {/* Search Input */}
      <div className="relative">
        <input
          type="text"
          placeholder="Search crops by name, variety, or village..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full bg-white border border-slate-300 rounded-xl px-3.5 py-2.5 text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-500"
        />
        {searchTerm && (
          <button
            onClick={() => setSearchTerm('')}
            className="absolute right-3 top-2.5 text-xs text-slate-400 hover:text-slate-600"
          >
            ✕
          </button>
        )}
      </div>

      {/* Filter Tabs */}
      <div className="flex gap-2 overflow-x-auto pb-1 text-xs">
        {statuses.map((status) => {
          const count =
            status === 'All'
              ? crops.length
              : crops.filter((c: any) => c.status === status).length;
          const isSelected = statusFilter === status;
          return (
            <button
              key={status}
              onClick={() => setStatusFilter(status)}
              className={`px-3 py-1.5 rounded-full font-medium whitespace-nowrap transition ${
                isSelected
                  ? 'bg-emerald-700 text-white shadow-sm'
                  : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50'
              }`}
            >
              {status} ({count})
            </button>
          );
        })}
      </div>

      {/* Crop List */}
      {filteredCrops.length === 0 ? (
        <div className="bg-white rounded-xl border border-slate-200 p-8 text-center space-y-3">
          <div className="w-12 h-12 rounded-full bg-emerald-50 text-emerald-700 flex items-center justify-center mx-auto">
            <Sprout className="w-6 h-6" />
          </div>
          <div>
            <p className="font-bold text-slate-800 text-sm">No crops found</p>
            <p className="text-xs text-slate-500 mt-0.5">
              {crops.length === 0
                ? 'Get started by registering your first crop.'
                : 'Try adjusting your search or filter keywords.'}
            </p>
          </div>
          {crops.length === 0 ? (
            <button
              onClick={() => {
                if (setCropToEdit) setCropToEdit(null);
                setCurrentRoute('add_crop');
              }}
              className="inline-flex items-center gap-1.5 bg-emerald-700 text-white text-xs font-bold px-4 py-2 rounded-lg"
            >
              <Plus className="w-4 h-4" /> Add New Crop
            </button>
          ) : (
            <button
              onClick={() => {
                setSearchTerm('');
                setStatusFilter('All');
              }}
              className="text-xs font-bold text-emerald-700 underline"
            >
              Clear Search & Filter
            </button>
          )}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
          {filteredCrops.map((crop: any) => (
            <div
              key={crop.id}
              className="bg-white rounded-xl border border-slate-200 overflow-hidden shadow-sm hover:shadow transition"
            >
              <div className="flex p-3 gap-3">
                <img
                  src={crop.image}
                  alt={crop.name}
                  className="w-20 h-20 rounded-lg object-cover bg-slate-100 flex-shrink-0"
                />
                <div className="flex-1 min-w-0">
                  <div className="flex justify-between items-start">
                    <h3 className="font-bold text-slate-900 text-sm truncate">{crop.name}</h3>
                    <span
                      className={`text-[10px] font-bold px-2 py-0.5 rounded-full flex-shrink-0 ${
                        crop.status === 'Ready for Harvest'
                          ? 'bg-amber-100 text-amber-800'
                          : crop.status === 'Harvested'
                          ? 'bg-blue-100 text-blue-800'
                          : 'bg-emerald-100 text-emerald-800'
                      }`}
                    >
                      {crop.status}
                    </span>
                  </div>
                  <p className="text-xs text-slate-500 truncate">{crop.variety}</p>
                  <div className="mt-2 text-xs text-slate-600 flex flex-wrap gap-x-3 gap-y-1">
                    <span>
                      Area: <b>{crop.area}</b>
                    </span>
                    <span>
                      Harvest: <b>{crop.expectedHarvest}</b>
                    </span>
                  </div>
                </div>
              </div>
              <div className="bg-slate-50 px-3 py-2 border-t border-slate-100 flex justify-end gap-2">
                <button
                  onClick={() => {
                    if (setCropToEdit) setCropToEdit(crop);
                    setCurrentRoute('add_crop');
                  }}
                  className="text-xs font-semibold text-slate-700 px-3 py-1 bg-white border border-slate-200 rounded-md hover:bg-slate-50"
                >
                  Edit
                </button>
                <button
                  onClick={() => {
                    setSelectedCrop(crop);
                    setCurrentRoute('crop_details');
                  }}
                  className="text-xs font-bold text-emerald-700 px-3 py-1 bg-white border border-emerald-300 rounded-md hover:bg-emerald-50"
                >
                  View Details
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

// 3. Add & Edit Crop View
function AddCropView({ setCrops, setCurrentRoute, showToast, cropToEdit, setCropToEdit, setSelectedCrop }: any) {
  const isEditing = !!cropToEdit;
  const [name, setName] = useState(cropToEdit?.name || '');
  const [variety, setVariety] = useState(cropToEdit?.variety || '');
  const [areaNumber, setAreaNumber] = useState(
    cropToEdit?.area ? cropToEdit.area.split(' ')[0] : ''
  );
  const [unit, setUnit] = useState(cropToEdit?.unit || 'Acres');
  const [location, setLocation] = useState(cropToEdit?.location || 'Baramati, Pune');
  const [plantingDate, setPlantingDate] = useState(cropToEdit?.plantingDate || '10 June 2026');
  const [expectedHarvest, setExpectedHarvest] = useState(
    cropToEdit?.expectedHarvest || '15 September 2026'
  );
  const [status, setStatus] = useState(cropToEdit?.status || 'Growing');
  const [notes, setNotes] = useState(cropToEdit?.notes || '');
  const [image, setImage] = useState(
    cropToEdit?.image ||
      'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80'
  );

  const presetPhotos = [
    {
      name: 'Tomato',
      variety: 'Abhinav F1 Hybrid',
      url: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    },
    {
      name: 'Wheat',
      variety: 'Sharbati HD-2967',
      url: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
    },
    {
      name: 'Onion',
      variety: 'Nasik Red (Fursungi)',
      url: 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=600&auto=format&fit=crop&q=80',
    },
    {
      name: 'Sugarcane',
      variety: 'Co-86032 (Nira)',
      url: 'https://images.unsplash.com/photo-1543083477-4f785aeafaa9?w=600&auto=format&fit=crop&q=80',
    },
    {
      name: 'Cotton',
      variety: 'Bt Cotton RCH-2',
      url: 'https://images.unsplash.com/photo-1594897030560-69296561f36a?w=600&auto=format&fit=crop&q=80',
    },
    {
      name: 'Soybean',
      variety: 'JS-335 Yellow',
      url: 'https://images.unsplash.com/photo-1599420186946-7b6fb4e297f0?w=600&auto=format&fit=crop&q=80',
    },
    {
      name: 'Maize',
      variety: 'Pioneer P3396',
      url: 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=600&auto=format&fit=crop&q=80',
    },
    {
      name: 'Rice',
      variety: 'Basmati 1121',
      url: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&auto=format&fit=crop&q=80',
    },
  ];

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) {
      alert('Please enter a crop name');
      return;
    }
    const numArea = parseFloat(areaNumber);
    if (!areaNumber || isNaN(numArea) || numArea <= 0) {
      alert('Please enter a valid positive land area (e.g. 2.5)');
      return;
    }

    const savedCrop = {
      id: cropToEdit?.id || 'c_' + Date.now(),
      name: name.trim(),
      variety: variety.trim() || 'Standard Variety',
      area: `${areaNumber} ${unit}`,
      unit: unit,
      location: location.trim() || 'Baramati, Pune',
      plantingDate,
      expectedHarvest,
      status,
      notes: notes.trim(),
      image,
    };

    if (isEditing) {
      setCrops((prev: any) =>
        prev.map((c: any) => (c.id === savedCrop.id ? savedCrop : c))
      );
      if (setSelectedCrop) setSelectedCrop(savedCrop);
      showToast('Crop updated successfully');
    } else {
      setCrops((prev: any) => [savedCrop, ...prev]);
      if (setSelectedCrop) setSelectedCrop(savedCrop);
      showToast(`Crop "${savedCrop.name}" registered successfully`);
    }

    if (setCropToEdit) setCropToEdit(null);
    setCurrentRoute('crops');
  };

  return (
    <div className="p-4 max-w-2xl mx-auto space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-bold text-slate-800">
            {isEditing ? 'Edit Crop Details' : 'Record New Crop'}
          </h2>
          <p className="text-xs text-slate-500">
            {isEditing ? 'Update land size, status, or harvest dates' : 'Add crop to track growth & yield'}
          </p>
        </div>
        <button
          onClick={() => {
            if (setCropToEdit) setCropToEdit(null);
            setCurrentRoute('crops');
          }}
          className="text-xs font-semibold text-slate-500 hover:text-slate-800"
        >
          Cancel
        </button>
      </div>

      <form onSubmit={handleSave} className="space-y-4">
        {/* Photo Selection */}
        <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm space-y-3">
          <label className="text-xs font-bold text-slate-700 block">Crop Photo Preset</label>
          <div className="flex items-center gap-3">
            <img src={image} alt="Crop preview" className="w-16 h-16 rounded-xl object-cover border border-slate-200" />
            <div className="text-xs text-slate-600">
              <p className="font-semibold text-slate-800">{name || 'Selected Crop'}</p>
              <p className="text-[11px] text-slate-400">Tap below to choose representative photo & name</p>
            </div>
          </div>
          <div className="flex gap-2 overflow-x-auto pb-1">
            {presetPhotos.map((preset) => (
              <button
                type="button"
                key={preset.name}
                onClick={() => {
                  setImage(preset.url);
                  if (!name) setName(preset.name);
                  if (!variety) setVariety(preset.variety);
                }}
                className={`flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg border text-xs whitespace-nowrap transition ${
                  image === preset.url
                    ? 'border-emerald-500 bg-emerald-50 text-emerald-800 font-bold'
                    : 'border-slate-200 bg-slate-50 text-slate-700 hover:bg-slate-100'
                }`}
              >
                <img src={preset.url} alt={preset.name} className="w-4 h-4 rounded-full object-cover" />
                {preset.name}
              </button>
            ))}
          </div>
        </div>

        {/* Basic Info */}
        <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-3 shadow-sm">
          <div>
            <label className="text-xs font-bold text-slate-700">Crop Name *</label>
            <input
              type="text"
              required
              placeholder="e.g. Tomato, Wheat, Onion, Sugarcane"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            />
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700">Variety *</label>
            <input
              type="text"
              required
              placeholder="e.g. Abhinav F1, Sharbati HD-2967, Nasik Red"
              value={variety}
              onChange={(e) => setVariety(e.target.value)}
              className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            />
          </div>

          {/* Land Area and Unit */}
          <div className="grid grid-cols-3 gap-2">
            <div className="col-span-2">
              <label className="text-xs font-bold text-slate-700">Farm Area *</label>
              <input
                type="number"
                step="0.1"
                min="0.1"
                required
                placeholder="e.g. 2.5"
                value={areaNumber}
                onChange={(e) => setAreaNumber(e.target.value)}
                className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
              />
            </div>
            <div>
              <label className="text-xs font-bold text-slate-700">Unit *</label>
              <select
                value={unit}
                onChange={(e) => setUnit(e.target.value)}
                className="w-full mt-1 px-2.5 py-2 rounded-lg border border-slate-300 text-xs bg-white focus:ring-2 focus:ring-emerald-500 focus:outline-none"
              >
                <option value="Acres">Acres</option>
                <option value="Guntha">Guntha</option>
                <option value="Hectares">Hectares</option>
                <option value="Bigha">Bigha</option>
              </select>
            </div>
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700">Location / Village *</label>
            <input
              type="text"
              required
              placeholder="e.g. Baramati, Pune"
              value={location}
              onChange={(e) => setLocation(e.target.value)}
              className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            />
          </div>
        </div>

        {/* Timeline & Status */}
        <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-3 shadow-sm">
          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="text-xs font-bold text-slate-700">Planting Date *</label>
              <input
                type="text"
                required
                value={plantingDate}
                onChange={(e) => setPlantingDate(e.target.value)}
                className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
              />
            </div>
            <div>
              <label className="text-xs font-bold text-slate-700">Expected Harvest *</label>
              <input
                type="text"
                required
                value={expectedHarvest}
                onChange={(e) => setExpectedHarvest(e.target.value)}
                className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
              />
            </div>
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700">Crop Status *</label>
            <select
              value={status}
              onChange={(e) => setStatus(e.target.value)}
              className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs bg-white focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            >
              <option value="Growing">Growing</option>
              <option value="Ready for Harvest">Ready for Harvest</option>
              <option value="Harvested">Harvested</option>
            </select>
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700">Farmer Notes</label>
            <textarea
              rows={2}
              placeholder="Irrigation method, soil treatments, seed suppliers..."
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            ></textarea>
          </div>
        </div>

        {/* Form Actions */}
        <div className="flex gap-2 pt-1">
          <button
            type="button"
            onClick={() => {
              if (setCropToEdit) setCropToEdit(null);
              setCurrentRoute('crops');
            }}
            className="flex-1 bg-white border border-slate-300 hover:bg-slate-50 text-slate-700 font-bold text-xs py-2.5 rounded-lg transition"
          >
            Cancel
          </button>
          <button
            type="submit"
            className="flex-2 bg-emerald-700 hover:bg-emerald-800 text-white font-bold text-xs py-2.5 rounded-lg shadow-sm transition"
          >
            {isEditing ? 'Save Changes' : 'Save Crop'}
          </button>
        </div>
      </form>
    </div>
  );
}

// 4. Crop Details View
function CropDetailsView({
  selectedCrop,
  setCrops,
  setCurrentRoute,
  showToast,
  setCropToEdit,
  setCropForSale,
  setSaleToEdit,
}: any) {
  const handleDelete = () => {
    if (confirm(`Are you sure you want to delete "${selectedCrop.name} (${selectedCrop.variety})"?`)) {
      setCrops((prev: any) => prev.filter((c: any) => c.id !== selectedCrop.id));
      showToast(`Crop "${selectedCrop.name}" deleted successfully`);
      setCurrentRoute('crops');
    }
  };

  const handleEdit = () => {
    if (setCropToEdit) setCropToEdit(selectedCrop);
    setCurrentRoute('add_crop');
  };

  return (
    <div className="max-w-2xl mx-auto space-y-4 pb-8">
      {/* Top back & actions */}
      <div className="flex items-center justify-between p-4 pb-0">
        <button
          onClick={() => setCurrentRoute('crops')}
          className="flex items-center gap-1 text-xs font-bold text-slate-700 hover:text-emerald-700"
        >
          ← Back to My Crops
        </button>
        <div className="flex items-center gap-2">
          <button
            onClick={handleEdit}
            className="px-3 py-1 bg-white border border-slate-300 hover:border-emerald-600 text-slate-700 hover:text-emerald-700 text-xs font-bold rounded-lg transition"
          >
            Edit
          </button>
          <button
            onClick={handleDelete}
            className="px-3 py-1 text-red-600 hover:bg-red-50 text-xs font-bold rounded-lg transition"
          >
            Delete
          </button>
        </div>
      </div>

      {/* Hero Image */}
      <div className="px-4">
        <div className="relative rounded-2xl overflow-hidden border border-slate-200 shadow-sm">
          <img
            src={selectedCrop.image}
            alt={selectedCrop.name}
            className="w-full h-52 object-cover"
          />
          <div className="absolute top-3 right-3">
            <span
              className={`text-xs font-bold px-3 py-1 rounded-full shadow-sm ${
                selectedCrop.status === 'Ready for Harvest'
                  ? 'bg-amber-500 text-white'
                  : selectedCrop.status === 'Harvested'
                  ? 'bg-blue-600 text-white'
                  : 'bg-emerald-600 text-white'
              }`}
            >
              {selectedCrop.status}
            </span>
          </div>
        </div>
      </div>

      <div className="px-4 space-y-4">
        <div>
          <h2 className="text-2xl font-black text-slate-900">{selectedCrop.name}</h2>
          <p className="text-sm font-medium text-slate-500">{selectedCrop.variety}</p>
        </div>

        {/* Specifications Grid */}
        <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm space-y-3">
          <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider">
            Crop Specifications
          </h3>
          <div className="grid grid-cols-2 gap-3 text-xs">
            <div className="bg-slate-50 p-2.5 rounded-lg">
              <span className="text-slate-400 block text-[11px]">Farm Area</span>
              <p className="font-bold text-slate-800 mt-0.5">{selectedCrop.area}</p>
            </div>
            <div className="bg-slate-50 p-2.5 rounded-lg">
              <span className="text-slate-400 block text-[11px]">Variety</span>
              <p className="font-bold text-slate-800 mt-0.5">{selectedCrop.variety}</p>
            </div>
            <div className="bg-slate-50 p-2.5 rounded-lg">
              <span className="text-slate-400 block text-[11px]">Location</span>
              <p className="font-bold text-slate-800 mt-0.5">{selectedCrop.location || 'Baramati, Pune'}</p>
            </div>
            <div className="bg-slate-50 p-2.5 rounded-lg">
              <span className="text-slate-400 block text-[11px]">Planting Date</span>
              <p className="font-bold text-slate-800 mt-0.5">{selectedCrop.plantingDate}</p>
            </div>
            <div className="bg-slate-50 p-2.5 rounded-lg">
              <span className="text-slate-400 block text-[11px]">Expected Harvest</span>
              <p className="font-bold text-slate-800 mt-0.5">{selectedCrop.expectedHarvest}</p>
            </div>
            <div className="bg-slate-50 p-2.5 rounded-lg">
              <span className="text-slate-400 block text-[11px]">Current Status</span>
              <p className="font-bold text-emerald-700 mt-0.5">{selectedCrop.status}</p>
            </div>
          </div>
        </div>

        {/* Farmer Notes */}
        {selectedCrop.notes && (
          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm space-y-1.5">
            <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider">
              Farmer Notes
            </h3>
            <p className="text-xs text-slate-700 leading-relaxed bg-slate-50 p-3 rounded-lg">
              {selectedCrop.notes}
            </p>
          </div>
        )}

        {/* Actions */}
        <div className="space-y-2 pt-2">
          <button
            onClick={() => {
              if (setSaleToEdit) setSaleToEdit(null);
              if (setCropForSale) setCropForSale(selectedCrop);
              setCurrentRoute('sell_crop');
            }}
            className="w-full bg-emerald-700 hover:bg-emerald-800 text-white font-bold text-xs py-3 rounded-xl flex items-center justify-center gap-2 shadow-sm transition"
          >
            <DollarSign className="w-4 h-4" /> Sell This Crop
          </button>
          <button
            onClick={() => setCurrentRoute('crop_health')}
            className="w-full bg-teal-700 hover:bg-teal-800 text-white font-bold text-xs py-3 rounded-xl flex items-center justify-center gap-2 shadow-sm transition"
          >
            <HeartPulse className="w-4 h-4" /> Check Crop Health
          </button>
          <button
            onClick={handleEdit}
            className="w-full border border-slate-300 hover:border-emerald-600 text-slate-700 hover:text-emerald-700 font-bold text-xs py-2.5 rounded-xl transition"
          >
            Edit Crop Information
          </button>
        </div>
      </div>
    </div>
  );
}

// 5. Check Crop Health View
function CropHealthView({
  setCurrentRoute,
  selectedCrop,
  crops,
  setHealthResult,
}: any) {
  const [selectedCropName, setSelectedCropName] = useState(
    selectedCrop?.name || (crops && crops.length > 0 ? crops[0].name : 'Tomato')
  );
  const [selectedImage, setSelectedImage] = useState<string | null>(
    selectedCrop?.image || 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80'
  );
  const [conditionHint, setConditionHint] = useState<string>('Leaf Disease');
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [analysisStep, setAnalysisStep] = useState(0);
  const [validationError, setValidationError] = useState<string | null>(null);

  const sampleFoliage = [
    {
      label: 'Blight / Spot',
      category: 'Leaf Disease',
      url: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    },
    {
      label: 'Fungal Mildew',
      category: 'Fungal Infection',
      url: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
    },
    {
      label: 'Pest Holes',
      category: 'Pest Damage',
      url: 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=600&auto=format&fit=crop&q=80',
    },
    {
      label: 'Healthy Green',
      category: 'Healthy Crop',
      url: 'https://images.unsplash.com/photo-1543083477-4f785aeafaa9?w=600&auto=format&fit=crop&q=80',
    },
  ];

  const handleDiagnose = () => {
    setValidationError(null);
    if (!selectedCropName) {
      setValidationError('Please select a crop to diagnose.');
      return;
    }
    if (!selectedImage) {
      setValidationError('Please take a photo or select an image before checking health.');
      return;
    }

    setIsAnalyzing(true);
    setAnalysisStep(1);

    setTimeout(() => {
      setAnalysisStep(2);
    }, 500);

    setTimeout(() => {
      setAnalysisStep(3);
    }, 1000);

    setTimeout(() => {
      let result: any;
      if (conditionHint === 'Healthy Crop' || selectedImage.includes('1543083477-4f785aeafaa9')) {
        result = {
          id: 'diag_' + Date.now(),
          cropName: selectedCropName,
          imagePath: selectedImage,
          status: 'Healthy Crop',
          isHealthy: true,
          diseaseName: 'Healthy & Disease-Free Foliage',
          confidence: 0.96,
          symptoms: [
            'Uniform green pigmentation without chlorosis',
            'Intact leaf margins with firm cellular structure',
            'No fungal mycelium or pest puncture holes',
          ],
          recommendedActions: [
            {
              title: 'Maintain Regular Irrigation Routine',
              description: 'Maintain root zone moisture without over-saturating soil.',
            },
            {
              title: 'Balanced Nutrition',
              description: 'Apply organic compost or bio-fertilizers per soil schedule.',
            },
          ],
          preventionTips: [
            {
              title: 'Crop Sanitation',
              description: 'Keep inter-row pathways weed-free to prevent harboring insect vectors.',
            },
          ],
        };
      } else if (conditionHint === 'Fungal Infection' || selectedImage.includes('1574323347407')) {
        result = {
          id: 'diag_' + Date.now(),
          cropName: selectedCropName,
          imagePath: selectedImage,
          status: 'Fungal Infection',
          isHealthy: false,
          diseaseName: selectedCropName.toLowerCase().includes('wheat')
            ? 'Yellow Rust (Puccinia striiformis)'
            : 'Powdery Mildew Fungal Growth',
          confidence: 0.91,
          symptoms: [
            'White or grayish powdery patches on upper leaf surfaces',
            'Leaves turn brittle and curl upwards',
            'Stunted plant vigor and premature leaf drop',
          ],
          recommendedActions: [
            {
              title: 'Improve Canopy Aeration',
              description: 'Thin out crowded vegetative shoots to promote direct sunlight.',
            },
            {
              title: 'Apply Wettable Sulfur / Bio-Spray',
              description: 'Spray mild wettable sulfur or Bacillus subtilis bio-formulation.',
            },
          ],
          preventionTips: [
            {
              title: 'Avoid Excess Nitrogen',
              description: 'Excess nitrogen fertilizer encourages soft, vulnerable foliage growth.',
            },
          ],
        };
      } else if (conditionHint === 'Pest Damage' || selectedImage.includes('1618512496248')) {
        result = {
          id: 'diag_' + Date.now(),
          cropName: selectedCropName,
          imagePath: selectedImage,
          status: 'Pest Damage',
          isHealthy: false,
          diseaseName: selectedCropName.toLowerCase().includes('maize')
            ? 'Fall Armyworm (Spodoptera frugiperda)'
            : 'Leaf Miner & Piercing Insects',
          confidence: 0.94,
          symptoms: [
            'Winding serpentine tunnels and chewed leaf edges',
            'Visible shot-holes on younger shoot foliage',
            'Clusters of insect nymphs on the underside of leaves',
          ],
          recommendedActions: [
            {
              title: 'Install Sticky Pheromone Traps',
              description: 'Place yellow and blue sticky traps (5-6 per acre) to trap flying vectors.',
            },
            {
              title: 'Organic Neem Oil Spray',
              description: 'Apply 10,000 ppm cold-pressed neem oil (5 ml per litre of water) at dusk.',
            },
          ],
          preventionTips: [
            {
              title: 'Border Trap Crops',
              description: 'Plant marigold or castor around plot boundaries to attract insects away.',
            },
          ],
        };
      } else {
        result = {
          id: 'diag_' + Date.now(),
          cropName: selectedCropName,
          imagePath: selectedImage,
          status: 'Leaf Disease',
          isHealthy: false,
          diseaseName: selectedCropName.toLowerCase().includes('tomato')
            ? 'Tomato Early Blight (Alternaria solani)'
            : 'Foliar Leaf Blight',
          confidence: 0.93,
          symptoms: [
            'Concentric target-like brown spots on older foliage',
            'Yellow chlorotic halos surrounding necrotic lesions',
            'Premature drying and defoliation of lower leaves',
          ],
          recommendedActions: [
            {
              title: 'Prune & Remove Infected Leaves',
              description: 'Gently clip heavily spotted leaves and burn or bury away from the plot.',
            },
            {
              title: 'Avoid Overhead Sprinkler Irrigation',
              description: 'Switch to drip irrigation to keep leaf surfaces dry and arrest spores.',
            },
          ],
          preventionTips: [
            {
              title: 'Ensure Wide Row Spacing',
              description: 'Follow recommended row spacing to allow rapid drying of morning dew.',
            },
          ],
        };
      }

      setHealthResult(result);
      setIsAnalyzing(false);
      setCurrentRoute('crop_health_result');
    }, 1400);
  };

  return (
    <div className="p-4 max-w-xl mx-auto space-y-4">
      {/* Guidance Card */}
      <div className="bg-teal-50 border border-teal-200 rounded-xl p-3.5 flex items-center gap-3">
        <div className="w-10 h-10 rounded-full bg-teal-700 text-white flex items-center justify-center flex-shrink-0">
          <HeartPulse className="w-5 h-5" />
        </div>
        <div>
          <h3 className="font-bold text-sm text-teal-900">Check Crop Health</h3>
          <p className="text-xs text-teal-700">
            Take or select a photo of your crop foliage to diagnose diseases, fungal infections, or pests.
          </p>
        </div>
      </div>

      {/* Validation banner */}
      {validationError && (
        <div className="bg-red-50 border border-red-200 text-red-700 p-3 rounded-xl text-xs font-semibold flex items-center gap-2">
          <AlertTriangle className="w-4 h-4 flex-shrink-0 text-red-600" />
          {validationError}
        </div>
      )}

      {/* Crop Selector Card */}
      <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-2 shadow-sm">
        <div className="flex justify-between items-center">
          <label className="text-xs font-bold text-slate-700">Select Crop to Diagnose</label>
          {selectedCrop && (
            <span className="text-[10px] bg-emerald-100 text-emerald-800 font-bold px-2 py-0.5 rounded-full">
              From Crop Details
            </span>
          )}
        </div>
        <select
          value={selectedCropName}
          onChange={(e) => {
            setSelectedCropName(e.target.value);
            setValidationError(null);
          }}
          className="w-full px-3 py-2 rounded-lg border border-slate-300 text-xs font-medium text-slate-800 bg-white focus:ring-2 focus:ring-emerald-500 focus:outline-none"
        >
          {crops && crops.map((c: any) => (
            <option key={c.id} value={c.name}>
              {c.name} ({c.variety})
            </option>
          ))}
          <option value="Tomato">Tomato</option>
          <option value="Wheat">Wheat</option>
          <option value="Onion">Onion</option>
          <option value="Sugarcane">Sugarcane</option>
          <option value="Cotton">Cotton</option>
          <option value="Soybean">Soybean</option>
          <option value="Maize">Maize</option>
        </select>
      </div>

      {/* Photo Preview & Capture Area */}
      <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-3 shadow-sm">
        <label className="text-xs font-bold text-slate-700 block">Foliage Image</label>
        <div className="h-52 rounded-xl border border-slate-200 overflow-hidden relative bg-slate-50 flex items-center justify-center">
          {selectedImage ? (
            <>
              <img
                src={selectedImage}
                alt="Selected foliage"
                className="w-full h-full object-cover"
              />
              <div className="absolute top-2 left-2 bg-black/70 text-white text-[10px] font-bold px-2.5 py-1 rounded-md">
                {conditionHint}
              </div>
              <button
                onClick={() => {
                  setSelectedImage(null);
                  setConditionHint('');
                }}
                className="absolute top-2 right-2 bg-black/60 hover:bg-black text-white p-1 rounded-full text-xs"
              >
                ✕
              </button>
            </>
          ) : (
            <div className="text-center p-4">
              <Camera className="w-8 h-8 text-slate-400 mx-auto mb-2" />
              <p className="text-xs font-bold text-slate-700">No leaf image selected</p>
              <p className="text-[11px] text-slate-400">Capture affected leaf or pick sample below</p>
            </div>
          )}
        </div>

        <div className="grid grid-cols-2 gap-2">
          <button
            type="button"
            onClick={() => {
              setSelectedImage(sampleFoliage[0].url);
              setConditionHint(sampleFoliage[0].category);
              setValidationError(null);
            }}
            className="py-2 px-3 border border-emerald-600 text-emerald-700 font-bold text-xs rounded-lg flex items-center justify-center gap-1.5 hover:bg-emerald-50 transition"
          >
            <Camera className="w-4 h-4" /> Take Photo
          </button>
          <button
            type="button"
            onClick={() => {
              setSelectedImage(sampleFoliage[1].url);
              setConditionHint(sampleFoliage[1].category);
              setValidationError(null);
            }}
            className="py-2 px-3 border border-emerald-600 text-emerald-700 font-bold text-xs rounded-lg flex items-center justify-center gap-1.5 hover:bg-emerald-50 transition"
          >
            Choose from Gallery
          </button>
        </div>
      </div>

      {/* Preset Test Foliage Samples */}
      <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-2.5 shadow-sm">
        <div className="flex justify-between items-center">
          <span className="text-xs font-bold text-slate-700">Test with Leaf Presets</span>
          <span className="text-[11px] text-slate-400">Tap to diagnose</span>
        </div>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
          {sampleFoliage.map((sample) => {
            const isSelected = selectedImage === sample.url;
            return (
              <button
                key={sample.label}
                type="button"
                onClick={() => {
                  setSelectedImage(sample.url);
                  setConditionHint(sample.category);
                  setValidationError(null);
                }}
                className={`p-2 rounded-lg border text-left flex flex-col gap-1 transition ${
                  isSelected
                    ? 'border-emerald-600 bg-emerald-50 ring-1 ring-emerald-600'
                    : 'border-slate-200 hover:bg-slate-50'
                }`}
              >
                <img
                  src={sample.url}
                  alt={sample.label}
                  className="w-full h-14 rounded object-cover"
                />
                <span className="text-[11px] font-bold text-slate-800 truncate">
                  {sample.label}
                </span>
                <span className="text-[9px] text-slate-500 truncate">{sample.category}</span>
              </button>
            );
          })}
        </div>
      </div>

      {/* Action Button & Loading Indicator */}
      <div className="pt-2 space-y-2">
        {isAnalyzing ? (
          <div className="bg-emerald-50 border border-emerald-200 p-4 rounded-xl text-center space-y-2">
            <div className="inline-block animate-spin rounded-full h-6 w-6 border-b-2 border-emerald-700"></div>
            <p className="text-xs font-bold text-emerald-800">
              {analysisStep === 1 && 'Analyzing leaf tissue & cuticle structure...'}
              {analysisStep === 2 && 'Matching foliar pathology indicators...'}
              {analysisStep === 3 && 'Generating safe agronomic remedies...'}
            </p>
          </div>
        ) : (
          <button
            onClick={handleDiagnose}
            className="w-full bg-emerald-700 hover:bg-emerald-800 text-white font-bold text-xs py-3 rounded-xl shadow-sm transition flex items-center justify-center gap-2"
          >
            <HeartPulse className="w-4 h-4" /> Check Crop Health
          </button>
        )}
      </div>
    </div>
  );
}

// 6. Crop Health Result View
function CropHealthResultView({
  healthResult,
  setCurrentRoute,
  selectedCrop,
}: any) {
  if (!healthResult) {
    return (
      <div className="p-8 text-center space-y-3">
        <p className="text-sm font-bold text-slate-700">No diagnosis result available</p>
        <button
          onClick={() => setCurrentRoute('crop_health')}
          className="bg-emerald-700 text-white text-xs font-bold px-4 py-2 rounded-lg"
        >
          Check Crop Health
        </button>
      </div>
    );
  }

  const isHealthy = healthResult.isHealthy;
  const statusColor = isHealthy
    ? 'text-emerald-800 bg-emerald-50 border-emerald-300'
    : healthResult.status === 'Fungal Infection'
    ? 'text-purple-800 bg-purple-50 border-purple-300'
    : healthResult.status === 'Pest Damage'
    ? 'text-orange-900 bg-orange-50 border-orange-300'
    : 'text-amber-900 bg-amber-50 border-amber-300';

  return (
    <div className="p-4 max-w-xl mx-auto space-y-4 pb-12">
      {/* Header Back */}
      <div className="flex items-center justify-between">
        <button
          onClick={() => {
            if (selectedCrop) {
              setCurrentRoute('crop_details');
            } else {
              setCurrentRoute('crops');
            }
          }}
          className="flex items-center gap-1 text-xs font-bold text-slate-700 hover:text-emerald-700"
        >
          ← Back to Crop Details
        </button>
        <span className="text-[10px] font-bold px-2.5 py-1 rounded-full bg-slate-100 text-slate-600">
          {(healthResult.confidence * 100).toFixed(0)}% Match
        </span>
      </div>

      {/* Hero Image */}
      <div className="relative rounded-xl overflow-hidden border border-slate-200 shadow-sm h-52">
        <img
          src={healthResult.imagePath}
          alt={healthResult.cropName}
          className="w-full h-full object-cover"
        />
        <div className="absolute top-2 left-2 bg-black/75 text-white text-xs font-bold px-3 py-1 rounded-md">
          Crop: {healthResult.cropName}
        </div>
        <div className="absolute bottom-2 right-2 bg-emerald-700 text-white text-xs font-bold px-3 py-1 rounded-md shadow">
          {(healthResult.confidence * 100).toFixed(0)}% Confidence
        </div>
      </div>

      {/* Status Card */}
      <div className={`border rounded-xl p-4 space-y-2 ${statusColor}`}>
        <div className="flex items-center gap-2">
          {isHealthy ? (
            <CheckCircle2 className="w-5 h-5 text-emerald-600" />
          ) : (
            <AlertTriangle className="w-5 h-5 text-amber-600" />
          )}
          <span className="text-xs font-bold uppercase tracking-wider">
            {healthResult.status}
          </span>
        </div>
        <h3 className="text-lg font-black text-slate-900">{healthResult.diseaseName}</h3>
        {/* Confidence progress bar */}
        <div className="pt-1">
          <div className="w-full bg-white/70 rounded-full h-2 overflow-hidden">
            <div
              className={`h-2 rounded-full ${isHealthy ? 'bg-emerald-600' : 'bg-amber-600'}`}
              style={{ width: `${healthResult.confidence * 100}%` }}
            ></div>
          </div>
        </div>
      </div>

      {/* Observed Symptoms */}
      <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-2 shadow-sm">
        <h4 className="text-xs font-bold text-slate-900 uppercase tracking-wider flex items-center gap-1.5">
          Observed Symptoms
        </h4>
        <ul className="text-xs text-slate-700 space-y-1.5 list-disc pl-4">
          {healthResult.symptoms.map((sym: string, idx: number) => (
            <li key={idx}>{sym}</li>
          ))}
        </ul>
      </div>

      {/* Recommended Agronomic Actions */}
      <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-3 shadow-sm">
        <h4 className="text-xs font-bold text-slate-900 uppercase tracking-wider flex items-center gap-1.5">
          Recommended Agronomic Actions
        </h4>
        <div className="space-y-2">
          {healthResult.recommendedActions.map((action: any, idx: number) => (
            <div key={idx} className="bg-slate-50 p-2.5 rounded-lg border border-slate-200/60">
              <p className="text-xs font-bold text-slate-800">{action.title}</p>
              <p className="text-[11px] text-slate-600 mt-0.5">{action.description}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Prevention Tips */}
      <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-3 shadow-sm">
        <h4 className="text-xs font-bold text-slate-900 uppercase tracking-wider flex items-center gap-1.5">
          Prevention & Field Management
        </h4>
        <div className="space-y-2">
          {healthResult.preventionTips.map((tip: any, idx: number) => (
            <div key={idx} className="bg-slate-50 p-2.5 rounded-lg border border-slate-200/60">
              <p className="text-xs font-bold text-slate-800">{tip.title}</p>
              <p className="text-[11px] text-slate-600 mt-0.5">{tip.description}</p>
            </div>
          ))}
        </div>
      </div>

      {/* Advisory Notice */}
      <div className="bg-slate-100 p-3 rounded-xl text-[11px] text-slate-500 leading-relaxed">
        <b>Diagnostic Advisory:</b> This guidance is an educational field support tool. For high-severity
        infections, consult your nearest Krishi Vigyan Kendra (KVK) or agricultural officer.
      </div>

      {/* Navigation Buttons */}
      <div className="space-y-2 pt-2">
        <button
          onClick={() => {
            if (selectedCrop) {
              setCurrentRoute('crop_details');
            } else {
              setCurrentRoute('crops');
            }
          }}
          className="w-full bg-emerald-700 hover:bg-emerald-800 text-white font-bold text-xs py-3 rounded-xl shadow-sm transition"
        >
          Back to Crop Details
        </button>
        <button
          onClick={() => setCurrentRoute('crop_health')}
          className="w-full border border-slate-300 hover:border-emerald-600 text-slate-700 hover:text-emerald-700 font-bold text-xs py-2.5 rounded-xl transition"
        >
          Check Another Leaf / Crop
        </button>
        <button
          onClick={() => setCurrentRoute('home')}
          className="w-full text-slate-500 hover:text-slate-800 text-xs font-semibold py-1.5 transition"
        >
          Return to Farmer Dashboard
        </button>
      </div>
    </div>
  );
}

// 7. Sell Crop View
function SellCropView({
  crops,
  cropSales,
  setCropSales,
  setCurrentRoute,
  showToast,
  cropForSale,
  setCropForSale,
  saleToEdit,
  setSaleToEdit,
  farmerUser,
}: any) {
  const isEditing = !!saleToEdit;

  // Initialize fields
  const [selectedCropId, setSelectedCropId] = useState<string>(() => {
    if (saleToEdit?.cropId) return saleToEdit.cropId;
    if (cropForSale?.id) return cropForSale.id;
    return crops && crops.length > 0 ? crops[0].id : '';
  });

  const [cropName, setCropName] = useState<string>(() => {
    if (saleToEdit) return saleToEdit.cropName;
    if (cropForSale) return cropForSale.name;
    return crops && crops.length > 0 ? crops[0].name : '';
  });

  const [variety, setVariety] = useState<string>(() => {
    if (saleToEdit) return saleToEdit.variety || '';
    if (cropForSale) return cropForSale.variety || '';
    return crops && crops.length > 0 ? crops[0].variety : '';
  });

  const [quantity, setQuantity] = useState<string>(() => {
    if (saleToEdit) return String(saleToEdit.quantity);
    return '500';
  });

  const [unit, setUnit] = useState<string>(() => {
    if (saleToEdit) return saleToEdit.unit || 'kg';
    return 'kg';
  });

  const [price, setPrice] = useState<string>(() => {
    if (saleToEdit) return String(saleToEdit.price);
    return '25';
  });

  const [priceUnit, setPriceUnit] = useState<string>(() => {
    if (saleToEdit) return saleToEdit.priceUnit || '₹/kg';
    return '₹/kg';
  });

  const [availableDate, setAvailableDate] = useState<string>(() => {
    if (saleToEdit) return saleToEdit.availableDate || '';
    if (cropForSale?.expectedHarvest) return cropForSale.expectedHarvest;
    return '15 Sep 2026';
  });

  const [location, setLocation] = useState<string>(() => {
    if (saleToEdit) return saleToEdit.location;
    if (cropForSale?.location) return cropForSale.location;
    return farmerUser?.village ? `${farmerUser.village}, Pune` : 'Baramati, Pune';
  });

  const [desc, setDesc] = useState<string>(() => {
    if (saleToEdit) return saleToEdit.description || '';
    if (cropForSale?.notes) return cropForSale.notes;
    return 'Freshly harvested, graded and packaged. Moisture tested and ready for dispatch.';
  });

  const [image, setImage] = useState<string>(() => {
    if (saleToEdit?.image) return saleToEdit.image;
    if (cropForSale?.image) return cropForSale.image;
    return crops && crops.length > 0
      ? crops[0].image
      : 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80';
  });

  // When crop selection changes
  const handleCropSelect = (cropId: string) => {
    setSelectedCropId(cropId);
    const matchedCrop = crops.find((c: any) => c.id === cropId);
    if (matchedCrop) {
      setCropName(matchedCrop.name);
      setVariety(matchedCrop.variety || '');
      if (matchedCrop.image) setImage(matchedCrop.image);
      if (matchedCrop.expectedHarvest) setAvailableDate(matchedCrop.expectedHarvest);
      if (matchedCrop.location) setLocation(matchedCrop.location);
    }
  };

  const totalEstimatedValue = (parseFloat(quantity) || 0) * (parseFloat(price) || 0);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    if (!cropName.trim()) {
      showToast('Please specify crop name');
      return;
    }
    if (!quantity || parseFloat(quantity) <= 0) {
      showToast('Please enter a valid quantity');
      return;
    }
    if (!price || parseFloat(price) <= 0) {
      showToast('Please enter a valid expected price');
      return;
    }

    if (isEditing) {
      setCropSales((prev: any[]) =>
        prev.map((s) =>
          s.id === saleToEdit.id
            ? {
                ...s,
                cropName,
                variety,
                quantity,
                unit,
                price: Number(price),
                priceUnit,
                availableDate,
                location,
                description: desc,
                image,
              }
            : s
        )
      );
      showToast('Sale listing updated successfully');
    } else {
      const newSale = {
        id: 'cs_' + Date.now(),
        cropId: selectedCropId || null,
        cropName,
        variety: variety || 'Standard Variety',
        quantity,
        unit,
        price: Number(price),
        priceUnit,
        availableDate,
        location,
        status: 'Active',
        image,
        description: desc,
        postedDate: 'Today',
      };
      setCropSales((prev: any[]) => [newSale, ...prev]);
      showToast('Crop listing posted successfully');
    }

    if (setSaleToEdit) setSaleToEdit(null);
    if (setCropForSale) setCropForSale(null);
    setCurrentRoute('my_crop_sales');
  };

  return (
    <div className="max-w-2xl mx-auto p-4 space-y-4 pb-12">
      {/* Header */}
      <div className="flex items-center justify-between">
        <button
          onClick={() => {
            if (setSaleToEdit) setSaleToEdit(null);
            if (setCropForSale) setCropForSale(null);
            setCurrentRoute(isEditing ? 'sale_details' : 'my_crop_sales');
          }}
          className="flex items-center gap-1.5 text-xs font-bold text-slate-700 hover:text-emerald-700"
        >
          <ArrowLeft className="w-4 h-4" /> Back
        </button>
        <h2 className="text-base font-bold text-slate-900">
          {isEditing ? 'Edit Crop Sale Listing' : 'Create Crop Sale Listing'}
        </h2>
        <button
          onClick={() => setCurrentRoute('my_crop_sales')}
          className="text-xs font-bold text-emerald-700 hover:underline"
        >
          My Sales
        </button>
      </div>

      <div className="bg-emerald-50 border border-emerald-200 rounded-xl p-3 flex items-start gap-2 text-xs text-emerald-900">
        <DollarSign className="w-4 h-4 text-emerald-700 shrink-0 mt-0.5" />
        <p>
          List your harvest to receive direct inquiries from registered buyers, mills, and traders with zero intermediary commission.
        </p>
      </div>

      <form onSubmit={handleSubmit} className="bg-white p-5 rounded-2xl border border-slate-200 space-y-4 shadow-sm">
        {/* Crop Selection */}
        {crops && crops.length > 0 && (
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">
              Select Crop from My Crops
            </label>
            <select
              value={selectedCropId}
              onChange={(e) => handleCropSelect(e.target.value)}
              className="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs bg-slate-50 focus:bg-white focus:outline-none focus:ring-2 focus:ring-emerald-500"
            >
              {crops.map((c: any) => (
                <option key={c.id} value={c.id}>
                  {c.name} ({c.variety}) - {c.area}
                </option>
              ))}
            </select>
          </div>
        )}

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Crop Name *</label>
            <input
              type="text"
              required
              value={cropName}
              onChange={(e) => setCropName(e.target.value)}
              placeholder="e.g. Tomato, Wheat, Onion"
              className="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Crop Variety</label>
            <input
              type="text"
              value={variety}
              onChange={(e) => setVariety(e.target.value)}
              placeholder="e.g. Abhinav F1, HD-2967"
              className="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            />
          </div>
        </div>

        {/* Quantity & Unit */}
        <div className="grid grid-cols-3 gap-2">
          <div className="col-span-2">
            <label className="block text-xs font-bold text-slate-700 mb-1">Available Quantity *</label>
            <input
              type="number"
              required
              min="1"
              value={quantity}
              onChange={(e) => setQuantity(e.target.value)}
              placeholder="e.g. 500"
              className="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Quantity Unit</label>
            <select
              value={unit}
              onChange={(e) => {
                setUnit(e.target.value);
                setPriceUnit(`₹/${e.target.value}`);
              }}
              className="w-full px-2 py-2 rounded-xl border border-slate-300 text-xs bg-slate-50 focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            >
              <option value="kg">kg</option>
              <option value="quintal">quintal</option>
              <option value="ton">ton</option>
            </select>
          </div>
        </div>

        {/* Expected Price & Unit */}
        <div className="grid grid-cols-3 gap-2">
          <div className="col-span-2">
            <label className="block text-xs font-bold text-slate-700 mb-1">Expected Price *</label>
            <input
              type="number"
              required
              min="1"
              value={price}
              onChange={(e) => setPrice(e.target.value)}
              placeholder="e.g. 25"
              className="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Price Unit</label>
            <select
              value={priceUnit}
              onChange={(e) => setPriceUnit(e.target.value)}
              className="w-full px-2 py-2 rounded-xl border border-slate-300 text-xs bg-slate-50 focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            >
              <option value="₹/kg">₹/kg</option>
              <option value="₹/quintal">₹/quintal</option>
              <option value="₹/ton">₹/ton</option>
            </select>
          </div>
        </div>

        {/* Live Estimated Total Box */}
        <div className="bg-slate-50 border border-slate-200 rounded-xl p-3 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <TrendingUp className="w-4 h-4 text-emerald-700" />
            <div>
              <p className="text-[11px] font-bold text-slate-500 uppercase tracking-wide">
                Total Estimated Value
              </p>
              <p className="text-xs text-slate-600">
                {quantity || 0} {unit} × ₹{price || 0}/{unit}
              </p>
            </div>
          </div>
          <p className="text-base font-black text-emerald-700">
            ₹{totalEstimatedValue.toLocaleString('en-IN')}
          </p>
        </div>

        {/* Expected Harvest Date & Location */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">
              Available Harvest Date
            </label>
            <div className="relative">
              <input
                type="text"
                value={availableDate}
                onChange={(e) => setAvailableDate(e.target.value)}
                placeholder="e.g. 15 Sep 2026"
                className="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none pl-8"
              />
              <Calendar className="w-3.5 h-3.5 text-slate-400 absolute left-2.5 top-2.5" />
            </div>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">
              Village / Location *
            </label>
            <div className="relative">
              <input
                type="text"
                required
                value={location}
                onChange={(e) => setLocation(e.target.value)}
                placeholder="e.g. Baramati, Pune"
                className="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none pl-8"
              />
              <MapPin className="w-3.5 h-3.5 text-slate-400 absolute left-2.5 top-2.5" />
            </div>
          </div>
        </div>

        {/* Description / Notes */}
        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1">
            Description / Harvest Details
          </label>
          <textarea
            rows={2}
            value={desc}
            onChange={(e) => setDesc(e.target.value)}
            placeholder="Mention quality, moisture content, packaging or dispatch readiness..."
            className="w-full px-3 py-2 rounded-xl border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
          ></textarea>
        </div>

        {/* Action Buttons */}
        <div className="pt-2 flex gap-2">
          <button
            type="button"
            onClick={() => {
              if (setSaleToEdit) setSaleToEdit(null);
              if (setCropForSale) setCropForSale(null);
              setCurrentRoute('my_crop_sales');
            }}
            className="flex-1 border border-slate-300 hover:bg-slate-50 text-slate-700 font-bold text-xs py-2.5 rounded-xl transition"
          >
            Cancel
          </button>
          <button
            type="submit"
            className="flex-1 bg-emerald-700 hover:bg-emerald-800 text-white font-bold text-xs py-2.5 rounded-xl shadow-sm transition flex items-center justify-center gap-1.5"
          >
            <CheckCircle2 className="w-4 h-4" />
            {isEditing ? 'Save Changes' : 'Post for Sale'}
          </button>
        </div>
      </form>
    </div>
  );
}

// 8. My Crop Sales View
function MyCropSalesView({
  cropSales,
  setCropSales,
  setCurrentRoute,
  showToast,
  setSaleToEdit,
  setCropForSale,
  setSelectedSale,
}: any) {
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState<'All' | 'Active' | 'Sold' | 'Cancelled'>('All');

  const filteredSales = cropSales.filter((sale: any) => {
    const matchesSearch =
      sale.cropName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      (sale.variety && sale.variety.toLowerCase().includes(searchQuery.toLowerCase())) ||
      (sale.location && sale.location.toLowerCase().includes(searchQuery.toLowerCase()));

    const matchesStatus =
      statusFilter === 'All' ||
      sale.status.toLowerCase() === statusFilter.toLowerCase();

    return matchesSearch && matchesStatus;
  });

  const getStatusBadge = (status: string) => {
    switch (status.toLowerCase()) {
      case 'active':
      case 'available':
        return (
          <span className="text-[10px] font-bold px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 border border-emerald-200">
            Active
          </span>
        );
      case 'sold':
        return (
          <span className="text-[10px] font-bold px-2.5 py-0.5 rounded-full bg-blue-100 text-blue-800 border border-blue-200">
            Sold
          </span>
        );
      case 'cancelled':
        return (
          <span className="text-[10px] font-bold px-2.5 py-0.5 rounded-full bg-slate-200 text-slate-700 border border-slate-300">
            Cancelled
          </span>
        );
      default:
        return (
          <span className="text-[10px] font-bold px-2.5 py-0.5 rounded-full bg-amber-100 text-amber-800 border border-amber-200">
            {status}
          </span>
        );
    }
  };

  return (
    <div className="max-w-3xl mx-auto p-4 space-y-4 pb-12">
      {/* Top Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-black text-slate-900">My Crop Sales</h2>
          <p className="text-xs text-slate-500">Manage listings and view direct buyer offers</p>
        </div>
        <button
          onClick={() => {
            if (setCropForSale) setCropForSale(null);
            if (setSaleToEdit) setSaleToEdit(null);
            setCurrentRoute('sell_crop');
          }}
          className="bg-emerald-700 hover:bg-emerald-800 text-white text-xs font-bold px-3.5 py-2 rounded-xl flex items-center gap-1.5 shadow-sm transition"
        >
          <Plus className="w-4 h-4" /> Sell Crop
        </button>
      </div>

      {/* Search Input */}
      <div className="relative">
        <input
          type="text"
          placeholder="Search by crop, variety, or village..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full px-3 py-2.5 pl-9 rounded-xl border border-slate-200 bg-white text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none shadow-sm"
        />
        <Search className="w-4 h-4 text-slate-400 absolute left-3 top-3" />
      </div>

      {/* Status Filter Chips */}
      <div className="flex items-center gap-1.5 overflow-x-auto pb-1">
        {(['All', 'Active', 'Sold', 'Cancelled'] as const).map((filter) => {
          const isActive = statusFilter === filter;
          const count =
            filter === 'All'
              ? cropSales.length
              : cropSales.filter((s: any) => s.status.toLowerCase() === filter.toLowerCase()).length;
          return (
            <button
              key={filter}
              onClick={() => setStatusFilter(filter)}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition flex items-center gap-1.5 whitespace-nowrap ${
                isActive
                  ? 'bg-emerald-700 text-white shadow-sm'
                  : 'bg-white border border-slate-200 text-slate-600 hover:bg-slate-50'
              }`}
            >
              {filter}
              <span
                className={`text-[10px] px-1.5 py-0.2 rounded-full ${
                  isActive ? 'bg-emerald-900/40 text-white' : 'bg-slate-100 text-slate-600'
                }`}
              >
                {count}
              </span>
            </button>
          );
        })}
      </div>

      {/* Sales List */}
      {filteredSales.length === 0 ? (
        <div className="bg-white rounded-2xl border border-slate-200 p-8 text-center space-y-3">
          <div className="w-12 h-12 rounded-full bg-emerald-50 text-emerald-700 mx-auto flex items-center justify-center">
            <DollarSign className="w-6 h-6" />
          </div>
          <h3 className="text-sm font-bold text-slate-800">No Crop Sale Listings Found</h3>
          <p className="text-xs text-slate-500 max-w-xs mx-auto">
            {searchQuery
              ? `No listings match "${searchQuery}". Try changing your search query.`
              : 'You have not listed any crops for sale under this filter yet.'}
          </p>
          <button
            onClick={() => {
              if (setCropForSale) setCropForSale(null);
              if (setSaleToEdit) setSaleToEdit(null);
              setCurrentRoute('sell_crop');
            }}
            className="inline-flex items-center gap-1.5 bg-emerald-700 hover:bg-emerald-800 text-white text-xs font-bold px-4 py-2 rounded-xl shadow-sm"
          >
            <Plus className="w-4 h-4" /> Create First Listing
          </button>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-3.5">
          {filteredSales.map((sale: any) => {
            const totalVal = (parseFloat(sale.quantity) || 0) * (parseFloat(sale.price) || 0);
            return (
              <div
                key={sale.id}
                onClick={() => {
                  if (setSelectedSale) setSelectedSale(sale);
                  setCurrentRoute('sale_details');
                }}
                className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm hover:shadow-md hover:border-emerald-300 transition cursor-pointer flex flex-col justify-between space-y-3"
              >
                <div className="flex gap-3 items-start">
                  <img
                    src={sale.image}
                    alt={sale.cropName}
                    className="w-16 h-16 rounded-xl object-cover border border-slate-100 shrink-0"
                  />
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between gap-1">
                      <h3 className="font-bold text-sm text-slate-900 truncate">
                        {sale.cropName}
                      </h3>
                      {getStatusBadge(sale.status)}
                    </div>
                    {sale.variety && (
                      <p className="text-[11px] font-medium text-slate-500 truncate mt-0.5">
                        {sale.variety}
                      </p>
                    )}
                    <p className="text-xs font-bold text-emerald-700 mt-1">
                      {sale.quantity} {sale.unit} • ₹{sale.price}/{sale.unit}
                    </p>
                  </div>
                </div>

                <div className="pt-2 border-t border-slate-100 flex items-center justify-between text-[11px] text-slate-500">
                  <span className="flex items-center gap-1">
                    <MapPin className="w-3 h-3 text-slate-400" /> {sale.location}
                  </span>
                  <span className="font-bold text-slate-800">
                    Est: ₹{totalVal.toLocaleString('en-IN')}
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

// 8b. Crop Sale Details View
function CropSaleDetailsView({
  selectedSale,
  setCropSales,
  setCurrentRoute,
  showToast,
  setSaleToEdit,
}: any) {
  if (!selectedSale) {
    return (
      <div className="p-6 text-center space-y-3">
        <p className="text-xs text-slate-500">No sale listing selected.</p>
        <button
          onClick={() => setCurrentRoute('my_crop_sales')}
          className="text-xs font-bold text-emerald-700 underline"
        >
          Return to My Crop Sales
        </button>
      </div>
    );
  }

  const totalVal = (parseFloat(selectedSale.quantity) || 0) * (parseFloat(selectedSale.price) || 0);

  const handleCancelListing = () => {
    if (confirm(`Are you sure you want to cancel the sale listing for "${selectedSale.cropName}"?`)) {
      setCropSales((prev: any[]) =>
        prev.map((s) => (s.id === selectedSale.id ? { ...s, status: 'Cancelled' } : s))
      );
      selectedSale.status = 'Cancelled';
      showToast('Listing marked as Cancelled');
    }
  };

  const handleMarkAsSold = () => {
    setCropSales((prev: any[]) =>
      prev.map((s) => (s.id === selectedSale.id ? { ...s, status: 'Sold' } : s))
    );
    selectedSale.status = 'Sold';
    showToast('Listing marked as Sold! Congratulations.');
  };

  const handleReactivate = () => {
    setCropSales((prev: any[]) =>
      prev.map((s) => (s.id === selectedSale.id ? { ...s, status: 'Active' } : s))
    );
    selectedSale.status = 'Active';
    showToast('Listing is now Active');
  };

  return (
    <div className="max-w-2xl mx-auto space-y-4 p-4 pb-12">
      {/* Top Bar */}
      <div className="flex items-center justify-between">
        <button
          onClick={() => setCurrentRoute('my_crop_sales')}
          className="flex items-center gap-1.5 text-xs font-bold text-slate-700 hover:text-emerald-700"
        >
          <ArrowLeft className="w-4 h-4" /> Back to My Crop Sales
        </button>
        {selectedSale.status.toLowerCase() === 'active' && (
          <button
            onClick={() => {
              if (setSaleToEdit) setSaleToEdit(selectedSale);
              setCurrentRoute('sell_crop');
            }}
            className="flex items-center gap-1 px-3 py-1.5 bg-white border border-slate-300 hover:border-emerald-600 text-slate-700 hover:text-emerald-700 text-xs font-bold rounded-lg transition"
          >
            <Edit className="w-3.5 h-3.5" /> Edit
          </button>
        )}
      </div>

      {/* Hero Image */}
      <div className="relative rounded-2xl overflow-hidden border border-slate-200 shadow-sm">
        <img
          src={selectedSale.image}
          alt={selectedSale.cropName}
          className="w-full h-52 object-cover"
        />
        <div className="absolute top-3 right-3">
          <span
            className={`text-xs font-bold px-3 py-1 rounded-full shadow-sm ${
              selectedSale.status.toLowerCase() === 'active'
                ? 'bg-emerald-600 text-white'
                : selectedSale.status.toLowerCase() === 'sold'
                ? 'bg-blue-600 text-white'
                : 'bg-slate-700 text-white'
            }`}
          >
            {selectedSale.status}
          </span>
        </div>
      </div>

      {/* Title & Variety */}
      <div className="space-y-1">
        <h2 className="text-2xl font-black text-slate-900">{selectedSale.cropName}</h2>
        <p className="text-sm font-medium text-slate-500">
          {selectedSale.variety || 'Standard Agricultural Variety'}
        </p>
      </div>

      {/* Pricing Banner */}
      <div className="bg-gradient-to-r from-emerald-800 to-emerald-700 text-white p-4 rounded-2xl shadow-sm flex items-center justify-between">
        <div>
          <p className="text-xs text-emerald-100">Expected Sale Price</p>
          <p className="text-2xl font-black">
            ₹{selectedSale.price}{' '}
            <span className="text-xs font-normal text-emerald-200">
              per {selectedSale.unit || 'kg'}
            </span>
          </p>
        </div>
        <div className="text-right">
          <p className="text-xs text-emerald-100">Total Estimated</p>
          <p className="text-xl font-bold">₹{totalVal.toLocaleString('en-IN')}</p>
        </div>
      </div>

      {/* Specifications */}
      <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm space-y-3">
        <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider">
          Listing Specifications
        </h3>
        <div className="grid grid-cols-2 sm:grid-cols-3 gap-3 text-xs">
          <div className="bg-slate-50 p-2.5 rounded-xl">
            <span className="text-slate-400 block text-[11px]">Available Quantity</span>
            <p className="font-bold text-slate-800 mt-0.5">
              {selectedSale.quantity} {selectedSale.unit}
            </p>
          </div>
          <div className="bg-slate-50 p-2.5 rounded-xl">
            <span className="text-slate-400 block text-[11px]">Harvest/Available Date</span>
            <p className="font-bold text-slate-800 mt-0.5">
              {selectedSale.availableDate || 'Immediate'}
            </p>
          </div>
          <div className="bg-slate-50 p-2.5 rounded-xl">
            <span className="text-slate-400 block text-[11px]">Village / Location</span>
            <p className="font-bold text-slate-800 mt-0.5">{selectedSale.location}</p>
          </div>
          <div className="bg-slate-50 p-2.5 rounded-xl">
            <span className="text-slate-400 block text-[11px]">Listing Status</span>
            <p className="font-bold text-emerald-700 mt-0.5">{selectedSale.status}</p>
          </div>
          <div className="bg-slate-50 p-2.5 rounded-xl">
            <span className="text-slate-400 block text-[11px]">Posted On</span>
            <p className="font-bold text-slate-800 mt-0.5">
              {selectedSale.postedDate || 'Recent'}
            </p>
          </div>
          <div className="bg-slate-50 p-2.5 rounded-xl">
            <span className="text-slate-400 block text-[11px]">Commission</span>
            <p className="font-bold text-emerald-700 mt-0.5">0% Direct to Farmer</p>
          </div>
        </div>
      </div>

      {/* Description */}
      {selectedSale.description && (
        <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm space-y-1.5">
          <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider">
            Farmer Description
          </h3>
          <p className="text-xs text-slate-700 leading-relaxed bg-slate-50 p-3 rounded-xl">
            {selectedSale.description}
          </p>
        </div>
      )}

      {/* Status Specific Actions */}
      <div className="space-y-2 pt-2">
        {selectedSale.status.toLowerCase() === 'active' && (
          <>
            <button
              onClick={handleMarkAsSold}
              className="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs py-3 rounded-xl flex items-center justify-center gap-2 shadow-sm transition"
            >
              <CheckCircle2 className="w-4 h-4" /> Mark as Sold
            </button>
            <div className="flex gap-2">
              <button
                onClick={() => {
                  if (setSaleToEdit) setSaleToEdit(selectedSale);
                  setCurrentRoute('sell_crop');
                }}
                className="flex-1 border border-slate-300 hover:bg-slate-50 text-slate-700 font-bold text-xs py-2.5 rounded-xl transition"
              >
                Edit Listing
              </button>
              <button
                onClick={handleCancelListing}
                className="flex-1 border border-red-200 bg-red-50 hover:bg-red-100 text-red-700 font-bold text-xs py-2.5 rounded-xl transition"
              >
                Cancel Listing
              </button>
            </div>
          </>
        )}

        {selectedSale.status.toLowerCase() === 'sold' && (
          <div className="bg-blue-50 border border-blue-200 rounded-xl p-3 text-center space-y-2">
            <p className="text-xs font-bold text-blue-900">
              This crop listing has been marked as Sold.
            </p>
            <button
              onClick={handleReactivate}
              className="text-xs text-blue-700 font-bold underline"
            >
              Re-list this Crop as Active
            </button>
          </div>
        )}

        {selectedSale.status.toLowerCase() === 'cancelled' && (
          <div className="bg-slate-100 border border-slate-200 rounded-xl p-3 text-center space-y-2">
            <p className="text-xs font-bold text-slate-700">
              This listing is currently Cancelled and hidden from active buyers.
            </p>
            <button
              onClick={handleReactivate}
              className="text-xs text-emerald-700 font-bold underline"
            >
              Re-activate Listing
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

// 9. Sell Farm Waste View
function FarmWasteView({ setCurrentRoute, showToast }: any) {
  const [wasteType, setWasteType] = useState('Wheat Straw');
  const [quantity, setQuantity] = useState('1000');
  const [price, setPrice] = useState('4');

  const handlePost = (e: React.FormEvent) => {
    e.preventDefault();
    showToast('Farm waste posted for sale successfully');
    setCurrentRoute('my_crop_sales');
  };

  return (
    <div className="p-4 space-y-4">
      <div className="bg-amber-50 border border-amber-200 rounded-xl p-3.5 flex items-center gap-3">
        <div className="w-10 h-10 rounded-full bg-amber-700 text-white flex items-center justify-center">
          <Trash2 className="w-5 h-5" />
        </div>
        <div>
          <h3 className="font-bold text-sm text-amber-950">Sell Farm Waste</h3>
          <p className="text-xs text-amber-800">Sell farm waste and earn extra money.</p>
        </div>
      </div>

      <div className="bg-white p-3 rounded-xl border border-slate-200">
        <p className="text-xs font-bold text-slate-700 mb-2">Farm waste can be used for:</p>
        <div className="flex flex-wrap gap-1.5 text-[10px] font-semibold text-emerald-800">
          {['Animal Feed', 'Compost', 'Biogas', 'Fuel', 'Mulching'].map((use) => (
            <span key={use} className="bg-emerald-100 px-2 py-1 rounded-full">
              {use}
            </span>
          ))}
        </div>
      </div>

      <form onSubmit={handlePost} className="bg-white p-4 rounded-xl border border-slate-200 space-y-3 shadow-sm">
        <div>
          <label className="text-xs font-bold text-slate-700">Waste Type</label>
          <select
            value={wasteType}
            onChange={(e) => setWasteType(e.target.value)}
            className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs"
          >
            <option>Wheat Straw</option>
            <option>Rice Straw</option>
            <option>Sugarcane Waste</option>
            <option>Maize Stalks</option>
            <option>Cotton Stalks</option>
            <option>Coconut Shells</option>
            <option>Other</option>
          </select>
        </div>
        <div className="grid grid-cols-2 gap-2">
          <div>
            <label className="text-xs font-bold text-slate-700">Quantity (kg)</label>
            <input
              type="number"
              value={quantity}
              onChange={(e) => setQuantity(e.target.value)}
              className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs"
            />
          </div>
          <div>
            <label className="text-xs font-bold text-slate-700">Price (₹/kg)</label>
            <input
              type="number"
              value={price}
              onChange={(e) => setPrice(e.target.value)}
              className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs"
            />
          </div>
        </div>
        <button
          type="submit"
          className="w-full bg-amber-700 hover:bg-amber-800 text-white font-bold text-xs py-2.5 rounded-lg"
        >
          Post for Sale
        </button>
      </form>
    </div>
  );
}

// 10. Labour View
function LabourView({ labourWorkers, labourRequests, setLabourRequests, showToast }: any) {
  const [activeScreen, setActiveScreen] = useState<'find' | 'details' | 'send' | 'requests' | 'request_details'>('find');
  const [selectedWorker, setSelectedWorker] = useState<any>(labourWorkers[0] || null);
  const [selectedRequest, setSelectedRequest] = useState<any>(null);

  // Filters for Find Labour
  const [searchQuery, setSearchQuery] = useState('');
  const [workFilter, setWorkFilter] = useState('All');
  const [availFilter, setAvailFilter] = useState('All');

  // Send Request Form State
  const [reqWork, setReqWork] = useState('Harvesting');
  const [reqDesc, setReqDesc] = useState('');
  const [reqDate, setReqDate] = useState('12 Sep 2026');
  const [reqWorkers, setReqWorkers] = useState('2');
  const [reqDuration, setReqDuration] = useState('Full Day (8 hrs)');
  const [reqLocation, setReqLocation] = useState('Baramati, Pune');
  const [reqNotes, setReqNotes] = useState('');

  // Filter for My Requests
  const [requestStatusFilter, setRequestStatusFilter] = useState('All');
  const [showCancelModal, setShowCancelModal] = useState<any>(null);

  const workTypes = ['All', 'Harvesting', 'Weeding', 'Sowing', 'Spraying', 'Tractor/operator', 'Farm labour', 'Other'];

  const filteredWorkers = labourWorkers.filter((w: any) => {
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const matchName = w.name.toLowerCase().includes(q);
      const matchWork = w.work.toLowerCase().includes(q);
      const matchLoc = (w.location || '').toLowerCase().includes(q);
      const matchSkills = (w.skills || []).some((s: string) => s.toLowerCase().includes(q));
      if (!matchName && !matchWork && !matchLoc && !matchSkills) return false;
    }
    if (workFilter !== 'All' && w.work.toLowerCase() !== workFilter.toLowerCase()) return false;
    if (availFilter !== 'All' && w.status.toLowerCase() !== availFilter.toLowerCase()) return false;
    return true;
  });

  const getDurationMultiplier = (dur: string) => {
    switch (dur) {
      case 'Half Day (4 hrs)': return 0.5;
      case '2 Days': return 2.0;
      case '3 Days': return 3.0;
      case '1 Week (7 Days)': return 7.0;
      default: return 1.0;
    }
  };

  const calculatedTotal = (selectedWorker?.dailyWage || 500) * (parseInt(reqWorkers) || 1) * getDurationMultiplier(reqDuration);

  const openSendRequest = (worker: any) => {
    setSelectedWorker(worker);
    setReqWork(worker.work);
    setReqDesc(`${worker.work} for farm plot`);
    setReqLocation(worker.location || 'Baramati, Pune');
    setActiveScreen('send');
  };

  const openWorkerDetails = (worker: any) => {
    setSelectedWorker(worker);
    setActiveScreen('details');
  };

  const handleSubmitRequest = (e: React.FormEvent) => {
    e.preventDefault();
    if (!reqDesc.trim()) {
      showToast('Please enter a description for the work');
      return;
    }
    const count = parseInt(reqWorkers);
    if (!count || count <= 0) {
      showToast('Please enter a valid number of workers (at least 1)');
      return;
    }

    const newReq = {
      id: 'lr_' + Date.now(),
      workerId: selectedWorker.id,
      workerName: selectedWorker.name,
      workerPhone: selectedWorker.phone || '+91 98765 43210',
      workerImage: selectedWorker.image,
      work: reqWork,
      cropDescription: reqDesc,
      date: reqDate,
      duration: reqDuration,
      workersNeeded: count,
      dailyWage: selectedWorker.dailyWage,
      totalAmount: calculatedTotal,
      status: 'Pending',
      location: reqLocation,
      notes: reqNotes,
      createdAt: 'Today',
    };

    setLabourRequests((prev: any) => [newReq, ...prev]);
    showToast(`Labour request sent to ${selectedWorker.name}!`);
    setActiveScreen('requests');
  };

  const handleCancelRequest = (reqId: string) => {
    setLabourRequests((prev: any) =>
      prev.map((r: any) => (r.id === reqId ? { ...r, status: 'Cancelled' } : r))
    );
    if (selectedRequest && selectedRequest.id === reqId) {
      setSelectedRequest((prev: any) => ({ ...prev, status: 'Cancelled' }));
    }
    setShowCancelModal(null);
    showToast('Labour request cancelled');
  };

  const filteredRequests = labourRequests.filter((r: any) => {
    if (requestStatusFilter === 'All') return true;
    if (requestStatusFilter === 'Pending') return r.status === 'Pending' || r.status === 'Requested';
    if (requestStatusFilter === 'Accepted') return r.status === 'Accepted';
    if (requestStatusFilter === 'Completed') return r.status === 'Completed' || r.status === 'Working';
    if (requestStatusFilter === 'Cancelled') return r.status === 'Cancelled' || r.status === 'Rejected';
    return r.status.toLowerCase() === requestStatusFilter.toLowerCase();
  });

  const activeRequestsCount = labourRequests.filter((r: any) => r.status === 'Pending' || r.status === 'Accepted' || r.status === 'Requested').length;

  return (
    <div className="p-4 space-y-4">
      {/* Top Tabs */}
      <div className="flex bg-slate-200 p-1 rounded-xl">
        <button
          onClick={() => setActiveScreen('find')}
          className={`flex-1 py-1.5 text-xs font-bold rounded-lg transition-all ${
            activeScreen === 'find' || activeScreen === 'details' || activeScreen === 'send'
              ? 'bg-white text-emerald-900 shadow-sm'
              : 'text-slate-600'
          }`}
        >
          Find Labour
        </button>
        <button
          onClick={() => setActiveScreen('requests')}
          className={`flex-1 py-1.5 text-xs font-bold rounded-lg transition-all ${
            activeScreen === 'requests' || activeScreen === 'request_details'
              ? 'bg-white text-emerald-900 shadow-sm'
              : 'text-slate-600'
          }`}
        >
          My Requests ({activeRequestsCount})
        </button>
      </div>

      {/* Screen 1: FIND LABOUR */}
      {activeScreen === 'find' && (
        <div className="space-y-3">
          {/* Banner */}
          <div className="bg-blue-50 border border-blue-200 p-3 rounded-xl flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-blue-600 text-white flex items-center justify-center shrink-0">
              <Users className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-bold text-xs text-blue-900">Find Farm Labour • शेतमजूर शोधा</h3>
              <p className="text-[11px] text-blue-700">Connect with local workers, tractor operators & harvesting crews.</p>
            </div>
          </div>

          {/* Search Bar */}
          <div className="relative">
            <Search className="w-4 h-4 text-slate-400 absolute left-3 top-3" />
            <input
              type="text"
              placeholder="Search by worker name, skill, or village..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-9 pr-8 py-2 bg-white border border-slate-200 rounded-xl text-xs text-slate-900 placeholder:text-slate-400 focus:outline-emerald-600"
            />
            {searchQuery && (
              <button onClick={() => setSearchQuery('')} className="absolute right-3 top-2.5 text-slate-400 text-xs">
                ✕
              </button>
            )}
          </div>

          {/* Work Type Filter Chips */}
          <div>
            <div className="flex justify-between items-center mb-1.5">
              <span className="text-xs font-bold text-slate-700">Work Type</span>
              {(workFilter !== 'All' || availFilter !== 'All' || searchQuery) && (
                <button
                  onClick={() => {
                    setWorkFilter('All');
                    setAvailFilter('All');
                    setSearchQuery('');
                  }}
                  className="text-[11px] font-bold text-emerald-700"
                >
                  Clear Filters
                </button>
              )}
            </div>
            <div className="flex gap-1.5 overflow-x-auto pb-1 text-xs">
              {workTypes.map((w) => (
                <button
                  key={w}
                  onClick={() => setWorkFilter(w)}
                  className={`px-3 py-1 rounded-full whitespace-nowrap font-medium transition-all ${
                    workFilter === w
                      ? 'bg-emerald-700 text-white font-bold'
                      : 'bg-white border border-slate-200 text-slate-600'
                  }`}
                >
                  {w}
                </button>
              ))}
            </div>
          </div>

          {/* Availability Filter */}
          <div className="flex items-center gap-2 text-xs">
            <span className="text-slate-500 font-medium">Availability:</span>
            {['All', 'Available', 'Booked'].map((status) => (
              <button
                key={status}
                onClick={() => setAvailFilter(status)}
                className={`px-2.5 py-0.5 rounded-md text-[11px] font-medium ${
                  availFilter === status
                    ? 'bg-emerald-100 text-emerald-800 font-bold border border-emerald-300'
                    : 'bg-slate-100 text-slate-600'
                }`}
              >
                {status}
              </button>
            ))}
          </div>

          {/* Worker Cards List */}
          <div className="space-y-3 pt-1">
            <div className="flex justify-between items-center">
              <span className="text-xs font-bold text-slate-800">
                Available Workers ({filteredWorkers.length})
              </span>
              <span className="text-[11px] text-slate-400">Verified profiles</span>
            </div>

            {filteredWorkers.length === 0 ? (
              <div className="bg-white p-8 rounded-xl border border-slate-200 text-center space-y-2">
                <Users className="w-10 h-10 text-slate-300 mx-auto" />
                <p className="font-bold text-xs text-slate-700">No workers found</p>
                <p className="text-[11px] text-slate-500">Try adjusting your search query or filters.</p>
                <button
                  onClick={() => {
                    setWorkFilter('All');
                    setAvailFilter('All');
                    setSearchQuery('');
                  }}
                  className="mt-2 text-xs font-bold text-emerald-700 underline"
                >
                  Reset Filters
                </button>
              </div>
            ) : (
              filteredWorkers.map((w: any) => (
                <div
                  key={w.id}
                  className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm space-y-3 hover:border-emerald-300 transition-all cursor-pointer"
                  onClick={() => openWorkerDetails(w)}
                >
                  <div className="flex items-start gap-3">
                    <div className="relative">
                      <img src={w.image} alt={w.name} className="w-14 h-14 rounded-full object-cover border border-slate-200" />
                      <span
                        className={`absolute bottom-0 right-0 w-3.5 h-3.5 rounded-full border-2 border-white ${
                          w.status === 'Available' ? 'bg-emerald-600' : 'bg-amber-500'
                        }`}
                      />
                    </div>
                    <div className="flex-1">
                      <div className="flex justify-between items-start">
                        <div>
                          <h3 className="font-bold text-sm text-slate-900">{w.name}</h3>
                          <div className="flex items-center gap-1.5 mt-0.5">
                            <span className="bg-emerald-100 text-emerald-800 text-[10px] font-bold px-2 py-0.5 rounded">
                              {w.work}
                            </span>
                            <span className="text-[11px] font-bold text-amber-600 flex items-center gap-0.5">
                              ★ {w.rating || 4.8}
                            </span>
                            <span className="text-[10px] text-slate-400">({w.reviewsCount || 24})</span>
                          </div>
                        </div>
                        <span
                          className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                            w.status === 'Available' ? 'bg-emerald-100 text-emerald-800' : 'bg-amber-100 text-amber-800'
                          }`}
                        >
                          {w.status}
                        </span>
                      </div>

                      <div className="text-[11px] text-slate-500 mt-2 space-y-0.5">
                        <p className="flex items-center gap-1">
                          <MapPin className="w-3 h-3 text-slate-400 shrink-0" />
                          <span>{w.location || 'Pune'} • {w.distance}</span>
                        </p>
                        <p className="flex items-center gap-1">
                          <Clock className="w-3 h-3 text-slate-400 shrink-0" />
                          <span>{w.experience} exp • {w.completedJobs || 30} jobs done</span>
                        </p>
                      </div>
                    </div>
                  </div>

                  <div className="pt-2 border-t border-slate-100 flex items-center justify-between">
                    <div>
                      <span className="text-[10px] text-slate-400 block">Daily Rate</span>
                      <div className="flex items-baseline gap-1">
                        <span className="text-base font-extrabold text-slate-900">₹{w.dailyWage}</span>
                        <span className="text-[10px] text-slate-500">/ day (₹{w.hourlyRate || 70}/hr)</span>
                      </div>
                    </div>

                    <div className="flex gap-2">
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          openWorkerDetails(w);
                        }}
                        className="border border-emerald-600 text-emerald-700 text-xs font-bold px-3 py-1.5 rounded-lg hover:bg-emerald-50"
                      >
                        Details
                      </button>
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          openSendRequest(w);
                        }}
                        className="bg-emerald-700 text-white text-xs font-bold px-3.5 py-1.5 rounded-lg hover:bg-emerald-800 shadow-sm"
                      >
                        Hire Now
                      </button>
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
      )}

      {/* Screen 2: LABOUR DETAILS */}
      {activeScreen === 'details' && selectedWorker && (
        <div className="space-y-4">
          <div className="flex items-center gap-2">
            <button
              onClick={() => setActiveScreen('find')}
              className="p-1.5 rounded-lg border border-slate-200 text-slate-600 hover:bg-slate-100"
            >
              <ArrowLeft className="w-4 h-4" />
            </button>
            <h2 className="font-bold text-sm text-slate-900">Worker Profile</h2>
          </div>

          {/* Profile Card */}
          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm space-y-4">
            <div className="flex items-start gap-3.5">
              <img src={selectedWorker.image} alt={selectedWorker.name} className="w-16 h-16 rounded-full object-cover border-2 border-emerald-600" />
              <div className="flex-1">
                <div className="flex justify-between items-start">
                  <div>
                    <h3 className="font-bold text-base text-slate-900">{selectedWorker.name}</h3>
                    <p className="text-xs font-bold text-emerald-700">{selectedWorker.work}</p>
                  </div>
                  <span
                    className={`text-[10px] font-bold px-2.5 py-0.5 rounded-full ${
                      selectedWorker.status === 'Available' ? 'bg-emerald-100 text-emerald-800' : 'bg-amber-100 text-amber-800'
                    }`}
                  >
                    {selectedWorker.status}
                  </span>
                </div>
                <div className="flex items-center gap-1.5 mt-1 text-xs text-slate-600">
                  <span className="text-amber-500 font-bold">★ {selectedWorker.rating || 4.9}</span>
                  <span>({selectedWorker.reviewsCount || 34} reviews)</span>
                  <span>•</span>
                  <span>{selectedWorker.location}</span>
                </div>
              </div>
            </div>

            {/* Quick Stats Grid */}
            <div className="grid grid-cols-4 gap-2 pt-2 border-t border-slate-100 text-center">
              <div className="bg-slate-50 p-2 rounded-lg">
                <span className="text-[10px] text-slate-400 block">Daily</span>
                <span className="font-extrabold text-xs text-emerald-700">₹{selectedWorker.dailyWage}</span>
              </div>
              <div className="bg-slate-50 p-2 rounded-lg">
                <span className="text-[10px] text-slate-400 block">Hourly</span>
                <span className="font-bold text-xs text-slate-800">₹{selectedWorker.hourlyRate || 70}</span>
              </div>
              <div className="bg-slate-50 p-2 rounded-lg">
                <span className="text-[10px] text-slate-400 block">Experience</span>
                <span className="font-bold text-xs text-slate-800">{selectedWorker.experience}</span>
              </div>
              <div className="bg-slate-50 p-2 rounded-lg">
                <span className="text-[10px] text-slate-400 block">Jobs Done</span>
                <span className="font-bold text-xs text-blue-700">{selectedWorker.completedJobs || 45}</span>
              </div>
            </div>

            {/* Availability message */}
            <div className="bg-emerald-50 p-3 rounded-lg border border-emerald-100 flex items-center gap-2 text-xs text-emerald-900">
              <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
              <span>
                {selectedWorker.status === 'Available'
                  ? 'Available for direct hire. Flexible scheduling for full day or half day.'
                  : 'Currently on a farm assignment. You can still send a request for future dates.'}
              </span>
            </div>

            {/* Skills */}
            <div>
              <h4 className="text-xs font-bold text-slate-800 mb-2">Agricultural Skills & Tools</h4>
              <div className="flex flex-wrap gap-1.5">
                {(selectedWorker.skills || [selectedWorker.work, 'Field Preparation', 'Harvesting']).map((skill: string) => (
                  <span key={skill} className="bg-slate-100 text-slate-700 text-[11px] font-semibold px-2.5 py-1 rounded-md">
                    ✓ {skill}
                  </span>
                ))}
              </div>
            </div>

            {/* About */}
            <div>
              <h4 className="text-xs font-bold text-slate-800 mb-1">About Worker</h4>
              <p className="text-xs text-slate-600 leading-relaxed">
                {selectedWorker.about ||
                  'Experienced agricultural worker with hands-on expertise in soil preparation, transplantation, weeding, and post-harvest handling.'}
              </p>
            </div>

            {/* Direct Connection Note */}
            <div className="bg-amber-50 border border-amber-200 p-3 rounded-lg text-[11px] text-amber-900 flex items-start gap-2">
              <ShieldCheck className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
              <span>Direct farmer-to-worker agreement. Zero commissions. Wages are paid directly to workers on task completion.</span>
            </div>

            {/* Hire Button */}
            <button
              onClick={() => openSendRequest(selectedWorker)}
              className="w-full bg-emerald-700 hover:bg-emerald-800 text-white font-bold text-sm py-2.5 rounded-xl shadow-md transition-all"
            >
              Hire / Send Labour Request (₹{selectedWorker.dailyWage}/day)
            </button>
          </div>
        </div>
      )}

      {/* Screen 3: SEND LABOUR REQUEST FORM */}
      {activeScreen === 'send' && selectedWorker && (
        <div className="space-y-4">
          <div className="flex items-center gap-2">
            <button
              onClick={() => setActiveScreen('details')}
              className="p-1.5 rounded-lg border border-slate-200 text-slate-600 hover:bg-slate-100"
            >
              <ArrowLeft className="w-4 h-4" />
            </button>
            <h2 className="font-bold text-sm text-slate-900">Send Labour Request</h2>
          </div>

          {/* Selected Worker Info Summary */}
          <div className="bg-white p-3.5 rounded-xl border border-slate-200 flex items-center gap-3">
            <img src={selectedWorker.image} alt={selectedWorker.name} className="w-12 h-12 rounded-full object-cover" />
            <div>
              <h3 className="font-bold text-xs text-slate-900">{selectedWorker.name}</h3>
              <p className="text-[11px] text-slate-500">{selectedWorker.work} • {selectedWorker.location}</p>
              <p className="text-[11px] font-bold text-emerald-700">₹{selectedWorker.dailyWage}/day per worker</p>
            </div>
          </div>

          {/* Request Form */}
          <form onSubmit={handleSubmitRequest} className="bg-white p-4 rounded-xl border border-slate-200 space-y-3 shadow-sm">
            <div>
              <label className="text-xs font-bold text-slate-700">Required Work Type *</label>
              <select
                value={reqWork}
                onChange={(e) => setReqWork(e.target.value)}
                className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:outline-emerald-600"
              >
                {['Harvesting', 'Weeding', 'Sowing', 'Spraying', 'Tractor/operator', 'Farm labour', 'Planting', 'Other'].map((w) => (
                  <option key={w} value={w}>{w}</option>
                ))}
              </select>
            </div>

            <div>
              <label className="text-xs font-bold text-slate-700">Crop / Work Description *</label>
              <textarea
                rows={2}
                value={reqDesc}
                onChange={(e) => setReqDesc(e.target.value)}
                placeholder="e.g. Tomato harvesting in 2-acre field, sorting into crates..."
                className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:outline-emerald-600"
              />
            </div>

            <div className="grid grid-cols-2 gap-2">
              <div>
                <label className="text-xs font-bold text-slate-700">Required Date *</label>
                <input
                  type="text"
                  value={reqDate}
                  onChange={(e) => setReqDate(e.target.value)}
                  placeholder="e.g. 12 Sep 2026"
                  className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:outline-emerald-600"
                />
              </div>

              <div>
                <label className="text-xs font-bold text-slate-700">Workers Needed *</label>
                <input
                  type="number"
                  min="1"
                  max="50"
                  value={reqWorkers}
                  onChange={(e) => setReqWorkers(e.target.value)}
                  className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:outline-emerald-600"
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-2">
              <div>
                <label className="text-xs font-bold text-slate-700">Working Duration *</label>
                <select
                  value={reqDuration}
                  onChange={(e) => setReqDuration(e.target.value)}
                  className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:outline-emerald-600"
                >
                  <option>Full Day (8 hrs)</option>
                  <option>Half Day (4 hrs)</option>
                  <option>2 Days</option>
                  <option>3 Days</option>
                  <option>1 Week (7 Days)</option>
                </select>
              </div>

              <div>
                <label className="text-xs font-bold text-slate-700">Farm Location *</label>
                <input
                  type="text"
                  value={reqLocation}
                  onChange={(e) => setReqLocation(e.target.value)}
                  placeholder="e.g. Baramati, Pune"
                  className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:outline-emerald-600"
                />
              </div>
            </div>

            <div>
              <label className="text-xs font-bold text-slate-700">Special Notes (Optional)</label>
              <input
                type="text"
                value={reqNotes}
                onChange={(e) => setReqNotes(e.target.value)}
                placeholder="e.g. Start at 7 AM, crates will be provided..."
                className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:outline-emerald-600"
              />
            </div>

            {/* Estimated Total Card */}
            <div className="bg-emerald-50 border border-emerald-200 p-3 rounded-lg flex justify-between items-center">
              <div>
                <span className="text-[11px] text-emerald-800 block">Estimated Total Wage</span>
                <span className="text-[10px] text-slate-500">
                  (₹{selectedWorker.dailyWage} × {reqWorkers || 1} worker{parseInt(reqWorkers) > 1 ? 's' : ''} × {reqDuration})
                </span>
              </div>
              <span className="text-lg font-black text-emerald-800">₹{calculatedTotal}</span>
            </div>

            <button
              type="submit"
              className="w-full bg-emerald-700 hover:bg-emerald-800 text-white font-bold text-xs py-2.5 rounded-lg shadow-sm"
            >
              Send Labour Request
            </button>
          </form>
        </div>
      )}

      {/* Screen 4: MY REQUESTS */}
      {activeScreen === 'requests' && (
        <div className="space-y-3">
          {/* Status Tabs */}
          <div className="flex gap-1.5 overflow-x-auto pb-1 text-xs">
            {['All', 'Pending', 'Accepted', 'Completed', 'Cancelled'].map((status) => {
              const count = labourRequests.filter((r: any) => {
                if (status === 'All') return true;
                if (status === 'Pending') return r.status === 'Pending' || r.status === 'Requested';
                if (status === 'Accepted') return r.status === 'Accepted';
                if (status === 'Completed') return r.status === 'Completed' || r.status === 'Working';
                if (status === 'Cancelled') return r.status === 'Cancelled' || r.status === 'Rejected';
                return r.status.toLowerCase() === status.toLowerCase();
              }).length;

              return (
                <button
                  key={status}
                  onClick={() => setRequestStatusFilter(status)}
                  className={`px-3 py-1 rounded-full whitespace-nowrap font-medium transition-all ${
                    requestStatusFilter === status
                      ? 'bg-emerald-700 text-white font-bold'
                      : 'bg-white border border-slate-200 text-slate-600'
                  }`}
                >
                  {status} ({count})
                </button>
              );
            })}
          </div>

          {filteredRequests.length === 0 ? (
            <div className="bg-white p-8 rounded-xl border border-slate-200 text-center space-y-2">
              <Users className="w-10 h-10 text-slate-300 mx-auto" />
              <p className="font-bold text-xs text-slate-700">No {requestStatusFilter} requests</p>
              <p className="text-[11px] text-slate-500">You do not have any requests matching this status.</p>
              <button
                onClick={() => setActiveScreen('find')}
                className="mt-2 bg-emerald-700 text-white text-xs font-bold px-3.5 py-1.5 rounded-lg"
              >
                Find Labour
              </button>
            </div>
          ) : (
            filteredRequests.map((req: any) => (
              <div
                key={req.id}
                className="bg-white p-3.5 rounded-xl border border-slate-200 space-y-2.5 shadow-sm hover:border-emerald-300 transition-all cursor-pointer"
                onClick={() => {
                  setSelectedRequest(req);
                  setActiveScreen('request_details');
                }}
              >
                <div className="flex justify-between items-start">
                  <div className="flex items-center gap-2.5">
                    {req.workerImage ? (
                      <img src={req.workerImage} alt={req.workerName} className="w-9 h-9 rounded-full object-cover border border-slate-200" />
                    ) : (
                      <div className="w-9 h-9 rounded-full bg-emerald-100 text-emerald-800 font-bold flex items-center justify-center text-xs">
                        {req.workerName?.[0] || 'W'}
                      </div>
                    )}
                    <div>
                      <h3 className="font-bold text-sm text-slate-900">{req.workerName}</h3>
                      <span className="text-xs font-semibold text-emerald-700">{req.work}</span>
                    </div>
                  </div>

                  <span
                    className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                      req.status === 'Accepted'
                        ? 'bg-emerald-100 text-emerald-800'
                        : req.status === 'Pending' || req.status === 'Requested'
                        ? 'bg-amber-100 text-amber-800'
                        : req.status === 'Completed' || req.status === 'Working'
                        ? 'bg-blue-100 text-blue-800'
                        : 'bg-rose-100 text-rose-800'
                    }`}
                  >
                    {req.status}
                  </span>
                </div>

                {req.cropDescription && (
                  <p className="text-xs text-slate-600 line-clamp-1">{req.cropDescription}</p>
                )}

                <div className="bg-slate-50 p-2 rounded-lg flex justify-between text-[11px] text-slate-600">
                  <span className="flex items-center gap-1">
                    <Calendar className="w-3 h-3 text-slate-400" /> {req.date} ({req.duration || 'Full Day'})
                  </span>
                  <span className="flex items-center gap-1 font-semibold">
                    <Users className="w-3 h-3 text-slate-400" /> {req.workersNeeded} workers
                  </span>
                </div>

                <div className="flex justify-between items-center pt-1">
                  <div>
                    <span className="text-[10px] text-slate-400 block">Total Amount</span>
                    <span className="text-sm font-extrabold text-slate-900">
                      ₹{req.totalAmount || (req.dailyWage || 500) * (req.workersNeeded || 1)}
                    </span>
                  </div>

                  <div className="flex gap-2">
                    {(req.status === 'Pending' || req.status === 'Requested') && (
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          setShowCancelModal(req);
                        }}
                        className="border border-rose-400 text-rose-600 text-xs font-bold px-2.5 py-1 rounded-lg hover:bg-rose-50"
                      >
                        Cancel
                      </button>
                    )}
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        setSelectedRequest(req);
                        setActiveScreen('request_details');
                      }}
                      className="bg-emerald-50 text-emerald-800 text-xs font-bold px-2.5 py-1 rounded-lg border border-emerald-200"
                    >
                      View Details
                    </button>
                  </div>
                </div>
              </div>
            ))
          )}
        </div>
      )}

      {/* Screen 5: REQUEST DETAILS */}
      {activeScreen === 'request_details' && selectedRequest && (
        <div className="space-y-4">
          <div className="flex items-center gap-2">
            <button
              onClick={() => setActiveScreen('requests')}
              className="p-1.5 rounded-lg border border-slate-200 text-slate-600 hover:bg-slate-100"
            >
              <ArrowLeft className="w-4 h-4" />
            </button>
            <h2 className="font-bold text-sm text-slate-900">Labour Request Details</h2>
          </div>

          {/* Status Alert Banner */}
          <div
            className={`p-3.5 rounded-xl border flex items-start gap-3 ${
              selectedRequest.status === 'Accepted'
                ? 'bg-emerald-50 border-emerald-200 text-emerald-900'
                : selectedRequest.status === 'Pending' || selectedRequest.status === 'Requested'
                ? 'bg-amber-50 border-amber-200 text-amber-900'
                : selectedRequest.status === 'Completed' || selectedRequest.status === 'Working'
                ? 'bg-blue-50 border-blue-200 text-blue-900'
                : 'bg-rose-50 border-rose-200 text-rose-900'
            }`}
          >
            <CheckCircle2 className="w-5 h-5 shrink-0 mt-0.5" />
            <div>
              <h4 className="font-bold text-xs">
                {selectedRequest.status === 'Accepted' && 'Request Accepted by Worker'}
                {(selectedRequest.status === 'Pending' || selectedRequest.status === 'Requested') && 'Request Pending Worker Confirmation'}
                {(selectedRequest.status === 'Completed' || selectedRequest.status === 'Working') && 'Work Completed Successfully'}
                {selectedRequest.status === 'Cancelled' && 'Request Cancelled'}
              </h4>
              <p className="text-[11px] opacity-90 mt-0.5">
                {selectedRequest.status === 'Accepted' && 'The worker has accepted your request. Please ensure the farm plot is ready on the date.'}
                {(selectedRequest.status === 'Pending' || selectedRequest.status === 'Requested') && 'Waiting for worker confirmation. You can cancel if plans change.'}
                {(selectedRequest.status === 'Completed' || selectedRequest.status === 'Working') && 'Farm operation has been marked complete.'}
                {selectedRequest.status === 'Cancelled' && 'This request was cancelled by the farmer.'}
              </p>
            </div>
          </div>

          {/* Worker Info Card */}
          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm space-y-3">
            <h3 className="text-xs font-bold text-slate-500 uppercase tracking-wider">Assigned Worker</h3>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                {selectedRequest.workerImage ? (
                  <img src={selectedRequest.workerImage} alt={selectedRequest.workerName} className="w-12 h-12 rounded-full object-cover" />
                ) : (
                  <div className="w-12 h-12 rounded-full bg-emerald-100 text-emerald-800 font-bold flex items-center justify-center text-sm">
                    {selectedRequest.workerName?.[0] || 'W'}
                  </div>
                )}
                <div>
                  <h4 className="font-bold text-sm text-slate-900">{selectedRequest.workerName}</h4>
                  <p className="text-xs text-slate-500">Skill: {selectedRequest.work}</p>
                  <p className="text-xs font-bold text-emerald-700">₹{selectedRequest.dailyWage}/day</p>
                </div>
              </div>
            </div>

            {selectedRequest.status === 'Accepted' && (
              <div className="pt-2 border-t border-slate-100 flex justify-between items-center">
                <span className="text-xs text-slate-600 font-medium">Contact: {selectedRequest.workerPhone || '+91 98765 43210'}</span>
                <button
                  onClick={() => showToast(`Calling ${selectedRequest.workerName}...`)}
                  className="bg-emerald-700 text-white text-xs font-bold px-3 py-1 rounded-lg flex items-center gap-1.5"
                >
                  <Phone className="w-3 h-3" /> Call
                </button>
              </div>
            )}
          </div>

          {/* Specifications Card */}
          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm space-y-2.5 text-xs">
            <h3 className="text-xs font-bold text-slate-500 uppercase tracking-wider mb-1">Work Specifications</h3>
            <div className="flex justify-between py-1 border-b border-slate-100">
              <span className="text-slate-500">Work Type</span>
              <span className="font-bold text-slate-800">{selectedRequest.work}</span>
            </div>
            {selectedRequest.cropDescription && (
              <div className="flex justify-between py-1 border-b border-slate-100">
                <span className="text-slate-500">Description</span>
                <span className="font-semibold text-slate-800 text-right max-w-[60%]">{selectedRequest.cropDescription}</span>
              </div>
            )}
            <div className="flex justify-between py-1 border-b border-slate-100">
              <span className="text-slate-500">Date</span>
              <span className="font-bold text-slate-800">{selectedRequest.date}</span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-100">
              <span className="text-slate-500">Duration</span>
              <span className="font-bold text-slate-800">{selectedRequest.duration || 'Full Day (8 hrs)'}</span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-100">
              <span className="text-slate-500">Workers Count</span>
              <span className="font-bold text-slate-800">{selectedRequest.workersNeeded} Workers</span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-100">
              <span className="text-slate-500">Location</span>
              <span className="font-bold text-slate-800">{selectedRequest.location || 'Baramati, Pune'}</span>
            </div>
            {selectedRequest.notes && (
              <div className="flex justify-between py-1 border-b border-slate-100">
                <span className="text-slate-500">Special Notes</span>
                <span className="font-semibold text-slate-800 text-right max-w-[60%]">{selectedRequest.notes}</span>
              </div>
            )}
          </div>

          {/* Wage Breakdown */}
          <div className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm space-y-2">
            <h3 className="text-xs font-bold text-slate-500 uppercase tracking-wider mb-1">Wage Breakdown</h3>
            <div className="flex justify-between text-xs text-slate-600">
              <span>Daily Rate per worker</span>
              <span>₹{selectedRequest.dailyWage}</span>
            </div>
            <div className="flex justify-between text-xs text-slate-600">
              <span>Workers count</span>
              <span>× {selectedRequest.workersNeeded}</span>
            </div>
            <div className="pt-2 border-t border-slate-200 flex justify-between items-center">
              <span className="font-bold text-xs text-slate-800">Total Estimated Wage</span>
              <span className="font-black text-base text-emerald-700">
                ₹{selectedRequest.totalAmount || (selectedRequest.dailyWage || 500) * (selectedRequest.workersNeeded || 1)}
              </span>
            </div>
          </div>

          {/* Cancel button if pending */}
          {(selectedRequest.status === 'Pending' || selectedRequest.status === 'Requested') && (
            <button
              onClick={() => setShowCancelModal(selectedRequest)}
              className="w-full border border-rose-500 text-rose-600 hover:bg-rose-50 font-bold text-xs py-2.5 rounded-xl"
            >
              Cancel Labour Request
            </button>
          )}
        </div>
      )}

      {/* Cancel Confirmation Modal */}
      {showCancelModal && (
        <div className="fixed inset-0 bg-black/40 backdrop-blur-xs flex items-center justify-center p-4 z-50">
          <div className="bg-white p-5 rounded-2xl max-w-sm w-full space-y-3 shadow-xl">
            <div className="flex items-center gap-2.5 text-rose-600">
              <AlertTriangle className="w-5 h-5" />
              <h3 className="font-bold text-sm">Cancel Labour Request?</h3>
            </div>
            <p className="text-xs text-slate-600 leading-relaxed">
              Are you sure you want to cancel the request to <strong>{showCancelModal.workerName}</strong> for{' '}
              <strong>{showCancelModal.work}</strong> on {showCancelModal.date}?
            </p>
            <div className="flex justify-end gap-2 pt-2">
              <button
                onClick={() => setShowCancelModal(null)}
                className="px-3.5 py-1.5 rounded-lg border border-slate-300 text-xs font-bold text-slate-600 hover:bg-slate-50"
              >
                Keep Request
              </button>
              <button
                onClick={() => handleCancelRequest(showCancelModal.id)}
                className="px-3.5 py-1.5 rounded-lg bg-rose-600 text-white text-xs font-bold hover:bg-rose-700"
              >
                Yes, Cancel
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

// 11. Farm Products View
function ProductsView({ products, cart, setCart, setCurrentRoute, setSelectedProduct, showToast }: any) {
  const [activeCategory, setActiveCategory] = useState('All');
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedLocation, setSelectedLocation] = useState('All');
  const [selectedSort, setSelectedSort] = useState('Featured');
  const [onlyInStock, setOnlyInStock] = useState(false);

  const categories = [
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

  const locations = ['All', 'Pune', 'Baramati'];

  const filtered = products.filter((p: any) => {
    const matchesCat = activeCategory === 'All' || p.category === activeCategory;
    const matchesLoc = selectedLocation === 'All' || (p.sellerLocation || p.location) === selectedLocation;
    const matchesStock = !onlyInStock || (p.availableQuantity > 0 && p.status !== 'Out of Stock');
    const query = searchQuery.toLowerCase().trim();
    const matchesQuery =
      !query ||
      p.name.toLowerCase().includes(query) ||
      p.category.toLowerCase().includes(query) ||
      (p.sellerName || p.seller || '').toLowerCase().includes(query) ||
      (p.description || '').toLowerCase().includes(query);

    return matchesCat && matchesLoc && matchesStock && matchesQuery;
  });

  const sorted = [...filtered].sort((a: any, b: any) => {
    if (selectedSort === 'Price: Low to High') return a.price - b.price;
    if (selectedSort === 'Price: High to Low') return b.price - a.price;
    if (selectedSort === 'Top Rated') return (b.rating || 0) - (a.rating || 0);
    if (selectedSort === 'Name: A-Z') return a.name.localeCompare(b.name);
    return 0; // Featured
  });

  const addToCart = (product: any, qty = 1) => {
    const maxStock = typeof product.availableQuantity === 'number' ? product.availableQuantity : 99;
    if (product.status === 'Out of Stock' || maxStock <= 0) {
      showToast('Item is currently out of stock');
      return;
    }

    setCart((prev: any) => {
      const exists = prev.find((item: any) => item.product.id === product.id);
      if (exists) {
        const newQty = Math.min(exists.quantity + qty, maxStock);
        return prev.map((item: any) =>
          item.product.id === product.id ? { ...item, quantity: newQty } : item
        );
      }
      return [...prev, { product, quantity: Math.min(qty, maxStock) }];
    });
    showToast(`Added ${qty} x ${product.name} to cart`);
  };

  const totalCartCount = cart.reduce((sum: number, item: any) => sum + item.quantity, 0);

  return (
    <div className="p-4 space-y-4">
      {/* Header with Cart Button */}
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-lg font-black text-slate-800">Buy Farm Products</h2>
          <p className="text-xs text-slate-500">Quality seeds, fertilizers, tools & irrigation equipment</p>
        </div>
        <button
          onClick={() => setCurrentRoute('cart')}
          className="relative p-2.5 bg-white rounded-xl border border-slate-200 text-slate-700 hover:border-emerald-500 shadow-sm flex items-center gap-1.5 transition-all"
        >
          <ShoppingCart className="w-5 h-5 text-emerald-700" />
          {totalCartCount > 0 && (
            <span className="bg-emerald-600 text-white rounded-full px-1.5 py-0.2 text-[11px] font-black">
              {totalCartCount}
            </span>
          )}
        </button>
      </div>

      {/* Search Bar */}
      <div className="relative">
        <Search className="w-4 h-4 text-slate-400 absolute left-3 top-3" />
        <input
          type="text"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          placeholder="Search seeds, fertilizer, sprayers, pipes..."
          className="w-full bg-white border border-slate-200 rounded-xl pl-9 pr-8 py-2.5 text-xs text-slate-800 placeholder:text-slate-400 focus:outline-none focus:border-emerald-600 shadow-sm"
        />
        {searchQuery && (
          <button
            onClick={() => setSearchQuery('')}
            className="absolute right-3 top-2.5 text-slate-400 hover:text-slate-600 text-xs font-bold"
          >
            ✕
          </button>
        )}
      </div>

      {/* Category Horizontal Filter */}
      <div className="space-y-1">
        <div className="flex gap-1.5 overflow-x-auto pb-1 text-xs no-scrollbar">
          {categories.map((cat) => (
            <button
              key={cat}
              onClick={() => setActiveCategory(cat)}
              className={`px-3 py-1.5 rounded-full whitespace-nowrap font-bold text-xs transition-all ${
                activeCategory === cat
                  ? 'bg-emerald-700 text-white shadow-sm'
                  : 'bg-white border border-slate-200 text-slate-600 hover:bg-slate-50'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>
      </div>

      {/* Secondary Controls: Location & Sort & Stock Filter */}
      <div className="flex flex-wrap items-center justify-between gap-2 text-xs bg-slate-50 p-2.5 rounded-xl border border-slate-200">
        <div className="flex items-center gap-2">
          <span className="text-slate-500 font-semibold">Location:</span>
          <select
            value={selectedLocation}
            onChange={(e) => setSelectedLocation(e.target.value)}
            className="bg-white border border-slate-200 rounded-lg px-2 py-1 text-slate-700 font-medium text-xs focus:outline-none"
          >
            {locations.map((loc) => (
              <option key={loc} value={loc}>
                {loc === 'All' ? 'All Locations' : loc}
              </option>
            ))}
          </select>
        </div>

        <div className="flex items-center gap-2">
          <span className="text-slate-500 font-semibold">Sort:</span>
          <select
            value={selectedSort}
            onChange={(e) => setSelectedSort(e.target.value)}
            className="bg-white border border-slate-200 rounded-lg px-2 py-1 text-slate-700 font-medium text-xs focus:outline-none"
          >
            <option value="Featured">Featured</option>
            <option value="Price: Low to High">Price: Low to High</option>
            <option value="Price: High to Low">Price: High to Low</option>
            <option value="Top Rated">Top Rated</option>
            <option value="Name: A-Z">Name: A-Z</option>
          </select>
        </div>

        <button
          onClick={() => setOnlyInStock(!onlyInStock)}
          className={`px-2.5 py-1 rounded-lg border text-xs font-semibold flex items-center gap-1 transition-all ${
            onlyInStock
              ? 'bg-emerald-50 border-emerald-500 text-emerald-800'
              : 'bg-white border-slate-200 text-slate-600'
          }`}
        >
          <span className={`w-2 h-2 rounded-full ${onlyInStock ? 'bg-emerald-600' : 'bg-slate-300'}`} />
          In Stock Only
        </button>
      </div>

      {/* Result Count */}
      <div className="flex justify-between items-center text-xs text-slate-500 px-1">
        <span>Showing <strong className="text-slate-800">{sorted.length}</strong> products</span>
        {(searchQuery || activeCategory !== 'All' || selectedLocation !== 'All' || onlyInStock) && (
          <button
            onClick={() => {
              setSearchQuery('');
              setActiveCategory('All');
              setSelectedLocation('All');
              setOnlyInStock(false);
            }}
            className="text-emerald-700 font-bold hover:underline"
          >
            Reset Filters
          </button>
        )}
      </div>

      {/* Product Grid */}
      {sorted.length === 0 ? (
        <div className="bg-white rounded-2xl border border-dashed border-slate-200 p-8 text-center space-y-2">
          <Package className="w-10 h-10 text-slate-300 mx-auto" />
          <p className="font-bold text-sm text-slate-700">No products found</p>
          <p className="text-xs text-slate-400">Try adjusting your filters or search keywords.</p>
        </div>
      ) : (
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3.5">
          {sorted.map((prod: any) => {
            const isOutOfStock = prod.status === 'Out of Stock' || prod.availableQuantity <= 0;
            const isLimited = prod.status === 'Limited Stock' || (prod.availableQuantity <= 25 && !isOutOfStock);

            return (
              <div
                key={prod.id}
                className="bg-white rounded-xl border border-slate-200 overflow-hidden shadow-sm hover:shadow-md transition-all flex flex-col justify-between group"
              >
                {/* Product Image & Badges */}
                <div
                  className="relative cursor-pointer overflow-hidden bg-slate-100"
                  onClick={() => {
                    setSelectedProduct(prod);
                    setCurrentRoute('product_details');
                  }}
                >
                  <img
                    src={prod.image}
                    alt={prod.name}
                    className="w-full h-32 object-cover group-hover:scale-105 transition-transform duration-300"
                  />
                  <div className="absolute top-2 left-2 flex flex-col gap-1">
                    <span className="text-[10px] font-black px-2 py-0.5 rounded-md bg-black/75 text-white backdrop-blur-xs">
                      {prod.category}
                    </span>
                  </div>
                  <div className="absolute top-2 right-2">
                    <span
                      className={`text-[9px] font-black px-1.5 py-0.5 rounded shadow-xs ${
                        isOutOfStock
                          ? 'bg-red-500 text-white'
                          : isLimited
                          ? 'bg-orange-500 text-white'
                          : 'bg-emerald-600 text-white'
                      }`}
                    >
                      {prod.status || (isOutOfStock ? 'Out of Stock' : 'In Stock')}
                    </span>
                  </div>
                </div>

                {/* Product Info */}
                <div className="p-3 flex-1 flex flex-col justify-between">
                  <div
                    className="cursor-pointer"
                    onClick={() => {
                      setSelectedProduct(prod);
                      setCurrentRoute('product_details');
                    }}
                  >
                    <h4 className="font-bold text-xs text-slate-900 line-clamp-2 leading-snug group-hover:text-emerald-700 transition-colors">
                      {prod.name}
                    </h4>

                    {/* Price & Unit */}
                    <div className="mt-1.5 flex items-baseline gap-1">
                      <span className="text-sm font-black text-emerald-800">₹{prod.price}</span>
                      <span className="text-[10px] text-slate-500">/{prod.priceUnit || 'unit'}</span>
                    </div>

                    {/* Seller & Stock info */}
                    <div className="mt-1.5 space-y-0.5 text-[10px] text-slate-500">
                      <p className="line-clamp-1">
                        Stock: <strong className="text-slate-700">{prod.availableQuantity} {prod.quantityUnit || 'units'}</strong>
                      </p>
                      <p className="line-clamp-1">
                        🏪 {prod.sellerName || prod.seller} • {prod.sellerLocation || prod.location}
                      </p>
                    </div>
                  </div>

                  {/* Actions */}
                  <div className="mt-3 grid grid-cols-2 gap-1.5 pt-2 border-t border-slate-100">
                    <button
                      onClick={() => {
                        setSelectedProduct(prod);
                        setCurrentRoute('product_details');
                      }}
                      className="w-full bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-[10.5px] py-1.5 rounded-lg transition-colors"
                    >
                      Details
                    </button>
                    <button
                      disabled={isOutOfStock}
                      onClick={() => addToCart(prod, 1)}
                      className={`w-full font-bold text-[10.5px] py-1.5 rounded-lg flex items-center justify-center gap-1 transition-all ${
                        isOutOfStock
                          ? 'bg-slate-200 text-slate-400 cursor-not-allowed'
                          : 'bg-emerald-700 hover:bg-emerald-800 text-white shadow-xs'
                      }`}
                    >
                      <ShoppingCart className="w-3 h-3" />
                      Add
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

// 11b. Product Details View (Phase 9)
function ProductDetailsView({ selectedProduct, cart, setCart, setCurrentRoute, showToast }: any) {
  const p = selectedProduct;
  const maxStock = typeof p?.availableQuantity === 'number' ? p.availableQuantity : 99;
  const isOutOfStock = p?.status === 'Out of Stock' || maxStock <= 0;
  const isLimited = p?.status === 'Limited Stock' || (maxStock <= 25 && !isOutOfStock);

  const [quantity, setQuantity] = useState(isOutOfStock ? 0 : 1);
  const [addedRecently, setAddedRecently] = useState(false);

  if (!p) {
    return (
      <div className="p-6 text-center space-y-3">
        <p className="text-slate-600 font-medium">No product selected</p>
        <button
          onClick={() => setCurrentRoute('products')}
          className="px-4 py-2 bg-emerald-700 text-white rounded-lg text-xs font-bold"
        >
          Browse Farm Products
        </button>
      </div>
    );
  }

  const handleAddToCart = () => {
    if (isOutOfStock) {
      showToast('This product is out of stock.');
      return;
    }
    if (quantity <= 0) {
      showToast('Select at least 1 unit to add.');
      return;
    }
    if (quantity > maxStock) {
      showToast(`Selected quantity exceeds available stock of ${maxStock} ${p.quantityUnit || 'units'}.`);
      return;
    }

    setCart((prev: any) => {
      const exists = prev.find((item: any) => item.product.id === p.id);
      if (exists) {
        const newQty = Math.min(exists.quantity + quantity, maxStock);
        return prev.map((item: any) =>
          item.product.id === p.id ? { ...item, quantity: newQty } : item
        );
      }
      return [...prev, { product: p, quantity }];
    });

    setAddedRecently(true);
    showToast(`Success! Added ${quantity} x ${p.name} to cart.`);
  };

  const handleBuyNow = () => {
    handleAddToCart();
    setCurrentRoute('checkout');
  };

  const totalCartCount = cart.reduce((sum: number, item: any) => sum + item.quantity, 0);

  return (
    <div className="p-4 space-y-4 max-w-4xl mx-auto">
      {/* Top Bar with Back & Cart */}
      <div className="flex justify-between items-center">
        <button
          onClick={() => setCurrentRoute('products')}
          className="flex items-center gap-1.5 text-xs font-bold text-slate-700 hover:text-emerald-800 bg-white border border-slate-200 px-3 py-1.5 rounded-lg shadow-xs"
        >
          <ArrowLeft className="w-4 h-4" />
          Back to Products
        </button>
        <button
          onClick={() => setCurrentRoute('cart')}
          className="relative p-2 bg-white rounded-lg border border-slate-200 text-slate-700 hover:border-emerald-500 shadow-xs flex items-center gap-1.5"
        >
          <ShoppingCart className="w-4 h-4 text-emerald-700" />
          <span className="text-xs font-bold text-slate-700">Cart</span>
          {totalCartCount > 0 && (
            <span className="bg-emerald-600 text-white rounded-full px-1.5 py-0.2 text-[10px] font-black">
              {totalCartCount}
            </span>
          )}
        </button>
      </div>

      {/* Main Details Layout (Responsive Grid) */}
      <div className="grid grid-cols-1 md:grid-cols-12 gap-6 bg-white rounded-2xl border border-slate-200 p-4 md:p-6 shadow-sm">
        {/* Left Column: Image & Seller */}
        <div className="md:col-span-5 space-y-4">
          <div className="relative rounded-xl overflow-hidden bg-slate-100 border border-slate-200">
            <img
              src={p.image}
              alt={p.name}
              className="w-full h-64 object-cover"
            />
            <div className="absolute top-3 left-3">
              <span className="bg-black/75 text-white text-[11px] font-bold px-2.5 py-1 rounded-md backdrop-blur-xs">
                {p.category}
              </span>
            </div>
            <div className="absolute top-3 right-3">
              <span
                className={`text-xs font-black px-2.5 py-1 rounded shadow-xs ${
                  isOutOfStock
                    ? 'bg-red-500 text-white'
                    : isLimited
                    ? 'bg-orange-500 text-white'
                    : 'bg-emerald-600 text-white'
                }`}
              >
                {p.status || (isOutOfStock ? 'Out of Stock' : 'In Stock')}
              </span>
            </div>
          </div>

          {/* Seller Store Card */}
          <div className="bg-slate-50 rounded-xl p-3.5 border border-slate-200 flex items-center gap-3">
            <div className="w-11 h-11 rounded-full bg-emerald-100 text-emerald-800 flex items-center justify-center shrink-0">
              <Store className="w-6 h-6" />
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-1.5">
                <h5 className="font-bold text-xs text-slate-900 truncate">
                  {p.sellerName || p.seller}
                </h5>
                <ShieldCheck className="w-3.5 h-3.5 text-emerald-600 shrink-0" />
              </div>
              <p className="text-[11px] text-slate-500 flex items-center gap-1 mt-0.5">
                <MapPin className="w-3 h-3" />
                {p.sellerLocation || p.location} • Verified Store
              </p>
            </div>
          </div>
        </div>

        {/* Right Column: Title, Price, Description, Specs & Stepper */}
        <div className="md:col-span-7 space-y-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-[11px] font-bold text-emerald-700 bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded">
                {p.category}
              </span>
              <div className="flex items-center text-amber-500 text-xs font-bold gap-1">
                <span>★ {p.rating || 4.8}</span>
                <span className="text-slate-400 font-normal">({p.reviewsCount || 34} reviews)</span>
              </div>
            </div>
            <h1 className="text-lg md:text-xl font-black text-slate-900 mt-2 leading-snug">
              {p.name}
            </h1>
            <div className="flex items-baseline gap-2 mt-2">
              <span className="text-2xl font-black text-emerald-700">₹{p.price}</span>
              <span className="text-xs text-slate-500 font-medium">/{p.priceUnit || 'unit'}</span>
              <span className="text-[10px] text-slate-400">(Inclusive of GST)</span>
            </div>
          </div>

          {/* Stock Status Notice */}
          <div
            className={`p-3 rounded-xl border text-xs flex items-center gap-2.5 ${
              isOutOfStock
                ? 'bg-red-50 border-red-200 text-red-700'
                : isLimited
                ? 'bg-orange-50 border-orange-200 text-orange-800'
                : 'bg-emerald-50 border-emerald-200 text-emerald-800'
            }`}
          >
            <Clock className="w-4 h-4 shrink-0" />
            <div>
              <p className="font-bold">
                {isOutOfStock
                  ? 'Currently Out of Stock'
                  : `Available Stock: ${p.availableQuantity} ${p.quantityUnit || 'units'}`}
              </p>
              <p className="text-[11px] opacity-90">
                {isOutOfStock
                  ? 'Restocking shortly. Check back soon.'
                  : isLimited
                  ? 'Hurry, limited inventory remaining!'
                  : 'Fast local delivery or farm pickup available.'}
              </p>
            </div>
          </div>

          {/* Description */}
          <div>
            <h4 className="font-bold text-xs text-slate-800 mb-1">Product Description</h4>
            <p className="text-xs text-slate-600 leading-relaxed">{p.description}</p>
          </div>

          {/* Specifications Table */}
          {p.specifications && Object.keys(p.specifications).length > 0 && (
            <div className="border border-slate-200 rounded-xl overflow-hidden text-xs">
              <div className="bg-slate-50 px-3 py-2 border-b border-slate-200 font-bold text-slate-800 flex items-center gap-1.5">
                <FileText className="w-3.5 h-3.5 text-emerald-700" />
                Specifications
              </div>
              <div className="divide-y divide-slate-100">
                {Object.entries(p.specifications).map(([key, val]: any) => (
                  <div key={key} className="grid grid-cols-12 px-3 py-1.5 text-[11px]">
                    <span className="col-span-5 text-slate-500 font-medium">{key}</span>
                    <span className="col-span-7 font-bold text-slate-800">{val}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Features Highlights */}
          {p.features && p.features.length > 0 && (
            <div>
              <h4 className="font-bold text-xs text-slate-800 mb-2">Key Highlights</h4>
              <ul className="space-y-1.5 text-xs text-slate-700">
                {p.features.map((feat: string, i: number) => (
                  <li key={i} className="flex items-start gap-2">
                    <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600 shrink-0 mt-0.5" />
                    <span>{feat}</span>
                  </li>
                ))}
              </ul>
            </div>
          )}

          {/* Quantity Selector */}
          <div className="bg-slate-50 p-3.5 rounded-xl border border-slate-200 space-y-2">
            <div className="flex justify-between items-center text-xs">
              <span className="font-bold text-slate-800">Quantity:</span>
              <span className="text-slate-500 text-[11px]">
                {isOutOfStock ? '0 available' : `Max: ${maxStock} ${p.quantityUnit || 'units'}`}
              </span>
            </div>

            <div className="flex items-center gap-3">
              <div className="flex items-center border border-slate-300 rounded-lg bg-white overflow-hidden shadow-2xs">
                <button
                  type="button"
                  disabled={quantity <= 1 || isOutOfStock}
                  onClick={() => setQuantity((q) => Math.max(1, q - 1))}
                  className="px-3 py-1.5 text-slate-700 hover:bg-slate-100 disabled:opacity-30 disabled:cursor-not-allowed font-bold"
                >
                  -
                </button>
                <span className="px-3 py-1.5 font-black text-xs text-slate-800 min-w-8 text-center">
                  {quantity}
                </span>
                <button
                  type="button"
                  disabled={quantity >= maxStock || isOutOfStock}
                  onClick={() => {
                    if (quantity < maxStock) {
                      setQuantity((q) => q + 1);
                    } else {
                      showToast(`Maximum available stock reached (${maxStock})`);
                    }
                  }}
                  className="px-3 py-1.5 text-slate-700 hover:bg-slate-100 disabled:opacity-30 disabled:cursor-not-allowed font-bold"
                >
                  +
                </button>
              </div>

              <div className="text-xs">
                <span className="text-slate-500">Item Total: </span>
                <strong className="text-emerald-800 font-black text-sm">
                  ₹{p.price * quantity}
                </strong>
              </div>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="space-y-2 pt-2">
            <div className="grid grid-cols-2 gap-3">
              <button
                disabled={isOutOfStock}
                onClick={handleAddToCart}
                className={`py-2.5 px-4 rounded-xl font-bold text-xs flex items-center justify-center gap-2 shadow-xs transition-all ${
                  isOutOfStock
                    ? 'bg-slate-200 text-slate-400 cursor-not-allowed'
                    : 'bg-emerald-700 hover:bg-emerald-800 text-white'
                }`}
              >
                <ShoppingCart className="w-4 h-4" />
                {addedRecently ? 'Add More to Cart' : 'Add to Cart'}
              </button>

              <button
                disabled={isOutOfStock}
                onClick={handleBuyNow}
                className={`py-2.5 px-4 rounded-xl font-bold text-xs border border-emerald-700 text-emerald-800 hover:bg-emerald-50 flex items-center justify-center gap-1.5 shadow-xs transition-all ${
                  isOutOfStock ? 'opacity-30 cursor-not-allowed' : ''
                }`}
              >
                Buy Now
              </button>
            </div>

            {addedRecently && (
              <button
                onClick={() => setCurrentRoute('cart')}
                className="w-full py-2 bg-emerald-50 border border-emerald-600 text-emerald-800 rounded-xl text-xs font-bold flex items-center justify-center gap-2 hover:bg-emerald-100 transition-colors"
              >
                <ShoppingCart className="w-3.5 h-3.5" />
                View Cart & Checkout ({totalCartCount} items)
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

// 12. Cart View
function CartView({ cart, setCart, setCurrentRoute }: any) {
  const subtotal = cart.reduce((sum: number, item: any) => sum + item.product.price * item.quantity, 0);
  const delivery = cart.length > 0 ? 50 : 0;
  const total = subtotal + delivery;

  return (
    <div className="p-4 space-y-4">
      <h2 className="text-base font-bold text-slate-800">Cart ({cart.length})</h2>

      <div className="space-y-2.5">
        {cart.map((item: any) => (
          <div key={item.product.id} className="bg-white p-3 rounded-xl border border-slate-200 flex items-center justify-between shadow-sm">
            <div>
              <h4 className="font-bold text-xs text-slate-900">{item.product.name}</h4>
              <p className="text-xs text-slate-500">
                ₹{item.product.price} × {item.quantity}
              </p>
            </div>
            <div className="flex items-center gap-3">
              <span className="font-bold text-xs text-emerald-700">₹{item.product.price * item.quantity}</span>
              <button
                onClick={() => setCart((prev: any) => prev.filter((i: any) => i.product.id !== item.product.id))}
                className="text-red-500 hover:text-red-700"
              >
                <Trash2 className="w-4 h-4" />
              </button>
            </div>
          </div>
        ))}
      </div>

      <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-2 text-xs">
        <div className="flex justify-between text-slate-600">
          <span>Subtotal</span>
          <span>₹{subtotal}</span>
        </div>
        <div className="flex justify-between text-slate-600">
          <span>Delivery</span>
          <span>₹{delivery}</span>
        </div>
        <div className="border-t border-slate-200 pt-2 flex justify-between font-black text-sm text-slate-900">
          <span>Total</span>
          <span className="text-emerald-700">₹{total}</span>
        </div>
      </div>

      <button
        onClick={() => setCurrentRoute('checkout')}
        className="w-full bg-emerald-700 hover:bg-emerald-800 text-white font-bold text-xs py-2.5 rounded-lg shadow-sm"
      >
        Checkout
      </button>
    </div>
  );
}

// 13. Checkout View
function CheckoutView({ cart, setCart, setOrders, setCurrentRoute, showToast }: any) {
  const [address, setAddress] = useState('Gat No. 234, Baramati Road, Pune, Maharashtra');
  const [phone, setPhone] = useState('+91 98765 43210');

  const total = cart.reduce((sum: number, item: any) => sum + item.product.price * item.quantity, 0) + 50;

  const handlePlaceOrder = (e: React.FormEvent) => {
    e.preventDefault();
    const newOrder = {
      orderNumber: 'ORD-BUY-' + Math.floor(1000 + Math.random() * 9000),
      itemTitle: cart[0]?.product?.name || 'Farm Inputs',
      category: 'Farm Product',
      quantity: `${cart.length} items`,
      price: total,
      counterParty: 'ABC Agro Store',
      address,
      date: 'Today',
      status: 'Placed',
      isBuying: true,
    };
    setOrders((prev: any) => [newOrder, ...prev]);
    setCart([]);
    showToast('Order placed successfully');
    setCurrentRoute('orders');
  };

  return (
    <div className="p-4 space-y-4">
      <h2 className="text-base font-bold text-slate-800">Checkout</h2>
      <form onSubmit={handlePlaceOrder} className="bg-white p-4 rounded-xl border border-slate-200 space-y-3 shadow-sm">
        <div>
          <label className="text-xs font-bold text-slate-700">Delivery Address *</label>
          <textarea
            required
            rows={2}
            value={address}
            onChange={(e) => setAddress(e.target.value)}
            className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs"
          ></textarea>
        </div>
        <div>
          <label className="text-xs font-bold text-slate-700">Phone Number *</label>
          <input
            type="text"
            required
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs"
          />
        </div>
        <div className="bg-slate-50 p-3 rounded-lg flex justify-between font-bold text-xs text-slate-800">
          <span>Total Amount to Pay:</span>
          <span className="text-emerald-700 text-sm">₹{total}</span>
        </div>
        <button
          type="submit"
          className="w-full bg-emerald-700 hover:bg-emerald-800 text-white font-bold text-xs py-2.5 rounded-lg"
        >
          Place Order
        </button>
      </form>
    </div>
  );
}

// 14. Contracts View
function ContractsView({ contracts, setContracts, showToast }: any) {
  const applyContract = (contractId: string) => {
    setContracts((prev: any) =>
      prev.map((c: any) => (c.id === contractId ? { ...c, status: 'Under Review' } : c))
    );
    showToast('Application sent');
  };

  return (
    <div className="p-4 space-y-4">
      <div>
        <h2 className="text-base font-bold text-slate-800">Farm Contracts</h2>
        <p className="text-xs text-slate-500">Find companies that want to buy your crop.</p>
      </div>

      <div className="space-y-3">
        {contracts.map((c: any) => (
          <div key={c.id} className="bg-white p-4 rounded-xl border border-slate-200 space-y-2 shadow-sm">
            <div className="flex justify-between items-start">
              <div>
                <h3 className="font-bold text-sm text-slate-900">{c.company}</h3>
                <p className="text-xs text-emerald-700 font-semibold">
                  Crop: {c.crop} • {c.quantity}
                </p>
              </div>
              <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-indigo-100 text-indigo-800">
                {c.status}
              </span>
            </div>
            <div className="text-xs text-slate-600 space-y-0.5">
              <p>Agreed Price: <b>₹{c.price}/kg</b></p>
              <p>Location: {c.location} • Last Date: {c.lastDate}</p>
            </div>
            {c.status === 'Available' ? (
              <button
                onClick={() => applyContract(c.id)}
                className="w-full mt-2 bg-emerald-700 text-white text-xs font-bold py-2 rounded-lg hover:bg-emerald-800"
              >
                Apply
              </button>
            ) : (
              <button disabled className="w-full mt-2 bg-slate-200 text-slate-500 text-xs font-bold py-2 rounded-lg">
                Applied ({c.status})
              </button>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

// 15. Orders View
function OrdersView({ orders }: any) {
  const [tab, setTab] = useState<'buying' | 'selling'>('buying');

  const filtered = orders.filter((o: any) => (tab === 'buying' ? o.isBuying : !o.isBuying));

  return (
    <div className="p-4 space-y-4">
      <div className="flex bg-slate-200 p-1 rounded-xl">
        <button
          onClick={() => setTab('buying')}
          className={`flex-1 py-1.5 text-xs font-bold rounded-lg transition-all ${
            tab === 'buying' ? 'bg-white text-slate-900 shadow-sm' : 'text-slate-600'
          }`}
        >
          Buying
        </button>
        <button
          onClick={() => setTab('selling')}
          className={`flex-1 py-1.5 text-xs font-bold rounded-lg transition-all ${
            tab === 'selling' ? 'bg-white text-slate-900 shadow-sm' : 'text-slate-600'
          }`}
        >
          Selling
        </button>
      </div>

      <div className="space-y-3">
        {filtered.map((ord: any) => (
          <div key={ord.orderNumber} className="bg-white p-4 rounded-xl border border-slate-200 space-y-2 shadow-sm">
            <div className="flex justify-between items-start">
              <div>
                <span className="text-[10px] text-slate-400 font-mono">{ord.orderNumber}</span>
                <h3 className="font-bold text-sm text-slate-900">{ord.itemTitle}</h3>
              </div>
              <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800">
                {ord.status}
              </span>
            </div>
            <div className="flex justify-between text-xs text-slate-600">
              <span>Qty: {ord.quantity}</span>
              <span className="font-bold text-emerald-700">₹{ord.price}</span>
            </div>
            <div className="pt-2 border-t border-slate-100 text-[11px] text-slate-500">
              {tab === 'buying' ? 'Seller' : 'Buyer'}: {ord.counterParty}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// 16. Market View
function MarketView() {
  const items = [
    { name: 'Tomato Grade A', cat: 'Crops', price: '₹25/kg', loc: 'Pune Mandi' },
    { name: 'Sharbati Wheat', cat: 'Crops', price: '₹32/kg', loc: 'Nashik APMC' },
    { name: 'Organic Bio-Fertilizer', cat: 'Farm Products', price: '₹650/bag', loc: 'Pune' },
    { name: 'Dry Wheat Straw', cat: 'Farm Waste', price: '₹4/kg', loc: 'Baramati' },
    { name: 'ABC Foods Buy Need', cat: 'Buyer Needs', price: '₹30/kg', loc: 'Pune Food Park' },
  ];

  return (
    <div className="p-4 space-y-4">
      <h2 className="text-base font-bold text-slate-800">Market</h2>
      <div className="space-y-2.5">
        {items.map((item, i) => (
          <div key={i} className="bg-white p-3.5 rounded-xl border border-slate-200 flex justify-between items-center shadow-sm">
            <div>
              <span className="text-[10px] font-bold px-2 py-0.5 rounded bg-emerald-50 text-emerald-700">
                {item.cat}
              </span>
              <h4 className="font-bold text-sm text-slate-900 mt-1">{item.name}</h4>
              <p className="text-xs text-slate-500">{item.loc}</p>
            </div>
            <span className="font-extrabold text-sm text-emerald-700">{item.price}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

// 17. Notifications View
function NotificationsView({ notifications, setNotifications, showToast }: any) {
  const markAll = () => {
    setNotifications((prev: any) => prev.map((n: any) => ({ ...n, isRead: true })));
    showToast('All marked as read');
  };

  return (
    <div className="p-4 space-y-3">
      <div className="flex justify-between items-center">
        <h2 className="text-base font-bold text-slate-800">Notifications</h2>
        <button onClick={markAll} className="text-xs font-bold text-emerald-700 hover:underline">
          Mark Read
        </button>
      </div>

      <div className="space-y-2.5">
        {notifications.map((n: any) => (
          <div
            key={n.id}
            className={`p-3 rounded-xl border ${
              n.isRead ? 'bg-white border-slate-200' : 'bg-emerald-50/70 border-emerald-200'
            }`}
          >
            <div className="flex justify-between">
              <h4 className="font-bold text-xs text-slate-900">{n.title}</h4>
              <span className="text-[10px] text-slate-400">{n.time}</span>
            </div>
            <p className="text-xs text-slate-600 mt-1">{n.message}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

// 18. Profile View
function ProfileView({ setCurrentRoute, farmerUser, handleLogout }: any) {
  const initials = farmerUser?.name
    ? farmerUser.name.split(' ').map((n: string) => n[0]).join('').slice(0, 2).toUpperCase()
    : 'SP';

  return (
    <div className="p-4 space-y-4">
      <div className="bg-white p-5 rounded-2xl border border-slate-200 text-center shadow-sm">
        <div className="w-16 h-16 rounded-full bg-emerald-700 text-white font-bold text-xl flex items-center justify-center mx-auto mb-2">
          {initials}
        </div>
        <h2 className="font-black text-lg text-slate-900">{farmerUser?.name || 'Suresh Patil'}</h2>
        <p className="text-xs text-slate-500">+91 {farmerUser?.mobile || '98765 43210'} • {farmerUser?.village || 'Haveli'}, {farmerUser?.district || 'Pune'}</p>
        <div className="mt-3 pt-3 border-t border-slate-100 flex justify-around text-xs">
          <div>
            <span className="text-slate-400 block">Farm Size</span>
            <span className="font-bold text-slate-800">{farmerUser?.farmSize || '5 Acres'}</span>
          </div>
          <div>
            <span className="text-slate-400 block">Main Crops</span>
            <span className="font-bold text-emerald-700">{farmerUser?.mainCrops || 'Tomato, Wheat, Onion'}</span>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-xl border border-slate-200 divide-y divide-slate-100 text-xs font-semibold text-slate-700">
        <div className="p-3 flex justify-between items-center cursor-pointer">
          <span>Language: English</span>
          <ChevronRight className="w-4 h-4 text-slate-400" />
        </div>
        <div onClick={() => setCurrentRoute('help')} className="p-3 flex justify-between items-center cursor-pointer">
          <span>Help & Support</span>
          <ChevronRight className="w-4 h-4 text-slate-400" />
        </div>
        <div
          onClick={handleLogout}
          className="p-3 flex justify-between items-center cursor-pointer text-red-600 hover:bg-red-50 transition-colors"
        >
          <span className="font-bold flex items-center gap-2">
            <LogOut className="w-4 h-4" /> Logout
          </span>
          <ChevronRight className="w-4 h-4 text-red-400" />
        </div>
      </div>
    </div>
  );
}

// 19. Help View
function HelpView({ showToast }: any) {
  return (
    <div className="p-4 space-y-4">
      <div className="bg-emerald-800 text-white p-4 rounded-xl">
        <h3 className="font-bold text-base">How can we help you?</h3>
        <p className="text-xs text-emerald-100 mt-1">Our Kisan helpline is available 7 days a week.</p>
        <button
          onClick={() => showToast ? showToast('Connecting to Kisan Toll-Free: 1800-180-1551') : null}
          className="mt-3 w-full bg-white text-emerald-800 font-bold text-xs py-2 rounded-lg cursor-pointer"
        >
          Call Farm Support
        </button>
      </div>

      <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-3">
        <h4 className="font-bold text-xs text-slate-900 uppercase tracking-wider">Simple FAQs</h4>
        <div className="space-y-2 text-xs">
          <div>
            <p className="font-bold text-slate-800">How to add my crop?</p>
            <p className="text-slate-500 text-[11px]">Go to My Crops, tap + Add Crop, fill in the details and save.</p>
          </div>
          <div>
            <p className="font-bold text-slate-800">How to sell farm waste?</p>
            <p className="text-slate-500 text-[11px]">Open Sell Farm Waste, pick waste type and quantity, then tap Post.</p>
          </div>
          <div>
            <p className="font-bold text-slate-800">How to find labour?</p>
            <p className="text-slate-500 text-[11px]">Open Find Labour, choose the work needed and send a request.</p>
          </div>
        </div>
      </div>
    </div>
  );
}

// 20. Splash View
function SplashView({ onComplete }: { onComplete: () => void }) {
  React.useEffect(() => {
    const timer = setTimeout(() => {
      onComplete();
    }, 2400);
    return () => clearTimeout(timer);
  }, [onComplete]);

  return (
    <div className="h-full min-h-[460px] flex flex-col items-center justify-center p-6 text-center bg-white select-none">
      <div className="w-20 h-20 rounded-3xl bg-emerald-700 flex items-center justify-center text-white shadow-xl shadow-emerald-700/25 mb-5">
        <Sprout className="w-11 h-11" />
      </div>
      <h1 className="text-2xl font-black text-emerald-950 tracking-tight">AgroWorld</h1>
      <div className="mt-2 px-3 py-1 bg-emerald-100/80 rounded-full border border-emerald-200">
        <span className="text-xs font-bold text-emerald-800">Farmer App • स्मार्ट शेतकरी</span>
      </div>
      <p className="mt-3 text-xs text-slate-500 max-w-[280px] leading-relaxed">
        Integrated Agri-Commerce and Farm Services Platform
      </p>

      <div className="mt-10 flex flex-col items-center gap-3">
        <div className="w-6 h-6 border-2 border-emerald-700 border-t-transparent rounded-full animate-spin"></div>
        <p className="text-xs font-medium text-slate-400">Loading your farm...</p>
      </div>

      <button
        onClick={onComplete}
        className="mt-8 text-xs font-bold text-emerald-700 hover:text-emerald-900 underline cursor-pointer"
      >
        Continue to Login →
      </button>
    </div>
  );
}

// 21. Login View
function LoginView({
  onLogin,
  onGoToRegister,
  showToast,
}: {
  onLogin: () => void;
  onGoToRegister: () => void;
  showToast: (msg: string) => void;
}) {
  const [mobile, setMobile] = useState('9876543210');
  const [password, setPassword] = useState('password123');
  const [showPassword, setShowPassword] = useState(false);
  const [showForgotModal, setShowForgotModal] = useState(false);
  const [forgotMobile, setForgotMobile] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (mobile.trim().length !== 10) {
      alert('Please enter a valid 10-digit mobile number');
      return;
    }
    if (password.length < 6) {
      alert('Password must be at least 6 characters');
      return;
    }
    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
      onLogin();
    }, 400);
  };

  const handleSendOtp = (e: React.FormEvent) => {
    e.preventDefault();
    if (forgotMobile.trim().length !== 10) {
      alert('Please enter a valid 10-digit mobile number');
      return;
    }
    setShowForgotModal(false);
    showToast(`Password reset code sent to +91 ${forgotMobile}`);
  };

  return (
    <div className="h-full flex flex-col justify-center p-5 sm:p-6 overflow-y-auto bg-slate-50">
      <div className="w-full max-w-sm mx-auto bg-white rounded-2xl border border-slate-200 p-6 shadow-sm">
        {/* AgroWorld Brand Header */}
        <div className="flex flex-col items-center text-center mb-6">
          <div className="w-14 h-14 rounded-2xl bg-emerald-700 flex items-center justify-center text-white shadow-md shadow-emerald-700/20 mb-3">
            <Sprout className="w-8 h-8" />
          </div>
          <h2 className="text-xl font-black text-emerald-950 tracking-tight">AgroWorld</h2>
          <h3 className="text-base font-bold text-slate-800 mt-0.5">Farmer Login</h3>
          <p className="text-xs text-slate-500 mt-1">
            Login to manage crops, labour, orders & market
          </p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">Mobile Number *</label>
            <div className="relative flex items-center">
              <span className="absolute left-3 text-xs font-bold text-slate-600 select-none">
                +91
              </span>
              <input
                type="tel"
                required
                maxLength={10}
                placeholder="10 digit mobile number"
                value={mobile}
                onChange={(e) => setMobile(e.target.value.replace(/\D/g, ''))}
                className="w-full pl-12 pr-3 py-2.5 rounded-xl border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-emerald-500 focus:outline-none"
              />
            </div>
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">Password *</label>
            <div className="relative flex items-center">
              <input
                type={showPassword ? 'text' : 'password'}
                required
                placeholder="Enter password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full pl-3 pr-10 py-2.5 rounded-xl border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-emerald-500 focus:outline-none"
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-3 text-slate-400 hover:text-slate-600 cursor-pointer"
              >
                {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
              </button>
            </div>
          </div>

          <div className="flex justify-end">
            <button
              type="button"
              onClick={() => {
                setForgotMobile(mobile);
                setShowForgotModal(true);
              }}
              className="text-xs font-semibold text-emerald-700 hover:text-emerald-900 cursor-pointer"
            >
              Forgot Password?
            </button>
          </div>

          <button
            type="submit"
            disabled={isLoading}
            className="w-full bg-emerald-700 hover:bg-emerald-800 active:scale-[0.99] text-white font-bold text-xs py-3 rounded-xl shadow-sm transition-all flex items-center justify-center gap-2 cursor-pointer"
          >
            {isLoading ? (
              <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
            ) : (
              'Login'
            )}
          </button>
        </form>

        {/* Demo Fill Helper */}
        <div className="mt-4 p-2.5 bg-slate-50 rounded-xl border border-slate-200 flex items-center justify-between text-xs">
          <span className="text-[11px] text-slate-500">
            Demo: <b className="text-slate-700">9876543210</b> / <b className="text-slate-700">password123</b>
          </span>
          <button
            type="button"
            onClick={() => {
              setMobile('9876543210');
              setPassword('password123');
              showToast('Filled demo farmer credentials');
            }}
            className="text-[11px] font-bold text-emerald-700 hover:text-emerald-900 px-2 py-0.5 rounded bg-emerald-50 border border-emerald-200 cursor-pointer"
          >
            Fill
          </button>
        </div>

        <div className="mt-5 text-center text-xs text-slate-500">
          Don't have an account?{' '}
          <button
            type="button"
            onClick={onGoToRegister}
            className="font-bold text-emerald-700 hover:text-emerald-900 ml-1 cursor-pointer"
          >
            Create Account
          </button>
        </div>
      </div>

      {/* Forgot Password Modal */}
      {showForgotModal && (
        <div className="fixed inset-0 z-50 bg-black/60 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl p-5 w-full max-w-sm border border-slate-200 shadow-xl space-y-3">
            <h3 className="font-bold text-base text-slate-900">Forgot Password</h3>
            <p className="text-xs text-slate-500">
              Enter your registered mobile number to receive a verification OTP.
            </p>
            <form onSubmit={handleSendOtp} className="space-y-3">
              <input
                type="tel"
                required
                maxLength={10}
                placeholder="10 digit mobile number"
                value={forgotMobile}
                onChange={(e) => setForgotMobile(e.target.value.replace(/\D/g, ''))}
                className="w-full px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
              />
              <div className="flex justify-end gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowForgotModal(false)}
                  className="px-3 py-1.5 rounded-lg border border-slate-300 text-xs font-semibold text-slate-600 cursor-pointer"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-1.5 rounded-lg bg-emerald-700 hover:bg-emerald-800 text-white text-xs font-bold cursor-pointer"
                >
                  Send OTP
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

// 22. Register View
function RegisterView({
  onRegisterSuccess,
  onBackToLogin,
  showToast,
}: {
  onRegisterSuccess: (user: any) => void;
  onBackToLogin: () => void;
  showToast: (msg: string) => void;
}) {
  const [name, setName] = useState('');
  const [mobile, setMobile] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [village, setVillage] = useState('');
  const [district, setDistrict] = useState('');
  const [state, setState] = useState('Maharashtra');
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) {
      showToast('Farmer Name is required');
      return;
    }
    if (mobile.trim().length !== 10) {
      showToast('Mobile number must be exactly 10 digits');
      return;
    }
    if (password.length < 6) {
      showToast('Password must be at least 6 characters');
      return;
    }
    if (password !== confirmPassword) {
      showToast('Passwords do not match');
      return;
    }
    if (!village.trim()) {
      showToast('Village is required');
      return;
    }
    if (!district.trim()) {
      showToast('District is required');
      return;
    }
    if (!state.trim()) {
      showToast('State is required');
      return;
    }

    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
      onRegisterSuccess({
        name: name.trim(),
        mobile: mobile.trim(),
        village: village.trim(),
        district: district.trim(),
        state: state.trim(),
      });
    }, 400);
  };

  return (
    <div className="h-full flex flex-col justify-start p-4 sm:p-6 overflow-y-auto bg-slate-50">
      <div className="w-full max-w-md mx-auto bg-white rounded-2xl border border-slate-200 p-5 sm:p-6 shadow-sm">
        {/* Header */}
        <div className="flex items-center gap-3 pb-4 border-b border-slate-100 mb-4">
          <button
            type="button"
            onClick={onBackToLogin}
            className="p-1.5 text-slate-600 hover:bg-slate-100 rounded-lg cursor-pointer"
          >
            <ArrowLeft className="w-4 h-4" />
          </button>
          <div>
            <h2 className="text-base font-black text-slate-900">Farmer Registration</h2>
            <p className="text-[11px] text-slate-500">Create your new AgroWorld farmer account</p>
          </div>
        </div>

        <form onSubmit={handleSubmit} className="space-y-3">
          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">Farmer Full Name *</label>
            <input
              type="text"
              required
              placeholder="e.g. Ramesh Patil"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="w-full px-3 py-2 rounded-lg border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            />
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">Mobile Number *</label>
            <div className="relative flex items-center">
              <span className="absolute left-3 text-xs font-bold text-slate-600 select-none">
                +91
              </span>
              <input
                type="tel"
                required
                maxLength={10}
                placeholder="10 digit mobile number"
                value={mobile}
                onChange={(e) => setMobile(e.target.value.replace(/\D/g, ''))}
                className="w-full pl-12 pr-3 py-2 rounded-lg border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-emerald-500 focus:outline-none"
              />
            </div>
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">Password *</label>
            <div className="relative flex items-center">
              <input
                type={showPassword ? 'text' : 'password'}
                required
                placeholder="Min 6 characters"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full pl-3 pr-9 py-2 rounded-lg border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-emerald-500 focus:outline-none"
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-3 text-slate-400 hover:text-slate-600 cursor-pointer"
              >
                {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
              </button>
            </div>
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">Confirm Password *</label>
            <div className="relative flex items-center">
              <input
                type={showConfirmPassword ? 'text' : 'password'}
                required
                placeholder="Re-enter password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                className="w-full pl-3 pr-9 py-2 rounded-lg border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-emerald-500 focus:outline-none"
              />
              <button
                type="button"
                onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                className="absolute right-3 text-slate-400 hover:text-slate-600 cursor-pointer"
              >
                {showConfirmPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
              </button>
            </div>
          </div>

          <div>
            <label className="text-xs font-bold text-slate-700 block mb-1">Village *</label>
            <input
              type="text"
              required
              placeholder="e.g. Haveli, Baramati"
              value={village}
              onChange={(e) => setVillage(e.target.value)}
              className="w-full px-3 py-2 rounded-lg border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            />
          </div>

          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">District *</label>
              <input
                type="text"
                required
                placeholder="e.g. Pune"
                value={district}
                onChange={(e) => setDistrict(e.target.value)}
                className="w-full px-3 py-2 rounded-lg border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-emerald-500 focus:outline-none"
              />
            </div>
            <div>
              <label className="text-xs font-bold text-slate-700 block mb-1">State *</label>
              <input
                type="text"
                required
                placeholder="e.g. Maharashtra"
                value={state}
                onChange={(e) => setState(e.target.value)}
                className="w-full px-3 py-2 rounded-lg border border-slate-300 text-xs font-medium focus:ring-2 focus:ring-emerald-500 focus:outline-none"
              />
            </div>
          </div>

          <div className="pt-2 space-y-2">
            <button
              type="submit"
              disabled={isLoading}
              className="w-full bg-emerald-700 hover:bg-emerald-800 active:scale-[0.99] text-white font-bold text-xs py-2.5 rounded-xl shadow-sm transition-all flex items-center justify-center gap-2 cursor-pointer"
            >
              {isLoading ? (
                <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
              ) : (
                'Create Account'
              )}
            </button>
            <button
              type="button"
              onClick={onBackToLogin}
              className="w-full bg-white hover:bg-slate-50 text-slate-700 font-semibold text-xs py-2 rounded-xl border border-slate-200 cursor-pointer"
            >
              Back to Login
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
