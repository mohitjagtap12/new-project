import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';
import '../../data/mock/mock_contracts.dart';
import '../../data/mock/mock_crops.dart';
import '../../data/mock/mock_labour.dart';
import '../../data/mock/mock_notifications.dart';
import '../../data/mock/mock_orders.dart';
import '../../data/mock/mock_products.dart';
import '../../models/contract.dart';
import '../../models/crop.dart';
import '../../models/crop_health.dart';
import '../../models/labour.dart';
import '../../models/notification.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/desktop_sidebar.dart';
import 'contracts/contract_details_screen.dart';
import 'contracts/farm_contracts_screen.dart';
import 'crop_health/check_crop_health_screen.dart';
import 'crop_health/crop_health_result_screen.dart';
import 'crops/add_crop_screen.dart';
import 'crops/crop_details_screen.dart';
import 'crops/my_crops_screen.dart';
import 'dashboard/farmer_dashboard_screen.dart';
import '../../models/farm_waste.dart';
import 'farm_waste/sell_farm_waste_screen.dart';
import 'farm_waste/my_waste_listings_screen.dart';
import 'farm_waste/waste_marketplace_screen.dart';
import 'farm_waste/waste_details_screen.dart';
import 'help/help_screen.dart';
import 'labour/find_labour_screen.dart';
import 'labour/labour_details_screen.dart';
import 'labour/send_labour_request_screen.dart';
import 'labour/my_requests_screen.dart';
import 'labour/labour_request_details_screen.dart';
import '../../core/state/agro_state.dart';
import 'market/market_screen.dart';
import 'notifications/notifications_screen.dart';
import 'orders/my_orders_screen.dart';
import 'orders/order_details_screen.dart';
import 'products/buy_farm_products_screen.dart';
import 'products/cart_screen.dart';
import 'products/checkout_screen.dart';
import 'products/product_details_screen.dart';
import 'profile/my_profile_screen.dart';
import 'sell_crop/crop_sale_details_screen.dart';
import 'sell_crop/my_crop_sales_screen.dart';
import 'sell_crop/sell_crop_screen.dart';

class FarmerShell extends StatefulWidget {
  const FarmerShell({Key? key}) : super(key: key);

  @override
  State<FarmerShell> createState() => _FarmerShellState();
}

class _FarmerShellState extends State<FarmerShell> {
  // Navigation State
  String _currentRoute = 'home';
  int _bottomNavIndex = 0;

  // Domain State
  late List<Crop> _crops;
  late List<CropSale> _cropSales;
  late List<LabourWorker> _labourWorkers;
  late List<LabourRequest> _labourRequests;
  late List<FarmProduct> _products;
  late List<CartItem> _cartItems;
  late List<FarmContract> _contracts;
  late List<AgroOrder> _orders;
  late List<AgroNotification> _notifications;
  late List<FarmWaste> _wasteListings;

  // Selected item states for detail views
  Crop? _selectedCrop;
  Crop? _cropToEdit;
  Crop? _cropForSale;
  CropSale? _saleToEdit;
  CropSale? _selectedSale;
  LabourWorker? _selectedLabourWorker;
  LabourRequest? _selectedLabourRequest;
  FarmProduct? _selectedProduct;
  FarmContract? _selectedContract;
  AgroOrder? _selectedOrder;
  FarmWaste? _selectedWaste;
  FarmWaste? _wasteToEdit;
  String _healthCropName = 'Tomato';
  String _healthCropImage = 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80';
  CropHealthResult? _healthResult;

  @override
  void initState() {
    super.initState();
    _crops = List.from(MockCrops.initialCrops);
    _cropSales = List.from(MockCrops.initialCropSales);
    _labourWorkers = List.from(MockLabour.initialWorkers);
    _labourRequests = List.from(MockLabour.initialRequests);
    _products = List.from(MockProducts.initialProducts);
    _cartItems = [
      CartItem(product: _products[0], quantity: 2),
      CartItem(product: _products[2], quantity: 1),
    ];
    _contracts = List.from(MockContracts.initialContracts);
    _orders = List.from(MockOrders.initialOrders);
    _notifications = List.from(MockNotifications.initialNotifications);
    _wasteListings = List.from(AgroState.instance.wasteListings);
  }

