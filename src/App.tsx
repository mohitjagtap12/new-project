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
  Truck
} from 'lucide-react';

// Initial Mock Crops
const initialCrops = [
  {
    id: 'c1',
    name: 'Tomato',
    variety: 'Abhinav F1 Hybrid',
    area: '2 acres',
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
    area: '3.5 acres',
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
    area: '1.5 acres',
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
    area: '4 acres',
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
    cropName: 'Tomato',
    quantity: '500',
    unit: 'kg',
    price: 25,
    location: 'Pune',
    status: 'Available',
    image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    description: 'Fresh farm-harvested red ripe tomatoes. High shelf life.',
  },
  {
    id: 'cs2',
    cropName: 'Wheat',
    quantity: '1200',
    unit: 'kg',
    price: 32,
    location: 'Pune',
    status: 'Sold',
    image: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
    description: 'Cleaned grade-A Sharbati wheat grains.',
  },
  {
    id: 'cs3',
    cropName: 'Maize',
    quantity: '800',
    unit: 'kg',
    price: 22,
    location: 'Pune',
    status: 'Waiting',
    image: 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=600&auto=format&fit=crop&q=80',
    description: 'Yellow feed maize dried to 12% moisture.',
  },
];

const initialWorkers = [
  {
    id: 'w1',
    name: 'Ramesh',
    work: 'Harvesting',
    experience: '5 years',
    distance: '3 km away',
    dailyWage: 500,
    status: 'Available',
    image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80',
  },
  {
    id: 'w2',
    name: 'Suresh Kumar',
    work: 'Planting',
    experience: '4 years',
    distance: '5 km away',
    dailyWage: 480,
    status: 'Available',
    image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&auto=format&fit=crop&q=80',
  },
  {
    id: 'w3',
    name: 'Ganesh Patil',
    work: 'Spraying',
    experience: '7 years',
    distance: '2 km away',
    dailyWage: 550,
    status: 'Available',
    image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300&auto=format&fit=crop&q=80',
  },
  {
    id: 'w4',
    name: 'Sunita Bai & Team',
    work: 'Weeding',
    experience: '8 years',
    distance: '4 km away',
    dailyWage: 450,
    status: 'Available',
    image: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&auto=format&fit=crop&q=80',
  },
];

const initialLabourRequests = [
  { id: 'lr1', workerName: 'Ramesh', work: 'Harvesting', date: '08 Sep 2026', workersNeeded: 3, dailyWage: 500, status: 'Accepted' },
  { id: 'lr2', workerName: 'Ganesh Patil', work: 'Spraying', date: '10 Sep 2026', workersNeeded: 1, dailyWage: 550, status: 'Requested' },
  { id: 'lr3', workerName: 'Sunita Bai & Team', work: 'Weeding', date: '12 Sep 2026', workersNeeded: 4, dailyWage: 450, status: 'Working' },
];

