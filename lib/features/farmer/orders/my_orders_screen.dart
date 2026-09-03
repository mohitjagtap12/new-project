import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/order.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/order_card.dart';

class MyOrdersScreen extends StatelessWidget {
  final List<AgroOrder> orders;
  final Function(AgroOrder) onViewOrder;
  final VoidCallback onGoToMarket;

  const MyOrdersScreen({
    Key? key,
    required this.orders,
    required this.onViewOrder,
    required this.onGoToMarket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          bottom: const TabBar(
            indicatorColor: AgroColors.primary,
            labelColor: AgroColors.primary,
            unselectedLabelColor: AgroColors.textMuted,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              Tab(text: 'Buying'),
              Tab(text: 'Selling'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Buying Tab
            _buildOrderList(
              orders.where((o) => o.isBuying).toList(),
              emptyMsg: 'No buying orders yet.',
              emptyDesc: 'Orders of seeds, fertilizers, and equipment will appear here.',
            ),
            // Selling Tab
            _buildOrderList(
              orders.where((o) => !o.isBuying).toList(),
              emptyMsg: 'No selling orders yet.',
              emptyDesc: 'Direct sales of your crops and farm waste will appear here.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<AgroOrder> list, {required String emptyMsg, required String emptyDesc}) {
    if (list.isEmpty) {
      return EmptyStateWidget(
        title: emptyMsg,
        description: emptyDesc,
        icon: Icons.receipt_long_outlined,
        buttonText: 'Go to Market',
        onButtonPressed: onGoToMarket,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final order = list[index];
        return OrderCard(
          order: order,
          onTap: () => onViewOrder(order),
        );
      },
    );
  }
}
