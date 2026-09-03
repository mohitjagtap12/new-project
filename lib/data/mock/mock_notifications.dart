import '../../models/notification.dart';

class MockNotifications {
  static List<AgroNotification> initialNotifications = [
    AgroNotification(
      id: 'n1',
      title: 'Order Status Update',
      message: 'Your tomato order was accepted.',
      time: '10 mins ago',
      type: 'order',
      isRead: false,
    ),
    AgroNotification(
      id: 'n2',
      title: 'Buyer Interest',
      message: 'A buyer is interested in your wheat.',
      time: '2 hours ago',
      type: 'market',
      isRead: false,
    ),
    AgroNotification(
      id: 'n3',
      title: 'Labour Update',
      message: 'Your labour request was accepted.',
      time: 'Yesterday',
      type: 'labour',
      isRead: true,
    ),
    AgroNotification(
      id: 'n4',
      title: 'Contract Approved',
      message: 'Your contract application was approved.',
      time: '2 days ago',
      type: 'contract',
      isRead: true,
    ),
    AgroNotification(
      id: 'n5',
      title: 'Delivery Confirmation',
      message: 'Your order has been delivered.',
      time: '3 days ago',
      type: 'order',
      isRead: true,
    ),
  ];
}