const initialProducts = [
  {
    id: 'p1',
    name: 'Tomato Seeds F1 Hybrid',
    category: 'Seeds',
    price: 450,
    seller: 'ABC Agro Store',
    location: 'Pune',
    description: 'High disease resistance hybrid tomato seeds. Yield up to 35 tons/acre.',
    availableQuantity: '50 packets',
    image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
  },
  {
    id: 'p2',
    name: 'Wheat Certified Seeds (HD-2967)',
    category: 'Seeds',
    price: 980,
    seller: 'Kisan Beej Bhandar',
    location: 'Pune',
    description: '40 kg bag certified seeds. High tillering and drought resistant.',
    availableQuantity: '120 bags',
    image: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80',
  },
  {
    id: 'p3',
    name: 'Organic Bio-Fertilizer (NPK)',
    category: 'Fertilizers',
    price: 650,
    seller: 'Green Earth Bio Agro',
    location: 'Pune',
    description: '50kg organic granules enriched with mycorrhiza and beneficial bacteria.',
    availableQuantity: '80 bags',
    image: 'https://images.unsplash.com/photo-1628352081506-83c43123ed6d?w=600&auto=format&fit=crop&q=80',
  },
  {
    id: 'p4',
    name: 'Battery Knapsack Sprayer (16L)',
    category: 'Tools',
    price: 2400,
    seller: 'Maharashtra Agro Tools',
    location: 'Pune',
    description: '12V 8Ah battery with dual motor. 4 nozzles included for spraying.',
    availableQuantity: '25 units',
    image: 'https://images.unsplash.com/photo-1589923188900-85dae523342b?w=600&auto=format&fit=crop&q=80',
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
  const [currentRoute, setCurrentRoute] = useState<string>('home');
  const [crops, setCrops] = useState(initialCrops);
  const [cropSales, setCropSales] = useState(initialCropSales);
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
                    SP
                  </button>
                </div>
              </div>

              {/* Mobile Screen Body */}
              <div className="flex-1 overflow-y-auto bg-slate-50">
                {renderScreenContent({
                  currentRoute,
                  setCurrentRoute,
                  crops,
                  setCrops,
                  cropSales,
                  setCropSales,
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

              {/* Windows Desktop App Content with Sidebar */}
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

                  {/* Desktop User Footer */}
                  <div className="p-3 bg-white rounded-lg border border-slate-200 flex items-center gap-3">
                    <div className="w-8 h-8 rounded-full bg-emerald-100 text-emerald-800 font-bold flex items-center justify-center text-xs">
                      SP
                    </div>
                    <div className="overflow-hidden">
                      <p className="text-xs font-bold text-slate-800 truncate">Suresh Patil</p>
                      <p className="text-[11px] text-slate-500 truncate">Pune, MH • 5 Acres</p>
                    </div>
                  </div>
                </aside>

                {/* Desktop Screen Body */}
                <div className="flex-1 overflow-y-auto p-6 bg-slate-100/70">
                  {renderScreenContent({
                    currentRoute,
                    setCurrentRoute,
                    crops,
                    setCrops,
                    cropSales,
                    setCropSales,
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
                    showToast,
                  })}
                </div>
              </div>
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
    case 'farm_waste':
      return <FarmWasteView {...props} />;
    case 'labour':
      return <LabourView {...props} />;
    case 'products':
      return <ProductsView {...props} />;
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
function DashboardView({ crops, orders, labourRequests, cropSales, setCurrentRoute }: any) {
  return (
    <div className="p-4 space-y-4">
      {/* Hello Farmer Banner */}
      <div className="bg-gradient-to-r from-emerald-800 to-emerald-700 rounded-2xl p-5 text-white shadow-md flex items-center justify-between">
        <div>
          <h2 className="text-xl font-black tracking-tight">Hello, Farmer!</h2>
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
          <p className="text-2xl font-black text-slate-800">{cropSales.length}</p>
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
            onClick={() => setCurrentRoute('sell_crop')}
            className="flex items-center gap-2 p-3 bg-white rounded-xl border border-slate-200 text-left hover:bg-slate-50 font-semibold text-xs text-slate-800 shadow-sm"
          >
            <div className="w-7 h-7 rounded-lg bg-amber-100 text-amber-800 flex items-center justify-center">
              <DollarSign className="w-4 h-4" />
            </div>
            Sell Crop
          </button>
          <button
            onClick={() => setCurrentRoute('crop_health')}
            className="flex items-center gap-2 p-3 bg-white rounded-xl border border-slate-200 text-left hover:bg-slate-50 font-semibold text-xs text-slate-800 shadow-sm"
          >
            <div className="w-7 h-7 rounded-lg bg-red-100 text-red-800 flex items-center justify-center">
              <HeartPulse className="w-4 h-4" />
            </div>
            Check Health
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
            Contracts
          </button>
        </div>
      </div>
    </div>
  );
}

// 2. My Crops View
function MyCropsView({ crops, setCurrentRoute, setSelectedCrop }: any) {
  return (
    <div className="p-4 space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="text-base font-bold text-slate-800">My Crops ({crops.length})</h2>
        <button
          onClick={() => setCurrentRoute('add_crop')}
          className="flex items-center gap-1 bg-emerald-700 hover:bg-emerald-800 text-white text-xs font-bold px-3 py-1.5 rounded-lg shadow-sm"
        >
          <Plus className="w-3.5 h-3.5" /> Add Crop
        </button>
      </div>

      <div className="space-y-3">
        {crops.map((crop: any) => (
          <div key={crop.id} className="bg-white rounded-xl border border-slate-200 overflow-hidden shadow-sm">
            <div className="flex p-3 gap-3">
              <img src={crop.image} alt={crop.name} className="w-20 h-20 rounded-lg object-cover" />
              <div className="flex-1">
                <div className="flex justify-between items-start">
                  <h3 className="font-bold text-slate-900 text-base">{crop.name}</h3>
                  <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800">
                    {crop.status}
                  </span>
                </div>
                <p className="text-xs text-slate-500">{crop.variety}</p>
                <div className="mt-2 text-xs text-slate-600 flex flex-wrap gap-x-3 gap-y-1">
                  <span>Area: <b>{crop.area}</b></span>
                  <span>Harvest: <b>{crop.expectedHarvest}</b></span>
                </div>
              </div>
            </div>
            <div className="bg-slate-50 px-3 py-2 border-t border-slate-100 flex justify-end gap-2">
              <button
                onClick={() => {
                  setSelectedCrop(crop);
                  setCurrentRoute('crop_details');
                }}
                className="text-xs font-bold text-emerald-700 px-3 py-1 bg-white border border-emerald-300 rounded-md hover:bg-emerald-50"
              >
                View
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

// 3. Add Crop View
function AddCropView({ setCrops, setCurrentRoute, showToast }: any) {
  const [name, setName] = useState('');
  const [variety, setVariety] = useState('');
  const [area, setArea] = useState('');
  const [plantingDate, setPlantingDate] = useState('10 June 2026');
  const [expectedHarvest, setExpectedHarvest] = useState('15 September 2026');
  const [notes, setNotes] = useState('');

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name || !area) {
      alert('Please fill in crop name and farm area');
      return;
    }
    const newCrop = {
      id: 'c_' + Date.now(),
      name,
      variety: variety || 'Standard Variety',
      area,
      plantingDate,
      expectedHarvest,
      status: 'Growing',
      notes,
      image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
    };
    setCrops((prev: any) => [newCrop, ...prev]);
    showToast('Crop added successfully');
    setCurrentRoute('crops');
  };

  return (
    <div className="p-4 space-y-4">
      <h2 className="text-base font-bold text-slate-800">Add Crop</h2>
      <form onSubmit={handleSave} className="bg-white p-4 rounded-xl border border-slate-200 space-y-3 shadow-sm">
        <div>
          <label className="text-xs font-bold text-slate-700">Crop Name *</label>
          <input
            type="text"
            required
            placeholder="e.g. Tomato, Wheat, Onion"
            value={name}
            onChange={(e) => setName(e.target.value)}
            className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
          />
        </div>
        <div>
          <label className="text-xs font-bold text-slate-700">Variety</label>
          <input
            type="text"
            placeholder="e.g. Abhinav F1"
            value={variety}
            onChange={(e) => setVariety(e.target.value)}
            className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
          />
        </div>
        <div>
          <label className="text-xs font-bold text-slate-700">Farm Area *</label>
          <input
            type="text"
            required
            placeholder="e.g. 2 acres"
            value={area}
            onChange={(e) => setArea(e.target.value)}
            className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
          />
        </div>
        <div className="grid grid-cols-2 gap-2">
          <div>
            <label className="text-xs font-bold text-slate-700">Planting Date</label>
            <input
              type="text"
              value={plantingDate}
              onChange={(e) => setPlantingDate(e.target.value)}
              className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            />
          </div>
          <div>
            <label className="text-xs font-bold text-slate-700">Expected Harvest</label>
            <input
              type="text"
              value={expectedHarvest}
              onChange={(e) => setExpectedHarvest(e.target.value)}
              className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
            />
          </div>
        </div>
        <div>
          <label className="text-xs font-bold text-slate-700">Notes</label>
          <textarea
            rows={2}
            placeholder="Irrigation notes, fertilizers, seed supplier..."
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs focus:ring-2 focus:ring-emerald-500 focus:outline-none"
          ></textarea>
        </div>
        <button
          type="submit"
          className="w-full bg-emerald-700 hover:bg-emerald-800 text-white font-bold text-xs py-2.5 rounded-lg shadow-sm"
        >
          Save Crop
        </button>
      </form>
    </div>
  );
}

// 4. Crop Details View
function CropDetailsView({ selectedCrop, setCrops, setCurrentRoute, showToast }: any) {
  const handleDelete = () => {
    if (confirm('Are you sure you want to delete this crop?')) {
      setCrops((prev: any) => prev.filter((c: any) => c.id !== selectedCrop.id));
      showToast('Crop deleted');
      setCurrentRoute('crops');
    }
  };

  return (
    <div className="space-y-3">
      <img src={selectedCrop.image} alt={selectedCrop.name} className="w-full h-44 object-cover" />
      <div className="p-4 space-y-4">
        <div className="flex justify-between items-start">
          <div>
            <h2 className="text-xl font-black text-slate-900">{selectedCrop.name}</h2>
            <p className="text-xs text-slate-500">{selectedCrop.variety}</p>
          </div>
          <span className="text-xs font-bold px-2.5 py-1 rounded-full bg-emerald-100 text-emerald-800">
            {selectedCrop.status}
          </span>
        </div>

        <div className="bg-white p-3 rounded-xl border border-slate-200 grid grid-cols-2 gap-3 text-xs">
          <div>
            <span className="text-slate-400">Farm Area</span>
            <p className="font-bold text-slate-800">{selectedCrop.area}</p>
          </div>
          <div>
            <span className="text-slate-400">Planting Date</span>
            <p className="font-bold text-slate-800">{selectedCrop.plantingDate}</p>
          </div>
          <div>
            <span className="text-slate-400">Expected Harvest</span>
            <p className="font-bold text-slate-800">{selectedCrop.expectedHarvest}</p>
          </div>
          <div>
            <span className="text-slate-400">Current Status</span>
            <p className="font-bold text-emerald-700">{selectedCrop.status}</p>
          </div>
        </div>

        {selectedCrop.notes && (
          <div className="bg-slate-100 p-3 rounded-xl text-xs text-slate-700">
            <span className="font-bold block mb-1">Notes:</span>
            {selectedCrop.notes}
          </div>
        )}

        <div className="space-y-2 pt-2">
          <button
            onClick={() => setCurrentRoute('crop_health')}
            className="w-full bg-teal-700 hover:bg-teal-800 text-white font-bold text-xs py-2.5 rounded-lg flex items-center justify-center gap-1.5"
          >
            <HeartPulse className="w-4 h-4" /> Check Crop Health
          </button>
          <button
            onClick={handleDelete}
            className="w-full border border-red-300 text-red-600 hover:bg-red-50 font-bold text-xs py-2 rounded-lg"
          >
            Delete Crop
          </button>
        </div>
      </div>
    </div>
  );
}

// 5. Check Crop Health View
function CropHealthView({ setCurrentRoute }: any) {
  const [selectedCropName, setSelectedCropName] = useState('Tomato');
  const [photoSelected, setPhotoSelected] = useState(false);

  return (
    <div className="p-4 space-y-4">
      <div className="bg-teal-50 border border-teal-200 rounded-xl p-3.5 flex items-center gap-3">
        <div className="w-10 h-10 rounded-full bg-teal-700 text-white flex items-center justify-center">
          <HeartPulse className="w-5 h-5" />
        </div>
        <div>
          <h3 className="font-bold text-sm text-teal-900">Check Crop Health</h3>
          <p className="text-xs text-teal-700">Take a photo of your crop to check for possible problems.</p>
        </div>
      </div>

      <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-3">
        <div>
          <label className="text-xs font-bold text-slate-700">Select Crop</label>
          <select
            value={selectedCropName}
            onChange={(e) => setSelectedCropName(e.target.value)}
            className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs"
          >
            <option>Tomato</option>
            <option>Wheat</option>
            <option>Onion</option>
            <option>Sugarcane</option>
          </select>
        </div>

        {/* Photo Area */}
        <div className="h-44 rounded-xl border-2 border-dashed border-slate-300 flex flex-col items-center justify-center text-slate-400 p-4">
          {photoSelected ? (
            <img
              src="https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80"
              alt="Preview"
              className="w-full h-full object-cover rounded-lg"
            />
          ) : (
            <>
              <Camera className="w-8 h-8 mb-2 text-slate-400" />
              <p className="text-xs font-semibold text-slate-600">No photo taken yet</p>
              <p className="text-[11px] text-slate-400">Ensure good light on leaves</p>
            </>
          )}
        </div>

        <div className="grid grid-cols-2 gap-2">
          <button
            type="button"
            onClick={() => setPhotoSelected(true)}
            className="py-2 px-3 border border-emerald-600 text-emerald-700 font-bold text-xs rounded-lg flex items-center justify-center gap-1"
          >
            <Camera className="w-3.5 h-3.5" /> Take Photo
          </button>
          <button
            type="button"
            onClick={() => setPhotoSelected(true)}
            className="py-2 px-3 border border-emerald-600 text-emerald-700 font-bold text-xs rounded-lg flex items-center justify-center gap-1"
          >
            Choose Photo
          </button>
        </div>

        <button
          onClick={() => setCurrentRoute('crop_health_result')}
          className="w-full bg-emerald-700 hover:bg-emerald-800 text-white font-bold text-xs py-2.5 rounded-lg mt-2"
        >
          Check Crop
        </button>
      </div>
    </div>
  );
}

// 6. Crop Health Result View
function CropHealthResultView({ setCurrentRoute }: any) {
  return (
    <div className="p-4 space-y-4">
      <div className="bg-amber-50 border border-amber-200 rounded-xl p-4">
        <div className="flex items-center gap-2 text-amber-900 font-extrabold text-base">
          <AlertTriangle className="w-5 h-5 text-amber-600" /> Possible Leaf Spot
        </div>
        <p className="text-xs text-amber-800 mt-1">Some spots may be affecting the leaves.</p>
        <span className="inline-block mt-2 px-2 py-0.5 rounded bg-amber-200 text-amber-900 font-bold text-[10px]">
          Crop: Tomato
        </span>
      </div>

      <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-2">
        <h4 className="text-xs font-bold text-slate-900 uppercase tracking-wider">What You Can Do</h4>
        <ul className="text-xs text-slate-700 space-y-1.5 list-disc pl-4">
          <li>Remove badly affected leaves</li>
          <li>Keep the plants clean</li>
          <li>Avoid too much water on leaves</li>
        </ul>
      </div>

      <div className="bg-white p-4 rounded-xl border border-slate-200 space-y-2">
        <h4 className="text-xs font-bold text-slate-900 uppercase tracking-wider">Prevention</h4>
        <ul className="text-xs text-slate-700 space-y-1.5 list-disc pl-4">
          <li>Keep enough space between plants</li>
          <li>Check leaves regularly</li>
        </ul>
      </div>

      <div className="bg-slate-100 p-3 rounded-xl text-[11px] text-slate-500 leading-relaxed">
        <b>Important note:</b> This result is only a guide. For serious problems, ask a farming expert.
      </div>

      <button
        onClick={() => setCurrentRoute('home')}
        className="w-full bg-emerald-700 text-white font-bold text-xs py-2.5 rounded-lg"
      >
        Back to Farm
      </button>
    </div>
  );
}

// 7. Sell Crop View
function SellCropView({ setCropSales, setCurrentRoute, showToast }: any) {
  const [cropName, setCropName] = useState('Tomato');
  const [quantity, setQuantity] = useState('500');
  const [unit, setUnit] = useState('kg');
  const [price, setPrice] = useState('25');
  const [location, setLocation] = useState('Pune');
  const [desc, setDesc] = useState('Fresh harvest ready for direct dispatch.');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const newSale = {
      id: 'cs_' + Date.now(),
      cropName,
      quantity,
      unit,
      price: Number(price),
      location,
      status: 'Available',
      image: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80',
      description: desc,
    };
    setCropSales((prev: any) => [newSale, ...prev]);
    showToast('Crop posted for sale');
    setCurrentRoute('my_crop_sales');
  };

  return (
    <div className="p-4 space-y-4">
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-base font-bold text-slate-800">Sell Crop</h2>
          <p className="text-xs text-slate-500">Sell your crop directly to buyers.</p>
        </div>
        <button
          onClick={() => setCurrentRoute('my_crop_sales')}
          className="text-xs font-bold text-emerald-700 hover:underline"
        >
          My Sales
        </button>
      </div>

      <form onSubmit={handleSubmit} className="bg-white p-4 rounded-xl border border-slate-200 space-y-3 shadow-sm">
        <div>
          <label className="text-xs font-bold text-slate-700">Crop Name *</label>
          <input
            type="text"
            required
            value={cropName}
            onChange={(e) => setCropName(e.target.value)}
            className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs"
          />
        </div>
        <div className="grid grid-cols-3 gap-2">
          <div className="col-span-2">
            <label className="text-xs font-bold text-slate-700">Quantity *</label>
            <input
              type="number"
              required
              value={quantity}
              onChange={(e) => setQuantity(e.target.value)}
              className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs"
            />
          </div>
          <div>
            <label className="text-xs font-bold text-slate-700">Unit</label>
            <select
              value={unit}
              onChange={(e) => setUnit(e.target.value)}
              className="w-full mt-1 px-2 py-2 rounded-lg border border-slate-300 text-xs"
            >
              <option>kg</option>
              <option>quintal</option>
              <option>ton</option>
            </select>
          </div>
        </div>
        <div>
          <label className="text-xs font-bold text-slate-700">Price (₹ per unit) *</label>
          <input
            type="number"
            required
            value={price}
            onChange={(e) => setPrice(e.target.value)}
            className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs"
          />
        </div>
        <div>
          <label className="text-xs font-bold text-slate-700">Location *</label>
          <input
            type="text"
            required
            value={location}
            onChange={(e) => setLocation(e.target.value)}
            className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs"
          />
        </div>
        <div>
          <label className="text-xs font-bold text-slate-700">Description</label>
          <textarea
            rows={2}
            value={desc}
            onChange={(e) => setDesc(e.target.value)}
            className="w-full mt-1 px-3 py-2 rounded-lg border border-slate-300 text-xs"
          ></textarea>
        </div>
        <button
          type="submit"
          className="w-full bg-emerald-700 hover:bg-emerald-800 text-white font-bold text-xs py-2.5 rounded-lg shadow-sm"
        >
          Post for Sale
        </button>
      </form>
    </div>
  );
}

// 8. My Crop Sales View
function MyCropSalesView({ cropSales, setCropSales, setCurrentRoute, showToast }: any) {
  return (
    <div className="p-4 space-y-4">
      <div className="flex justify-between items-center">
        <h2 className="text-base font-bold text-slate-800">My Crop Sales</h2>
        <button
          onClick={() => setCurrentRoute('sell_crop')}
          className="bg-emerald-700 text-white text-xs font-bold px-3 py-1.5 rounded-lg"
        >
          + Post Crop
        </button>
      </div>

      <div className="space-y-3">
        {cropSales.map((item: any) => (
          <div key={item.id} className="bg-white p-3.5 rounded-xl border border-slate-200 shadow-sm space-y-2">
            <div className="flex justify-between items-start">
              <div>
                <h3 className="font-bold text-sm text-slate-900">{item.cropName}</h3>
                <p className="text-xs text-emerald-700 font-semibold">
                  {item.quantity} {item.unit} • ₹{item.price}/{item.unit}
                </p>
              </div>
              <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800">
                {item.status}
              </span>
            </div>
            <p className="text-[11px] text-slate-500">Location: {item.location}</p>
            <div className="pt-2 border-t border-slate-100 flex justify-end gap-2">
              <button
                onClick={() => {
                  setCropSales((prev: any) => prev.filter((s: any) => s.id !== item.id));
                  showToast('Listing removed');
                }}
                className="text-xs text-red-600 font-bold hover:underline"
              >
                Remove
              </button>
            </div>
          </div>
        ))}
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
  const [tab, setTab] = useState<'find' | 'requests'>('find');

  const handleRequest = (worker: any) => {
    const newReq = {
      id: 'lr_' + Date.now(),
      workerName: worker.name,
      work: worker.work,
      date: 'Tomorrow',
      workersNeeded: 2,
      dailyWage: worker.dailyWage,
      status: 'Requested',
    };
    setLabourRequests((prev: any) => [newReq, ...prev]);
    showToast(`Request sent to ${worker.name}`);
    setTab('requests');
  };

  return (
    <div className="p-4 space-y-4">
      <div className="flex bg-slate-200 p-1 rounded-xl">
        <button
          onClick={() => setTab('find')}
          className={`flex-1 py-1.5 text-xs font-bold rounded-lg transition-all ${
            tab === 'find' ? 'bg-white text-slate-900 shadow-sm' : 'text-slate-600'
          }`}
        >
          Find Labour
        </button>
        <button
          onClick={() => setTab('requests')}
          className={`flex-1 py-1.5 text-xs font-bold rounded-lg transition-all ${
            tab === 'requests' ? 'bg-white text-slate-900 shadow-sm' : 'text-slate-600'
          }`}
        >
          My Requests ({labourRequests.length})
        </button>
      </div>

      {tab === 'find' ? (
        <div className="space-y-3">
          {labourWorkers.map((w: any) => (
            <div key={w.id} className="bg-white p-3.5 rounded-xl border border-slate-200 flex items-center gap-3 shadow-sm">
              <img src={w.image} alt={w.name} className="w-14 h-14 rounded-full object-cover" />
              <div className="flex-1">
                <div className="flex justify-between items-start">
                  <h3 className="font-bold text-sm text-slate-900">{w.name}</h3>
                  <span className="text-xs font-bold text-emerald-700">₹{w.dailyWage}/day</span>
                </div>
                <p className="text-xs text-slate-500">
                  {w.work} • {w.experience}
                </p>
                <p className="text-[11px] text-slate-400">{w.distance}</p>
              </div>
              <button
                onClick={() => handleRequest(w)}
                className="bg-emerald-700 text-white text-xs font-bold px-3 py-1.5 rounded-lg hover:bg-emerald-800"
              >
                Request
              </button>
            </div>
          ))}
        </div>
      ) : (
        <div className="space-y-3">
          {labourRequests.map((req: any) => (
            <div key={req.id} className="bg-white p-3.5 rounded-xl border border-slate-200 space-y-1 shadow-sm">
              <div className="flex justify-between">
                <h3 className="font-bold text-sm text-slate-900">{req.workerName}</h3>
                <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-blue-100 text-blue-800">
                  {req.status}
                </span>
              </div>
              <p className="text-xs text-slate-600">Work: {req.work}</p>
              <p className="text-xs text-slate-500">
                Date: {req.date} • {req.workersNeeded} Workers • ₹{req.dailyWage}/day
              </p>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

// 11. Farm Products View
function ProductsView({ products, cart, setCart, setCurrentRoute, showToast }: any) {
  const [activeCategory, setActiveCategory] = useState('All');

  const filtered = activeCategory === 'All' ? products : products.filter((p: any) => p.category === activeCategory);

  const addToCart = (product: any) => {
    setCart((prev: any) => {
      const exists = prev.find((item: any) => item.product.id === product.id);
      if (exists) {
        return prev.map((item: any) =>
          item.product.id === product.id ? { ...item, quantity: item.quantity + 1 } : item
        );
      }
      return [...prev, { product, quantity: 1 }];
    });
    showToast('Added to cart');
  };

  return (
    <div className="p-4 space-y-4">
      <div className="flex justify-between items-center">
        <h2 className="text-base font-bold text-slate-800">Buy Farm Products</h2>
        <button
          onClick={() => setCurrentRoute('cart')}
          className="relative p-2 bg-white rounded-lg border border-slate-200 text-slate-700"
        >
          <ShoppingCart className="w-5 h-5" />
          {cart.length > 0 && (
            <span className="absolute -top-1 -right-1 w-4 h-4 bg-emerald-600 text-white rounded-full text-[10px] font-bold flex items-center justify-center">
              {cart.length}
            </span>
          )}
        </button>
      </div>

      {/* Category Pills */}
      <div className="flex gap-1.5 overflow-x-auto pb-1 text-xs">
        {['All', 'Seeds', 'Fertilizers', 'Tools'].map((cat) => (
          <button
            key={cat}
            onClick={() => setActiveCategory(cat)}
            className={`px-3 py-1 rounded-full whitespace-nowrap font-bold ${
              activeCategory === cat ? 'bg-emerald-700 text-white' : 'bg-white border border-slate-200 text-slate-600'
            }`}
          >
            {cat}
          </button>
        ))}
      </div>

      <div className="grid grid-cols-2 gap-3">
        {filtered.map((prod: any) => (
          <div key={prod.id} className="bg-white rounded-xl border border-slate-200 overflow-hidden shadow-sm flex flex-col justify-between">
            <img src={prod.image} alt={prod.name} className="w-full h-28 object-cover" />
            <div className="p-2.5 flex-1 flex flex-col justify-between">
              <div>
                <span className="text-[9px] font-bold px-1.5 py-0.5 rounded bg-slate-100 text-slate-600">
                  {prod.category}
                </span>
                <h4 className="font-bold text-xs text-slate-900 mt-1 line-clamp-1">{prod.name}</h4>
                <p className="text-xs font-black text-emerald-700 mt-1">₹{prod.price}</p>
              </div>
              <button
                onClick={() => addToCart(prod)}
                className="mt-2 w-full bg-emerald-700 text-white font-bold text-[11px] py-1.5 rounded-lg hover:bg-emerald-800"
              >
                Add to Cart
              </button>
            </div>
          </div>
        ))}
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
function ProfileView({ setCurrentRoute }: any) {
  return (
    <div className="p-4 space-y-4">
      <div className="bg-white p-5 rounded-2xl border border-slate-200 text-center shadow-sm">
        <div className="w-16 h-16 rounded-full bg-emerald-700 text-white font-bold text-xl flex items-center justify-center mx-auto mb-2">
          SP
        </div>
        <h2 className="font-black text-lg text-slate-900">Suresh Patil</h2>
        <p className="text-xs text-slate-500">+91 98765 43210 • Pune, Maharashtra</p>
        <div className="mt-3 pt-3 border-t border-slate-100 flex justify-around text-xs">
          <div>
            <span className="text-slate-400 block">Farm Size</span>
            <span className="font-bold text-slate-800">5 Acres</span>
          </div>
          <div>
            <span className="text-slate-400 block">Main Crops</span>
            <span className="font-bold text-emerald-700">Tomato, Wheat, Onion</span>
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
      </div>
    </div>
  );
}

// 19. Help View
function HelpView() {
  return (
    <div className="p-4 space-y-4">
      <div className="bg-emerald-800 text-white p-4 rounded-xl">
        <h3 className="font-bold text-base">How can we help you?</h3>
        <p className="text-xs text-emerald-100 mt-1">Our Kisan helpline is available 7 days a week.</p>
        <button
          onClick={() => alert('Dialing Toll Free: 1800-180-1551')}
          className="mt-3 w-full bg-white text-emerald-800 font-bold text-xs py-2 rounded-lg"
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
