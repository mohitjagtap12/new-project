import 'package:flutter/material.dart';
import '../../data/mock/mock_contracts.dart';
import '../../data/mock/mock_crops.dart';
import '../../data/mock/mock_farm_waste.dart';
import '../../data/mock/mock_labour.dart';
import '../../data/mock/mock_notifications.dart';
import '../../data/mock/mock_orders.dart';
import '../../data/mock/mock_products.dart';
import '../../models/contract.dart';
import '../../models/crop.dart';
import '../../models/farm_waste.dart';
import '../../models/labour.dart';
import '../../models/notification.dart';
import '../../models/order.dart';
import '../../models/product.dart';

/// AgroState is the core centralized in-memory reactive state manager
/// for AgroWorld. It uses Flutter's native ChangeNotifier architecture
/// requiring zero external backend or heavy packages.
class AgroState extends ChangeNotifier {
  static final AgroState instance = AgroState._internal();
  factory AgroState() => instance;

  AgroState._internal() {
    _initData();
  }

  // Domain State Collections
  List<Crop> _crops = [];
  List<CropSale> _cropSales = [];
  List<FarmWaste> _wasteListings = [];
  List<LabourWorker> _labourWorkers = [];
  List<LabourRequest> _labourRequests = [];
  List<FarmProduct> _products = [];
  List<CartItem> _cartItems = [];
  List<FarmContract> _contracts = [];
  List<AgroOrder> _orders = [];
  List<AgroNotification> _notifications = [];

  // Getters
  List<Crop> get crops => List.unmodifiable(_crops);
  List<CropSale> get cropSales => List.unmodifiable(_cropSales);
  List<FarmWaste> get wasteListings => List.unmodifiable(_wasteListings);
  List<FarmWaste> get myWasteListings =>
      _wasteListings.where((w) => w.sellerId == 'current_farmer' || w.sellerName == 'Suresh Patil').toList();
  List<LabourWorker> get labourWorkers => List.unmodifiable(_labourWorkers);
  List<LabourRequest> get labourRequests => List.unmodifiable(_labourRequests);
  List<FarmProduct> get products => List.unmodifiable(_products);
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  List<FarmContract> get contracts => List.unmodifiable(_contracts);
  List<AgroOrder> get orders => List.unmodifiable(_orders);
  List<AgroNotification> get notifications => List.unmodifiable(_notifications);

  // Computed Properties
  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal => _cartItems.fold(0.0, (sum, item) => sum + item.total);
  int get unreadNotificationsCount =>
      _notifications.where((n) => !n.isRead).length;
  int get activeLabourRequestsCount =>
      _labourRequests.where((r) => r.isPending || r.isAccepted).length;
  int get activeWasteListingsCount =>
      myWasteListings.where((w) => w.isActive).length;

  void _initData() {
    _crops = List.from(MockCrops.initialCrops);
    _cropSales = List.from(MockCrops.initialCropSales);
    _wasteListings = List.from(MockFarmWaste.initialWasteListings);
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

  // Crop Actions
  void addCrop(Crop crop) {
    _crops.insert(0, crop);
    notifyListeners();
  }

  void updateCrop(Crop updated) {
    final index = _crops.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      _crops[index] = updated;
      notifyListeners();
    }
  }