  final List<String> _routeHistory = [];

  void _navigateTo(String route, {bool addToHistory = true}) {
    setState(() {
      if (addToHistory && _currentRoute != route) {
        _routeHistory.add(_currentRoute);
      }
      _currentRoute = route;
      // Sync bottom nav index if matching primary tabs
      if (route == 'home') _bottomNavIndex = 0;
      if (route == 'market') _bottomNavIndex = 1;
      if (route == 'orders') _bottomNavIndex = 2;
      if (route == 'notifications') _bottomNavIndex = 3;
      if (route == 'profile') _bottomNavIndex = 4;
    });
  }

  void _handleBack() {
    if (_routeHistory.isNotEmpty) {
      final prev = _routeHistory.removeLast();
      _navigateTo(prev, addToHistory: false);
    } else {
      _navigateTo('home', addToHistory: false);
    }
  }

  void _onBottomNavTapped(int index) {
    _routeHistory.clear();
    setState(() {
      _bottomNavIndex = index;
      switch (index) {
        case 0:
          _currentRoute = 'home';
          break;
        case 1:
          _currentRoute = 'market';
          break;
        case 2:
          _currentRoute = 'orders';
          break;
        case 3:
          _currentRoute = 'notifications';
          break;
        case 4:
          _currentRoute = 'profile';
          break;
      }
    });
  }

