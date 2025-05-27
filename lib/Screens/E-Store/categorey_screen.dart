import 'package:flutter/material.dart';
import 'package:uonly_app/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../product_detail_screen.dart';

class SearchProductScreen extends StatefulWidget {
  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}
class _SearchProductScreenState extends State<SearchProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchText = _searchController.text.toLowerCase();
      });
    });
  }

  List<Map<String, String>> get filteredCategories {
    if (searchText.isEmpty) {
      return staticCategories;
    }
    return staticCategories.where((category) {
      final name = category['name']!.toLowerCase();
      return name.contains(searchText);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Select Category",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),

                ),

                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search Product",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Category Grid or No Result Message
            CategoryProductScreen(categories: filteredCategories),
          ],
        ),
      ),
    );
  }
}

// Static Category List
final List<Map<String, String>> staticCategories = [
  {'name': 'Education', 'image': 'assets/education.png'},
  {'name': 'Earn', 'image': 'assets/earn.png'},
  {'name': 'Help', 'image': 'assets/help.png'},
  {'name': 'Emergency', 'image': 'assets/emergency.png'},
  {'name': 'DTH', 'image': 'assets/dth.png'},
  {'name': 'Health', 'image': 'assets/health.png'},
];

// Grid Widget
class CategoryProductScreen extends StatelessWidget {
  final List<Map<String, String>> categories;

  const CategoryProductScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Center(
          child: Text(
            "No category found",
            style: TextStyle(
              fontSize: 1,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.87,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return GestureDetector(
            onTap: () {
              // Navigate to Detail Screen with name & image
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryDetailScreen(
                    name: category['name']!,
                    image: category['image']!,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        category['image']!,
                        fit: BoxFit.contain,
                        height: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        category['name']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ),
          );
        },
      ),
    );
  }
}


class CategoryDetailScreen extends StatefulWidget {
  final String name;
  final String image;

