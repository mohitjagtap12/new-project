import '../../models/order.dart';

class MockOrders {
  static List<AgroOrder> initialOrders = [
    // Buying Orders (Farmer bought inputs)
    AgroOrder(
      orderNumber: 'ORD-BUY-8921',
      itemTitle: 'Tomato Seeds F1 Hybrid',
      category: 'Farm Product',
      quantity: '2 packets',
      price: 900.0,
      counterParty: 'ABC Agro Store',
      address: 'Plot 14, Gat No. 234, Baramati Road, Pune, Maharashtra',
      date: '02 Sep 2026',
      status: 'On the Way',
      isBuying: true,
    ),
    AgroOrder(
      orderNumber: 'ORD-BUY-7743',
      itemTitle: 'Organic Bio-Fertilizer (NPK)',
      category: 'Farm Product',
      quantity: '4 bags (200 kg)',
      price: 2600.0,
      counterParty: 'Green Earth Bio Agro',
      address: 'Plot 14, Gat No. 234, Baramati Road, Pune, Maharashtra',
      date: '28 Aug 2026',
      status: 'Delivered',
      isBuying: true,
    ),
    // Selling Orders (Farmer sold crops/waste)
    AgroOrder(
      orderNumber: 'ORD-SELL-1044',
      itemTitle: 'Tomato (Fresh Harvest)',
      category: 'Crop',
      quantity: '500 kg',
      price: 12500.0,
      counterParty: 'Reliance Fresh APMC Buyer',
      address: 'Farm Gate Pick Up, Gate No. 234, Pune',
      date: '01 Sep 2026',
      status: 'Accepted',
      isBuying: false,
    ),
    AgroOrder(
      orderNumber: 'ORD-SELL-0982',
      itemTitle: 'Wheat Straw Biomass',
      category: 'Farm Waste',
      quantity: '1200 kg',
      price: 4800.0,
      counterParty: 'BioEnergy Solutions Pvt Ltd',
      address: 'Farm Gate Pick Up, Gate No. 234, Pune',
      date: '25 Aug 2026',
      status: 'Completed',
      isBuying: false,
    ),
    AgroOrder(
      orderNumber: 'ORD-SELL-0891',
      itemTitle: 'Sharbati Wheat Grade A',
      category: 'Crop',
      quantity: '2000 kg',
      price: 64000.0,
      counterParty: 'Golden Harvest Flours',
      address: 'Pune Grain Mandi Yard 4',
      date: '10 Aug 2026',
      status: 'Completed',
      isBuying: false,
    ),
  ];
}