  void deleteCrop(String id) {
    _crops.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // Crop Sale Actions
  void addCropSale(CropSale sale) {
    _cropSales.insert(0, sale);
    notifyListeners();
  }

  // Farm Waste Actions
  void addWasteListing(FarmWaste waste) {
    _wasteListings.insert(0, waste);
    notifyListeners();
  }

  void updateWasteListing(FarmWaste updated) {
    final index = _wasteListings.indexWhere((w) => w.id == updated.id);
    if (index != -1) {
      _wasteListings[index] = updated;
      notifyListeners();
    }
  }

  void cancelWasteListing(String id) {
    final index = _wasteListings.indexWhere((w) => w.id == id);
    if (index != -1) {
      _wasteListings[index] = _wasteListings[index].copyWith(status: 'Cancelled');
      notifyListeners();
    }
  }

  void markWasteListingSold(String id) {
    final index = _wasteListings.indexWhere((w) => w.id == id);
    if (index != -1) {
      _wasteListings[index] = _wasteListings[index].copyWith(status: 'Sold');
      notifyListeners();
    }
  }

  void deleteWasteListing(String id) {
    _wasteListings.removeWhere((w) => w.id == id);
    notifyListeners();
  }

  // Labour Actions
  void addLabourRequest(LabourRequest request) {
    _labourRequests.insert(0, request);
    notifyListeners();
  }

  void updateLabourRequest(LabourRequest request) {
    final index = _labourRequests.indexWhere((r) => r.id == request.id);
    if (index != -1) {
      _labourRequests[index] = request;
      notifyListeners();
    }
  }

  void cancelLabourRequest(String requestId) {
    final index = _labourRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _labourRequests[index] = _labourRequests[index].copyWith(status: 'Cancelled');
      notifyListeners();
    }
  }

  // Cart Actions
  void addToCart(FarmProduct product, {int quantity = 1}) {
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    final maxAvailable = product.availableQuantity > 0 ? product.availableQuantity : 1;
    if (existingIndex != -1) {
      final newQty = (_cartItems[existingIndex].quantity + quantity).clamp(1, maxAvailable);
      _cartItems[existingIndex].quantity = newQty;
    } else {
      final newQty = quantity.clamp(1, maxAvailable);
      _cartItems.add(CartItem(product: product, quantity: newQty));
    }
    notifyListeners();
  }

  void updateCartQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _cartItems[index].quantity = quantity;
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Order Actions
  AgroOrder placeOrder({
    required String deliveryAddress,
    required String paymentMethod,
  }) {
    final newOrder = AgroOrder(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: _cartItems
          .map((c) => OrderItem(
                productName: c.product.name,
                quantity: c.quantity,
                price: c.product.price,
                image: c.product.image,
              ))
          .toList(),
      totalAmount: cartTotal,
      status: 'Placed',
      orderDate: DateTime.now().toString().substring(0, 10),
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, newOrder);
    _cartItems.clear();

    // Add confirmation notification
    _notifications.insert(
      0,
      AgroNotification(
        id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Order Placed Successfully',
        message: 'Your order #${newOrder.id} of ₹${newOrder.totalAmount.toStringAsFixed(0)} has been placed.',
        time: 'Just now',
        type: 'Order',
        isRead: false,
      ),
    );

    notifyListeners();
    return newOrder;
  }

  // Contract Actions
  void signContract(String contractId) {
    final index = _contracts.indexWhere((c) => c.id == contractId);
    if (index != -1) {
      final old = _contracts[index];
      _contracts[index] = FarmContract(
        id: old.id,
        buyerName: old.buyerName,
        cropName: old.cropName,
        variety: old.variety,
        quantity: old.quantity,
        pricePerUnit: old.pricePerUnit,
        advancePayment: old.advancePayment,
        deliveryDate: old.deliveryDate,
        durationMonths: old.durationMonths,
        terms: old.terms,
        status: 'Signed',
        buyerPhone: old.buyerPhone,
        buyerLocation: old.buyerLocation,
      );
      notifyListeners();
    }
  }

  // Notification Actions
  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      final old = _notifications[index];
      _notifications[index] = AgroNotification(
        id: old.id,
        title: old.title,
        message: old.message,
        time: old.time,
        type: old.type,
        isRead: true,
      );
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    _notifications = _notifications
        .map((n) => AgroNotification(
              id: n.id,
              title: n.title,
              message: n.message,
              time: n.time,
              type: n.type,
              isRead: true,
            ))
        .toList();
    notifyListeners();
  }
}