  const CategoryDetailScreen({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  String selectedState = "Rajasthan";
  String selectedDistrict = "Karauli";
  String selectedCity = "Karauli";
  final TextEditingController _searchController = TextEditingController();
  final List<String> states = ['Rajasthan', 'Madhya Pradesh', 'Uttar Pradesh'];

  final Map<String, List<String>> districts = {
    'Rajasthan': ['Karauli', 'Jaipur', 'Jodhpur'],
    'Madhya Pradesh': ['Indore', 'Bhopal', 'Gwalior'],
    'Uttar Pradesh': ['Agra', 'Lucknow', 'Noida'],
  };

  final Map<String, List<String>> cities = {
    'Karauli': ['Karauli', 'Hindaun', 'Sapotra'],
    'Jaipur': ['Jaipur City', 'Amer', 'Sanganer'],
    'Jodhpur': ['Jodhpur City', 'Mandore', 'Pali'],
    'Indore': ['Indore', 'Dewas', 'Mhow'],
    'Bhopal': ['Bhopal City', 'Raisen', 'Sehore'],
    'Gwalior': ['Gwalior', 'Bhitarwar', 'Dabra'],
    'Agra': ['Agra', 'Fatehpur Sikri'],
    'Lucknow': ['Lucknow City', 'Gomti Nagar'],
    'Noida': ['Noida Sector 62', 'Noida Sector 18'],
  };

  List<Map<String, String>> places = [
    {
      'name': 'St. Xavier School',
      'location': 'Karauli',
      'price': 'From ₹5000/year',
      'time': '08:00 - 15:00',
      'image': 'assets/schoolimage3.jpeg',
      'city': 'Karauli',
      'description': 'A well-known CBSE affiliated school with good facilities.',
      'features': 'Playground, Library, Labs',
    },
    {
      'name': 'Modern Public School',
      'location': 'Hindaun',
      'price': 'From ₹4500/year',
      'time': '09:00 - 14:00',
      'image': 'assets/schollimage2.jpeg',
      'city': 'Hindaun',
      'description': 'Modern infrastructure and experienced staff.',
      'features': 'Smart Classes, Sports, Transport',
    },
    {
      'name': 'DAV College',
      'location': 'Karauli',
      'price': 'From ₹15000/year',
      'time': '09:00 - 17:00',
      'image': 'assets/schoolimages.jpeg',
      'city': 'Karauli',
      'description': 'Leading higher education institute in the region.',
      'features': 'Library, Hostel, Labs, Wi-Fi',
    },
  ];

  List<String> get currentDistricts => districts[selectedState] ?? [];
  List<String> get currentCities => cities[selectedDistrict] ?? [];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredPlaces =
    places.where((place) => place['city'] == selectedCity).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("${widget.name} Details", style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Search Product",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'State',
              value: selectedState,
              items: states,
              onChanged: (val) {
                setState(() {
                  selectedState = val!;
                  selectedDistrict = districts[selectedState]!.first;
                  selectedCity = cities[selectedDistrict]!.first;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'District',
              value: selectedDistrict,
              items: currentDistricts,
              onChanged: (val) {
                setState(() {
                  selectedDistrict = val!;
                  selectedCity = cities[selectedDistrict]!.first;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'City',
              value: selectedCity,
              items: currentCities,
              onChanged: (val) {
                setState(() {
                  selectedCity = val!;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredPlaces.isEmpty
                  ? const Center(child: Text("No data found for this city"))
                  : ListView.builder(
                itemCount: filteredPlaces.length,
                itemBuilder: (context, index) {
                  final place = filteredPlaces[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlaceDetailScreen(place: place),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Side Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                place['image']!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Right Side Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    place['name']!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    "From ${place['price']} per person",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 14, color: Colors.red),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          place['location']!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),

                                  Row(
                                    children: [
                                      // Tag
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(place['status']),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          place['status'] ?? 'Open',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),

                                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        place['timing'] ?? '08:00 - 23:59',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text("$label:", style: const TextStyle(fontSize: 16))),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              underline:  SizedBox(),
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black)),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'free dining':
        return Colors.blue;
      case 'closed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

}




class PlaceDetailScreen extends StatelessWidget {
  final Map<String, String> place;

  const PlaceDetailScreen({super.key, required this.place});

  void _launchPhone(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchMap(String location) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchWebsite(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = place['phone'] ?? '1234567890';
    final email = place['email'] ?? 'example@example.com';
    final location = place['location'] ?? 'Jaipur, Rajasthan';
    final address = place['address'] ?? location;
    final rating = place['rating'] ?? '4.5';
    final category = place['category'] ?? 'General';
    final website = place['website'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(place['name'] ?? 'Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                place['image'] ?? '',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Name & Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(place['name'] ?? '',
                      style:
                      const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text('$rating / 5'),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Location
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 4),
                Text(location, style: const TextStyle(fontSize: 14)),
              ],
            ),

            const SizedBox(height: 8),
            Text("Address: $address",),
            Text("Price: ${place['price'] ?? 'N/A'}"),
            Text("Timings: ${place['time'] ?? 'N/A'}"),

            const SizedBox(height: 16),

            // About
            const Text("About",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(place['description'] ?? 'No description available.'),

            const SizedBox(height: 16),

            // Features
            const Text("Facilities",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(place['features'] ?? 'No info.'),

            const SizedBox(height: 24),

            // Contact Us
            const Text("Contact Us",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.green),
                    title: Text(phone, style: const TextStyle(fontSize: 14)),
                    onTap: () => _launchPhone(phone),
                    dense: true,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.orange),
                    title: Text(email, style: const TextStyle(fontSize: 14)),
                    onTap: () => _launchEmail(email),
                    dense: true,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.location_pin, color: Colors.red),
                    title: Text(location, style: const TextStyle(fontSize: 14)),
                    onTap: () => _launchMap(location),
                    dense: true,
                  ),
                  if (website.isNotEmpty) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.language, color: Colors.blue),
                      title: Text(website, style: const TextStyle(fontSize: 14)),
                      onTap: () => _launchWebsite(website),
                      dense: true,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}





//
// class CategoryDetailScreen extends StatefulWidget {
//   final String name;
//   final String image;
//
//   const CategoryDetailScreen({
//     super.key,
//     required this.name,
//     required this.image,
//   });
//
//   @override
//   State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
// }
//
// class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
//   final List<Map<String, dynamic>> staticProducts = const [
//     {
//       'id': 'p1',
//       'name': 'Organic Honey 500g',
//       'image': 'assets/product1.jpeg',
//       'price': '100.0'
//     },
//     {
//       'id': 'p2',
//       'name': 'Almonds (Badam) 250g',
//       'image': 'assets/product2.jpeg',
//       'price': '200.0'
//     },
//     {
//       'id': 'p3',
//       'name': 'Herbal Green Tea',
//       'image': 'assets/product3.jpeg',
//       'price': '150.0'
//     },
//     {
//       'id': 'p4',
//       'name': 'Amla Juice 1L',
//       'image': 'assets/product4.jpeg',
//       'price': '250.0'
//     },
//     {
//       'id': 'p5',
//       'name': 'Multigrain Cookies',
//       'image': 'assets/product5.jpeg',
//       'price': '250.0'
//     },
//     {
//       'id': 'p6',
//       'name': 'Natural Face Cream',
//       'image': 'assets/product6.jpeg',
//       'price': '250.0'
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     var cartCount = 0; // Replace with Provider if needed
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         title: Text(
//           widget.name,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   // Navigate to cart screen
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.grey.shade200),
//                   ),
//                   child: Icon(
//                     Icons.shopping_cart,
//                     color: const Color(0xFFE95168),
//                     size: 24,
//                   ),
//                 ),
//               ),
//               if (cartCount > 0)
//                 Positioned(
//                   right: -2,
//                   top: -5,
//                   child: Container(
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.secondary,
//                       shape: BoxShape.circle,
//                     ),
//                     constraints: const BoxConstraints(
//                       minWidth: 22,
//                       minHeight: 22,
//                     ),
//                     child: Text(
//                       '$cartCount',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(width: 16),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GridView.builder(
//           itemCount: staticProducts.length,
//           gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//             maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
//             mainAxisExtent: 255,
//             crossAxisSpacing: 2,
//             mainAxisSpacing: 2,
//           ),
//           itemBuilder: (context, index) {
//             final product = staticProducts[index];
//             final String? productId = product['id'] as String?;
//             if (productId == null) {
//               return const SizedBox.shrink(); // Skip null ids safely
//             }
//             double price = double.tryParse(product['price'].toString()) ?? 0.0;
//             double discountPercentage = 20;
//             double discountedPrice = price - (price * discountPercentage / 100);
//
//             return ProductCardStatic(
//               id: productId,
//               name: product['name'],
//               image: product['image'],
//               price: price,
//               discountedPrice: discountedPrice,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class ProductCardStatic extends StatelessWidget {
//   final String id;
//   final String name;
//   final String image;
//   final double price;
//   final double discountedPrice;
//
//   const ProductCardStatic({
//     super.key,
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.price,
//     required this.discountedPrice,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // Navigate to product detail screen and pass product id
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailScreen(
//               productId: id,
//               productName: name,
//               imageUrl: image,
//               oldPrice: price,
//               discountedPrice: discountedPrice,
//             ),
//           ),
//         );
//
//       },
//       child: Container(
//         margin: const EdgeInsets.all(4),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white,
//         ),
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Image.asset(
//                 image,
//                 height: 100,
//                 fit: BoxFit.fill,
//                 errorBuilder: (context, error, stackTrace) {
//                   // In case image asset not found
//                   return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
//                 },
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               name,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//             ),
//             const SizedBox(height: 5),
//             Wrap(
//               crossAxisAlignment: WrapCrossAlignment.center,
//               spacing: 4,
//               children: [
//                 Text(
//                   'MRP: ',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//                 Text(
//                   '₹${price.toStringAsFixed(2)}',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.grey.shade600,
//                     decoration: TextDecoration.lineThrough,
//                   ),
//                 ),
//                 Text(
//                   '₹${discountedPrice.toStringAsFixed(2)}',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.green.shade700,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const Spacer(),
//             Divider(color: Colors.grey.shade300),
//             GestureDetector(
//               onTap: () {
//                 // Add to cart action here
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Added "$name" to cart')),
//                 );
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Icon(
//                       Icons.shopping_bag_outlined,
//                       color: Color(0xFFE95168),
//                     ),
//                     SizedBox(width: 4),
//                     Text('Add to cart'),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
