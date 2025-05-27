import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final List<String> sliderImages = [
    'assets/slider1.jpeg',
    'assets/slider2.jpeg',
    'assets/slider3.jpeg',
  ];

  final List<Map<String, dynamic>> staticOrders = [
    {
      "orderNoDisplay": "ORD1001",
      "orderDate": "2025-05-01",
      "itemCount": 2,
      "orderValue": 299.99,
      "saleType": "Retail",
      "purchaseMethod": "Online",
      "orderStatus": "Confirmed"
    },
    {
      "orderNoDisplay": "ORD1002",
      "orderDate": "2025-05-03",
      "itemCount": 3,
      "orderValue": 499.00,
      "saleType": "Wholesale",
      "purchaseMethod": "COD",
      "orderStatus": "Shipped"
    },
    {
      "orderNoDisplay": "ORD1003",
      "orderDate": "2025-05-05",
      "itemCount": 1,
      "orderValue": 199.99,
      "saleType": "Retail",
      "purchaseMethod": "UPI",
      "orderStatus": "Delivered"
    },
    {
      "orderNoDisplay": "ORD1004",
      "orderDate": "2025-05-08",
      "itemCount": 5,
      "orderValue": 899.50,
      "saleType": "Bulk",
      "purchaseMethod": "Online",
      "orderStatus": "Pending"
    },
    {
      "orderNoDisplay": "ORD1005",
      "orderDate": "2025-05-10",
      "itemCount": 4,
      "orderValue": 750.75,
      "saleType": "Retail",
      "purchaseMethod": "Wallet",
      "orderStatus": "Cancelled"
    },
  ];
  @override
  Widget build(BuildContext context) {
    double totalWalletAmount = staticOrders.fold(0.0, (sum, item) => sum + item["orderValue"]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 180.0,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              autoPlayInterval: const Duration(seconds: 3),
            ),
            items: sliderImages.map((imagePath) {
              return Builder(
                builder: (BuildContext context) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: staticOrders.length,
              itemBuilder: (context, index) {
                final item = staticOrders[index];
                final int itemCount = item["itemCount"];
                final double orderValue = item["orderValue"];
                final double perItemPrice = orderValue / itemCount;
                final double totalAmount = perItemPrice * itemCount;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrderDetailScreen(),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey.shade200,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.asset(
                                    'assets/order.png',
                                    width: 40,
                                    // height: 45,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order #${item["orderNoDisplay"]}',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          item["orderDate"],
                                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Items: $itemCount'),
                                        Text('Total: ₹${totalAmount.toStringAsFixed(2)}'),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Purchase Method: ${item["purchaseMethod"]}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(color: Colors.grey),
                          Row(
                            children: [
                              Icon(
                                item["orderStatus"] == "Cancelled"
                                    ? Icons.cancel
                                    : item["orderStatus"] == "Pending"
                                    ? Icons.access_time
                                    : item["orderStatus"] == "Shipped"
                                    ? Icons.local_shipping
                                    : item["orderStatus"] == "Delivered"
                                    ? Icons.check_circle_outline
                                    : Icons.check_circle,
                                color: item["orderStatus"] == "Cancelled"
                                    ? Colors.red
                                    : item["orderStatus"] == "Pending"
                                    ? Colors.orange
                                    : Colors.green,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Status : ${item["orderStatus"]}',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Purchase Amount:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '₹${totalWalletAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}



class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  final Map<String, dynamic> orderDetails = const {
    "orderNoDisplay": "ORD1001",
    "orderDate": "2025-05-01",
    "orderStatus": "Confirmed",
    "itemList": [
      {
        "itemName": "Wireless Mouse",
        "oldMrp": 599.0,
        "newMrp": 499.0,
        "itemQty": 1,
        "totalAmount": 499.00,
      },
      {
        "itemName": "Bluetooth Keyboard",
        "oldMrp": 999.0,
        "newMrp": 899.0,
        "itemQty": 1,
        "totalAmount": 899.00,
      }
    ],
  };

  @override
  Widget build(BuildContext context) {
    final List items = orderDetails['itemList'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${orderDetails["orderNoDisplay"]}'),
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        child: ListView(
          children: [
            // Order info
            Row(
              children: [
                Image.asset(
                  'assets/order.png',
                  height: 70,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${orderDetails["orderNoDisplay"]}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Placed on ${orderDetails["orderDate"]}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Items: ${items.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${orderDetails["orderStatus"]}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(color: Colors.grey),
            const SizedBox(height: 12),

            Text(
              '${items.length} items',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),
            ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final product = items[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IntrinsicHeight( // ✅ Wrap Row with this
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,// ensures top alignment
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/demoimage.jpeg',
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 15,),
                        Text(
                          product['itemName'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Text(
                              'MRP: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '\u{20B9}${product['oldMrp']}',
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                                color: Colors.redAccent,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '\u{20B9}${product['newMrp']}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Qty: ${product['itemQty']}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Amount: \u{20B9}${product['totalAmount']}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      ]
    )


    ),
    );
  }
}