  int get _unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out of your AgroWorld farmer account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AgroColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              AuthService.instance.logout();
              AppUtils.showSnackBar(context, 'Logged out successfully');
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          appBar: isDesktop
              ? null
              : AppHeader(
                  title: _getTitleForRoute(_currentRoute),
                  unreadCount: _unreadNotificationsCount,
                  showBackButton: _currentRoute != 'home' &&
                      _currentRoute != 'market' &&
                      _currentRoute != 'orders' &&
                      _currentRoute != 'notifications' &&
                      _currentRoute != 'profile',
                  onBackTap: _handleBack,
                  onNotificationTap: () => _navigateTo('notifications'),
                  onProfileTap: () => _navigateTo('profile'),
                ),
          body: Row(
            children: [
              // Desktop Sidebar on Windows / Large Screens
              if (isDesktop)
                DesktopSidebar(
                  selectedRoute: _currentRoute,
                  unreadNotifications: _unreadNotificationsCount,
                  onSelectRoute: (route) => _navigateTo(route),
                  onLogout: _handleLogout,
                ),
              // Main content body
              Expanded(
                child: Container(
                  color: AgroColors.surfaceVariant,
                  child: _buildCurrentScreen(),
                ),
              ),
            ],
          ),
          bottomNavigationBar: isDesktop
              ? null
              : FarmerBottomNavigation(
                  currentIndex: _bottomNavIndex,
                  unreadNotifications: _unreadNotificationsCount,
                  onTap: _onBottomNavTapped,
                ),
        );
      },
    );
  }

  String _getTitleForRoute(String route) {
    switch (route) {
      case 'home':
        return 'AgroWorld';
      case 'crops':
        return 'My Crops';
      case 'add_crop':
        return 'Add Crop';
      case 'crop_details':
        return 'Crop Details';
      case 'crop_health':
        return 'Check Crop Health';
      case 'crop_health_result':
        return 'Crop Health Result';
      case 'sell_crop':
        return _saleToEdit != null ? 'Edit Crop Sale' : 'Sell Crop';
      case 'my_crop_sales':
        return 'My Crop Sales';
      case 'sale_details':
        return 'Sale Listing Details';
      case 'farm_waste':
        return 'Sell Farm Waste';
      case 'labour':
        return 'Find Labour';
      case 'my_labour_requests':
        return 'My Requests';
      case 'products':
        return 'Buy Farm Products';
      case 'product_details':
        return 'Product Details';
      case 'cart':
        return 'Cart';
      case 'checkout':
        return 'Checkout';
      case 'contracts':
        return 'Farm Contracts';
      case 'contract_details':
        return 'Contract Details';
      case 'orders':
        return 'My Orders';
      case 'order_details':
        return 'Order Details';
      case 'market':
        return 'Market';
      case 'notifications':
        return 'Notifications';
      case 'profile':
        return 'My Profile';
      case 'help':
        return 'Help';
      default:
        return 'AgroWorld';
    }
  }

  Widget _buildCurrentScreen() {
    switch (_currentRoute) {
      case 'home':
        return FarmerDashboardScreen(
          cropsCount: _crops.length,
          ordersCount: _orders.length,
          labourRequestsCount: _labourRequests.length,
          salesCount: _cropSales.where((s) => s.status != 'Cancelled').length,
          onNavigateCrops: () => _navigateTo('crops'),
          onNavigateOrders: () => _navigateTo('orders'),
          onNavigateLabour: () => _navigateTo('labour'),
          onNavigateSales: () => _navigateTo('my_crop_sales'),
          onNavigateAddCrop: () {
            setState(() => _cropToEdit = null);
            _navigateTo('add_crop');
          },
          onNavigateSellCrop: () {
            setState(() {
              _cropForSale = null;
              _saleToEdit = null;
            });
            _navigateTo('sell_crop');
          },
          onNavigateCropHealth: () => _navigateTo('crop_health'),
          onNavigateFarmWaste: () => _navigateTo('farm_waste'),
          onNavigateProducts: () => _navigateTo('products'),
          onNavigateContracts: () => _navigateTo('contracts'),
          onNavigateMarket: () => _navigateTo('market'),
          onNavigateNotifications: () => _navigateTo('notifications'),
          onNavigateProfile: () => _navigateTo('profile'),
        );

      case 'crops':
        return MyCropsScreen(
          crops: _crops,
          onAddCrop: () {
            setState(() => _cropToEdit = null);
            _navigateTo('add_crop');
          },
          onViewCrop: (crop) {
            setState(() => _selectedCrop = crop);
            _navigateTo('crop_details');
          },
          onEditCrop: (crop) {
            setState(() => _cropToEdit = crop);
            _navigateTo('add_crop');
          },
        );

      case 'add_crop':
        return AddCropScreen(
          cropToEdit: _cropToEdit,
          onCancel: _handleBack,
          onSave: (savedCrop) {
            setState(() {
              final idx = _crops.indexWhere((c) => c.id == savedCrop.id);
              if (idx >= 0) {
                _crops[idx] = savedCrop;
                if (_selectedCrop?.id == savedCrop.id) {
                  _selectedCrop = savedCrop;
                }
              } else {
                _crops.insert(0, savedCrop);
                _selectedCrop = savedCrop;
              }
            });
            _navigateTo('crops');
          },
        );

      case 'crop_details':
        if (_selectedCrop == null && _crops.isNotEmpty) {
          _selectedCrop = _crops.first;
        }
        if (_selectedCrop == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No crop selected', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _navigateTo('crops'),
                  child: const Text('Back to My Crops'),
                ),
              ],
            ),
          );
        }
        return CropDetailsScreen(
          crop: _selectedCrop!,
          onBack: _handleBack,
          onEditCrop: () {
            setState(() => _cropToEdit = _selectedCrop);
            _navigateTo('add_crop');
          },
          onDeleteCrop: () {
            setState(() {
              _crops.removeWhere((c) => c.id == _selectedCrop!.id);
              _selectedCrop = null;
            });
            _navigateTo('crops');
          },
          onCheckCropHealth: () {
            setState(() {
              _healthCropName = _selectedCrop!.name;
              _healthCropImage = _selectedCrop!.image;
            });
            _navigateTo('crop_health');
          },
          onSellCrop: () {
            setState(() {
              _cropForSale = _selectedCrop;
              _saleToEdit = null;
            });
            _navigateTo('sell_crop');
          },
        );

      case 'crop_health':
        return CheckCropHealthScreen(
          initialCropName: _healthCropName,
          initialCropImage: _healthCropImage,
          availableCrops: _crops,
          onBack: _handleBack,
          onCheckResult: (result) {
            setState(() {
              _healthResult = result;
              _healthCropName = result.cropName;
              _healthCropImage = result.imagePath;
            });
            _navigateTo('crop_health_result');
          },
        );

      case 'crop_health_result':
        if (_healthResult == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No diagnosis result available', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _navigateTo('crop_health'),
                  child: const Text('Check Crop Health'),
                ),
              ],
            ),
          );
        }
        return CropHealthResultScreen(
          result: _healthResult!,
          onBackToCropDetails: () {
            if (_selectedCrop != null) {
              _navigateTo('crop_details');
            } else {
              _navigateTo('crops');
            }
          },
          onCheckAgain: () {
            _navigateTo('crop_health');
          },
          onBackToDashboard: () => _navigateTo('home'),
        );

      case 'sell_crop':
        return SellCropScreen(
          initialCrop: _cropForSale,
          saleToEdit: _saleToEdit,
          availableCrops: _crops,
          onBack: _handleBack,
          onPostSale: (sale) {
            setState(() {
              _cropSales.insert(0, sale);
              _cropForSale = null;
              _saleToEdit = null;
            });
          },
          onUpdateSale: (sale) {
            setState(() {
              final idx = _cropSales.indexWhere((s) => s.id == sale.id);
              if (idx >= 0) {
                _cropSales[idx] = sale;
              }
              if (_selectedSale?.id == sale.id) {
                _selectedSale = sale;
              }
              _cropForSale = null;
              _saleToEdit = null;
            });
          },
          onViewMySales: () {
            setState(() {
              _cropForSale = null;
              _saleToEdit = null;
            });
            _navigateTo('my_crop_sales');
          },
        );

      case 'my_crop_sales':
        return MyCropSalesScreen(
          sales: _cropSales,
          onBack: _handleBack,
          onAddNewSale: () {
            setState(() {
              _cropForSale = null;
              _saleToEdit = null;
            });
            _navigateTo('sell_crop');
          },
          onRemoveSale: (sale) {
            setState(() {
              _cropSales.removeWhere((s) => s.id == sale.id);
            });
          },
          onCancelSale: (sale) {
            setState(() {
              final idx = _cropSales.indexWhere((s) => s.id == sale.id);
              if (idx >= 0) {
                _cropSales[idx] = sale;
              }
              if (_selectedSale?.id == sale.id) {
                _selectedSale = sale;
              }
            });
          },
          onEditSale: (sale) {
            setState(() {
              _saleToEdit = sale;
              _cropForSale = null;
            });
            _navigateTo('sell_crop');
          },
          onViewSaleDetails: (sale) {
            setState(() {
              _selectedSale = sale;
            });
            _navigateTo('sale_details');
          },
        );

      case 'sale_details':
        if (_selectedSale == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sale listing not found'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _navigateTo('my_crop_sales'),
                  child: const Text('Back to My Sales'),
                ),
              ],
            ),
          );
        }
        return CropSaleDetailsScreen(
          sale: _selectedSale!,
          onBack: () => _navigateTo('my_crop_sales'),
          onEditSale: () {
            setState(() {
              _saleToEdit = _selectedSale;
              _cropForSale = null;
            });
            _navigateTo('sell_crop');
          },
          onCancelSale: (cancelledSale) {
            setState(() {
              final idx = _cropSales.indexWhere((s) => s.id == cancelledSale.id);
              if (idx >= 0) {
                _cropSales[idx] = cancelledSale;
              }
              _selectedSale = cancelledSale;
            });
          },
        );

      case 'farm_waste':
      case 'sell_farm_waste':
        return SellFarmWasteScreen(
          wasteToEdit: _wasteToEdit,
          onWasteSaved: (savedWaste) {
            setState(() {
              final idx = _wasteListings.indexWhere((w) => w.id == savedWaste.id);
              if (idx != -1) {
                _wasteListings[idx] = savedWaste;
                AgroState.instance.updateWasteListing(savedWaste);
              } else {
                _wasteListings.insert(0, savedWaste);
                AgroState.instance.addWasteListing(savedWaste);
              }
              _wasteToEdit = null;
              _selectedWaste = savedWaste;
            });
            _navigateTo('my_waste_listings');
          },
          onCancel: () {
            setState(() => _wasteToEdit = null);
            _handleBack();
          },
          onViewMyListings: () => _navigateTo('my_waste_listings'),
        );

      case 'my_waste_listings':
        final myListings = _wasteListings
            .where((w) => w.sellerId == 'current_farmer' || w.sellerName == 'Suresh Patil')
            .toList();
        return MyWasteListingsScreen(
          listings: myListings,
          onSelectListing: (waste) {
            setState(() => _selectedWaste = waste);
            _navigateTo('waste_details');
          },
          onEditListing: (waste) {
            setState(() => _wasteToEdit = waste);
            _navigateTo('sell_farm_waste');
          },
          onCancelListing: (id) {
            setState(() {
              final idx = _wasteListings.indexWhere((w) => w.id == id);
              if (idx != -1) {
                _wasteListings[idx] = _wasteListings[idx].copyWith(status: 'Cancelled');
              }
              if (_selectedWaste?.id == id) {
                _selectedWaste = _selectedWaste?.copyWith(status: 'Cancelled');
              }
            });
            AgroState.instance.cancelWasteListing(id);
          },
          onMarkAsSold: (id) {
            setState(() {
              final idx = _wasteListings.indexWhere((w) => w.id == id);
              if (idx != -1) {
                _wasteListings[idx] = _wasteListings[idx].copyWith(status: 'Sold');
              }
              if (_selectedWaste?.id == id) {
                _selectedWaste = _selectedWaste?.copyWith(status: 'Sold');
              }
            });
            AgroState.instance.markWasteListingSold(id);
          },
          onAddNewListing: () {
            setState(() => _wasteToEdit = null);
            _navigateTo('sell_farm_waste');
          },
          onBrowseMarketplace: () => _navigateTo('waste_marketplace'),
          onBack: _handleBack,
        );

      case 'waste_marketplace':
        return WasteMarketplaceScreen(
          listings: _wasteListings,
          onSelectListing: (waste) {
            setState(() => _selectedWaste = waste);
            _navigateTo('waste_details');
          },
          onSellWaste: () {
            setState(() => _wasteToEdit = null);
            _navigateTo('sell_farm_waste');
          },
          onViewMyListings: () => _navigateTo('my_waste_listings'),
          onBack: _handleBack,
        );

      case 'waste_details':
        if (_selectedWaste == null && _wasteListings.isNotEmpty) {
          _selectedWaste = _wasteListings.first;
        }
        if (_selectedWaste == null) {
          return Center(
            child: ElevatedButton(
              onPressed: () => _navigateTo('waste_marketplace'),
              child: const Text('Back to Waste Marketplace'),
            ),
          );
        }
        final isOwner = _selectedWaste!.sellerId == 'current_farmer' ||
            _selectedWaste!.sellerName == 'Suresh Patil';
        return WasteDetailsScreen(
          waste: _selectedWaste!,
          isOwner: isOwner,
          onEdit: () {
            setState(() => _wasteToEdit = _selectedWaste);
            _navigateTo('sell_farm_waste');
          },
          onMarkAsSold: () {
            setState(() {
              final id = _selectedWaste!.id;
              final idx = _wasteListings.indexWhere((w) => w.id == id);
              if (idx != -1) {
                _wasteListings[idx] = _wasteListings[idx].copyWith(status: 'Sold');
              }
              _selectedWaste = _selectedWaste!.copyWith(status: 'Sold');
            });
            AgroState.instance.markWasteListingSold(_selectedWaste!.id);
          },
          onCancelListing: () {
            setState(() {
              final id = _selectedWaste!.id;
              final idx = _wasteListings.indexWhere((w) => w.id == id);
              if (idx != -1) {
                _wasteListings[idx] = _wasteListings[idx].copyWith(status: 'Cancelled');
              }
              _selectedWaste = _selectedWaste!.copyWith(status: 'Cancelled');
            });
            AgroState.instance.cancelWasteListing(_selectedWaste!.id);
          },
          onBack: _handleBack,
        );

      case 'labour':
        return FindLabourScreen(
          workers: _labourWorkers,
          onViewWorkerDetails: (worker) {
            setState(() => _selectedLabourWorker = worker);
            _navigateTo('labour_details');
          },
          onRequestWorker: (worker) {
            setState(() => _selectedLabourWorker = worker);
            _navigateTo('send_labour_request');
          },
          onViewMyRequests: () => _navigateTo('my_labour_requests'),
          myRequestsCount: _labourRequests.where((r) => r.isPending || r.isAccepted).length,
        );

      case 'labour_details':
        if (_selectedLabourWorker == null && _labourWorkers.isNotEmpty) {
          _selectedLabourWorker = _labourWorkers.first;
        }
        if (_selectedLabourWorker == null) {
          return Center(
            child: ElevatedButton(
              onPressed: () => _navigateTo('labour'),
              child: const Text('Back to Find Labour'),
            ),
          );
        }
        return LabourDetailsScreen(
          worker: _selectedLabourWorker!,
          onBack: _handleBack,
          onHireWorker: () {
            _navigateTo('send_labour_request');
          },
        );

      case 'send_labour_request':
        if (_selectedLabourWorker == null && _labourWorkers.isNotEmpty) {
          _selectedLabourWorker = _labourWorkers.first;
        }
        if (_selectedLabourWorker == null) {
          return Center(
            child: ElevatedButton(
              onPressed: () => _navigateTo('labour'),
              child: const Text('Select a Worker First'),
            ),
          );
        }
        return SendLabourRequestScreen(
          worker: _selectedLabourWorker!,
          onBack: _handleBack,
          onSubmitRequest: (newReq) {
            setState(() {
              _labourRequests.insert(0, newReq);
            });
            AgroState.instance.addLabourRequest(newReq);
            _navigateTo('my_labour_requests');
          },
        );

      case 'my_labour_requests':
        return MyRequestsScreen(
          requests: _labourRequests,
          onFindLabour: () => _navigateTo('labour'),
          onViewRequestDetails: (req) {
            setState(() => _selectedLabourRequest = req);
            _navigateTo('labour_request_details');
          },
          onCancelRequest: (cancelled) {
            setState(() {
              final idx = _labourRequests.indexWhere((r) => r.id == cancelled.id);
              if (idx != -1) {
                _labourRequests[idx] = cancelled;
              }
            });
            AgroState.instance.updateLabourRequest(cancelled);
          },
          onBack: () => _navigateTo('labour'),
        );

      case 'labour_request_details':
        if (_selectedLabourRequest == null && _labourRequests.isNotEmpty) {
          _selectedLabourRequest = _labourRequests.first;
        }
        if (_selectedLabourRequest == null) {
          return Center(
            child: ElevatedButton(
              onPressed: () => _navigateTo('my_labour_requests'),
              child: const Text('Back to My Requests'),
            ),
          );
        }
        return LabourRequestDetailsScreen(
          request: _selectedLabourRequest!,
          onBack: () => _navigateTo('my_labour_requests'),
          onCancelRequest: (cancelled) {
            setState(() {
              final idx = _labourRequests.indexWhere((r) => r.id == cancelled.id);
              if (idx != -1) {
                _labourRequests[idx] = cancelled;
              }
              _selectedLabourRequest = cancelled;
            });
            AgroState.instance.updateLabourRequest(cancelled);
          },
        );

      case 'products':
        return BuyFarmProductsScreen(
          products: _products,
          cartItemCount: _cartItems.fold(0, (sum, i) => sum + i.quantity),
          onViewProduct: (prod) {
            setState(() => _selectedProduct = prod);
            _navigateTo('product_details');
          },
          onOpenCart: () => _navigateTo('cart'),
          onQuickAddToCart: (prod, qty) {
            setState(() {
              final idx = _cartItems.indexWhere((item) => item.product.id == prod.id);
              if (idx >= 0) {
                _cartItems[idx].quantity += qty;
              } else {
                _cartItems.add(CartItem(product: prod, quantity: qty));
              }
            });
            AgroState.instance.addToCart(prod, quantity: qty);
          },
        );

      case 'product_details':
        if (_selectedProduct == null && _products.isNotEmpty) {
          _selectedProduct = _products.first;
        }
        if (_selectedProduct == null) {
          return const Center(child: Text('No product selected'));
        }
        return ProductDetailsScreen(
          product: _selectedProduct!,
          cartItemCount: _cartItems.fold(0, (sum, i) => sum + i.quantity),
          onOpenCart: () => _navigateTo('cart'),
          onAddToCart: (prod, qty) {
            setState(() {
              final idx = _cartItems.indexWhere((item) => item.product.id == prod.id);
              if (idx >= 0) {
                _cartItems[idx].quantity += qty;
              } else {
                _cartItems.add(CartItem(product: prod, quantity: qty));
              }
            });
            AgroState.instance.addToCart(prod, quantity: qty);
          },
          onBuyNow: (prod, qty) {
            setState(() {
              final idx = _cartItems.indexWhere((item) => item.product.id == prod.id);
              if (idx >= 0) {
                _cartItems[idx].quantity += qty;
              } else {
                _cartItems.add(CartItem(product: prod, quantity: qty));
              }
            });
            AgroState.instance.addToCart(prod, quantity: qty);
            _navigateTo('checkout');
          },
        );

      case 'cart':
        return CartScreen(
          cartItems: _cartItems,
          onRemoveItem: (item) {
            setState(() {
              _cartItems.removeWhere((ci) => ci.product.id == item.product.id);
            });
          },
          onUpdateQuantity: (item, newQty) {
            setState(() {
              item.quantity = newQty;
            });
          },
          onCheckout: () => _navigateTo('checkout'),
          onContinueShopping: () => _navigateTo('products'),
        );

      case 'checkout':
        return CheckoutScreen(
          cartItems: _cartItems,
          onOrderPlaced: (newOrder) {
            setState(() {
              _orders.insert(0, newOrder);
              _cartItems.clear();
            });
            _navigateTo('orders');
          },
        );

      case 'contracts':
        return FarmContractsScreen(
          contracts: _contracts,
          onViewContract: (contract) {
            setState(() => _selectedContract = contract);
            _navigateTo('contract_details');
          },
        );

      case 'contract_details':
        if (_selectedContract == null && _contracts.isNotEmpty) {
          _selectedContract = _contracts.first;
        }
        if (_selectedContract == null) {
          return const Center(child: Text('No contract selected'));
        }
        return ContractDetailsScreen(
          contract: _selectedContract!,
          onApply: (updated) {
            setState(() {
              final idx = _contracts.indexWhere((c) => c.id == updated.id);
              if (idx >= 0) {
                _contracts[idx] = updated;
              }
            });
          },
        );

      case 'orders':
        return MyOrdersScreen(
          orders: _orders,
          onViewOrder: (ord) {
            setState(() => _selectedOrder = ord);
            _navigateTo('order_details');
          },
          onGoToMarket: () => _navigateTo('products'),
        );

      case 'order_details':
        if (_selectedOrder == null && _orders.isNotEmpty) {
          _selectedOrder = _orders.first;
        }
        if (_selectedOrder == null) {
          return const Center(child: Text('No order selected'));
        }
        return OrderDetailsScreen(order: _selectedOrder!);

      case 'market':
        return MarketScreen(
          onSelectCrops: () => _navigateTo('crops'),
          onSelectProducts: () => _navigateTo('products'),
          onSelectWaste: () => _navigateTo('waste_marketplace'),
          onSelectContracts: () => _navigateTo('contracts'),
        );

      case 'notifications':
        return NotificationsScreen(notifications: _notifications);

      case 'profile':
        return MyProfileScreen(
          onOpenHelp: () => _navigateTo('help'),
        );

      case 'help':
        return const HelpScreen();

      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Screen not found'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _navigateTo('home'),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        );
    }
  }
}
