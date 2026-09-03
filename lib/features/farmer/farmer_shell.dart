import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/mock_contracts.dart';
import '../../data/mock/mock_crops.dart';
import '../../data/mock/mock_labour.dart';
import '../../data/mock/mock_notifications.dart';
import '../../data/mock/mock_orders.dart';
import '../../data/mock/mock_products.dart';
import '../../models/contract.dart';
import '../../models/crop.dart';
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
import 'farm_waste/sell_farm_waste_screen.dart';
import 'help/help_screen.dart';
import 'labour/find_labour_screen.dart';
import 'labour/my_requests_screen.dart';
import 'market/market_screen.dart';
import 'notifications/notifications_screen.dart';
import 'orders/my_orders_screen.dart';
import 'orders/order_details_screen.dart';
import 'products/buy_farm_products_screen.dart';
import 'products/cart_screen.dart';
import 'products/checkout_screen.dart';
import 'products/product_details_screen.dart';
import 'profile/my_profile_screen.dart';
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

  // Selected item states for detail views
  Crop? _selectedCrop;
  Crop? _cropToEdit;
  FarmProduct? _selectedProduct;
  FarmContract? _selectedContract;
  AgroOrder? _selectedOrder;
  String _healthCropName = 'Tomato';
  String _healthCropImage = 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80';

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
  }

  void _navigateTo(String route) {
    setState(() {
      _currentRoute = route;
      // Sync bottom nav index if matching primary tabs
      if (route == 'home') _bottomNavIndex = 0;
      if (route == 'market') _bottomNavIndex = 1;
      if (route == 'orders') _bottomNavIndex = 2;
      if (route == 'notifications') _bottomNavIndex = 3;
      if (route == 'profile') _bottomNavIndex = 4;
    });
  }

  void _onBottomNavTapped(int index) {
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
                  onBackTap: () => _navigateTo('home'),
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
        return 'Sell Crop';
      case 'my_crop_sales':
        return 'My Crop Sales';
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
          salesCount: _cropSales.length,
          onNavigateCrops: () => _navigateTo('crops'),
          onNavigateOrders: () => _navigateTo('orders'),
          onNavigateLabour: () => _navigateTo('labour'),
          onNavigateSales: () => _navigateTo('my_crop_sales'),
          onNavigateAddCrop: () {
            setState(() => _cropToEdit = null);
            _navigateTo('add_crop');
          },
          onNavigateSellCrop: () => _navigateTo('sell_crop'),
          onNavigateCropHealth: () => _navigateTo('crop_health'),
          onNavigateFarmWaste: () => _navigateTo('farm_waste'),
          onNavigateProducts: () => _navigateTo('products'),
          onNavigateContracts: () => _navigateTo('contracts'),
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
          onSave: (savedCrop) {
            setState(() {
              final idx = _crops.indexWhere((c) => c.id == savedCrop.id);
              if (idx >= 0) {
                _crops[idx] = savedCrop;
              } else {
                _crops.insert(0, savedCrop);
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
          return const Center(child: Text('No crop selected'));
        }
        return CropDetailsScreen(
          crop: _selectedCrop!,
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
        );

      case 'crop_health':
        return CheckCropHealthScreen(
          initialCropName: _healthCropName,
          onCheckResult: (cropName, imagePath) {
            setState(() {
              _healthCropName = cropName;
              _healthCropImage = imagePath;
            });
            _navigateTo('crop_health_result');
          },
        );

      case 'crop_health_result':
        return CropHealthResultScreen(
          cropName: _healthCropName,
          imagePath: _healthCropImage,
          onDone: () => _navigateTo('home'),
        );

      case 'sell_crop':
        return SellCropScreen(
          onPostSale: (sale) {
            setState(() {
              _cropSales.insert(0, sale);
            });
          },
          onViewMySales: () => _navigateTo('my_crop_sales'),
        );

      case 'my_crop_sales':
        return MyCropSalesScreen(
          sales: _cropSales,
          onAddNewSale: () => _navigateTo('sell_crop'),
          onRemoveSale: (sale) {
            setState(() {
              _cropSales.removeWhere((s) => s.id == sale.id);
            });
          },
          onEditSale: (sale) {
            // Edit quick action
            _navigateTo('sell_crop');
          },
        );

      case 'farm_waste':
        return SellFarmWasteScreen(
          onWastePosted: () {
            _navigateTo('my_crop_sales');
          },
        );

      case 'labour':
        return FindLabourScreen(
          workers: _labourWorkers,
          onRequestWorker: (worker, req) {
            setState(() {
              _labourRequests.insert(0, req);
            });
          },
          onViewMyRequests: () => _navigateTo('my_labour_requests'),
        );

      case 'my_labour_requests':
        return MyRequestsScreen(
          requests: _labourRequests,
          onFindLabour: () => _navigateTo('labour'),
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
          onAddToCart: (prod, qty) {
            setState(() {
              final idx = _cartItems.indexWhere((item) => item.product.id == prod.id);
              if (idx >= 0) {
                _cartItems[idx].quantity += qty;
              } else {
                _cartItems.add(CartItem(product: prod, quantity: qty));
              }
            });
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
          onSelectWaste: () => _navigateTo('farm_waste'),
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
