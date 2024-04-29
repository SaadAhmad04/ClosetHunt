// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:mall/screens/customer/shopping/product_details.dart';
// import 'package:mall/screens/customer/shopping/view_cart.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../../../../../controller/auth.dart';
//
// List product = [];
//
// class CustomerProductCollection extends StatefulWidget {
//   final String shopManagerId;
//   final String shopName;
//
//   CustomerProductCollection({
//     Key? key,
//     required this.shopManagerId,
//     required this.shopName,
//   }) : super(key: key);
//
//   @override
//   State<CustomerProductCollection> createState() =>
//       _CustomerProductCollectionState();
// }
//
// class _CustomerProductCollectionState extends State<CustomerProductCollection> {
//   final searchController = TextEditingController();
//   var a;
//   List filteredProduct = []; // Define filteredProduct list here
//   bool isSpinkitVisible = true; // Set this based on your condition
//   bool isGenderSelected = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final spinkit = Center(
//       child: SpinKitPulse(
//         itemBuilder: (BuildContext context, int index) {
//           return DecoratedBox(
//             decoration: BoxDecoration(
//               color: index.isEven ? Colors.black : Colors.pink,
//             ),
//           );
//         },
//       ),
//     );
//
//     Size mq = MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ViewCart(),
//                   ),
//                 );
//               },
//               icon: Icon(
//                 Icons.shopping_cart,
//                 color: Color(0xFFC8A2C8),
//                 size: 30,
//               ),
//             )
//           ],
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//           title: ShaderMask(
//             shaderCallback: (Rect bounds) {
//               return LinearGradient(
//                 colors: [Colors.pink, Colors.black],
//               ).createShader(bounds);
//             },
//             child: Text(
//               widget.shopName,
//               style: TextStyle(
//                 fontSize: 30.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Positioned(
//                 width: mq.width,
//                 child: Container(
//                   height: mq.height,
//                   width: mq.width * 2,
//                   child: Image.network(
//                     "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           width: mq.height * .33,
//                           child: TextFormField(
//                             onChanged: (String value) {
//                               setState(() {});
//                             },
//                             controller: searchController,
//                             cursorColor: Color(0xff974C7C),
//                             decoration: InputDecoration(
//                               hoverColor: Color(0xff974C7C),
//                               fillColor: Color(0xff974C7C),
//                               focusColor: Color(0xff974C7C),
//                               border: OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Color(0xff974C7C)),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               hintText: 'Search Here',
//                               prefixIconColor: Color(0xff974C7C),
//                               prefixIcon: Icon(Icons.search),
//                             ),
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             Container(
//                               width: mq.width * .2,
//                               height: mq.height * .045,
//                               child: ElevatedButton.icon(
//                                 style: ElevatedButton.styleFrom(
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(15)),
//                                   backgroundColor: Colors.grey,
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 10,
//                                       horizontal: 10), // Adjust padding
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     isGenderSelected = true;
//                                   });
//                                 },
//                                 icon: Icon(
//                                   Icons.check,
//                                   size: 10,
//                                 ),
//                                 label: Text(
//                                   'Men',
//                                   style: TextStyle(fontSize: 10),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: mq.height * .01,
//                             ),
//                             Container(
//                               width: mq.width * .2,
//                               height: mq.height * .045,
//                               child: ElevatedButton.icon(
//                                 style: ElevatedButton.styleFrom(
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(15)),
//                                   backgroundColor: Colors.grey,
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 10,
//                                       horizontal: 10), // Adjust padding
//                                 ),
//                                 onPressed: () {
//                                   setState(() {});
//                                 },
//                                 icon: Icon(
//                                   Icons.check,
//                                   size: 10,
//                                 ),
//                                 label: Text(
//                                   'Women',
//                                   style: TextStyle(fontSize: 10),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: mq.height * 0.02),
//                     Container(
//                       height: mq.height / 16,
//                       child: Center(
//                         child: Text(
//                           'The Fashion Mute At one Place!',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Container(
//                 height: mq.height,
//                 margin: EdgeInsets.only(top: mq.height * 0.20),
//                 child: StreamBuilder(
//                   stream: Auth.productRef.snapshots(),
//                   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                     product.clear();
//                     print("Data is ${snapshot.data}");
//                     if (snapshot.hasData || snapshot.data != null) {
//                       if (product.length == 0) {
//                         for (int i = 0; i < snapshot.data!.docs.length; i++) {
//                           a = snapshot.data!.docs[i];
//                           if (a
//                               .get('sellerId')
//                               .toString()
//                               .toLowerCase()
//                               .contains(widget.shopManagerId.toLowerCase())) {
//                             product.add(a);
//                           }
//                         }
//                       }
//                       isSpinkitVisible = false;
//                       filteredProduct = product.where((item) {
//                         String name = item['name'].toLowerCase(); // Convert name to lowercase for case-insensitive matching
//                         String searchQuery = searchController.text.toLowerCase(); // Convert search query to lowercase
//
//                         // Check if search query is empty or if name contains search query
//                         bool nameMatchesSearch = searchQuery.isEmpty || name.contains(searchQuery);
//
//                         // Check if men is selected and the product name contains 'men'
//                         bool isMenSelected = isGenderSelected && name.contains('men');
//
//                         // Check if women is selected and the product name contains 'women'
//                         bool isWomenSelected = !isGenderSelected && name.contains('women');
//
//                         // Include product if it matches search query and selected gender
//                         return nameMatchesSearch && (isWomenSelected || isMenSelected);
//                       }).toList();
//                       print('sdswwesdwe${filteredProduct.length}');
//                       return filteredProduct.isEmpty
//                           ? Center(
//                         child: Text(
//                           'No Items Found',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       )
//                           :GridView.builder(
//                         itemCount: filteredProduct.length,
//                         scrollDirection: Axis.vertical,
//                         shrinkWrap: true,
//                         physics: AlwaysScrollableScrollPhysics(),
//                         primary: false,
//                         clipBehavior: Clip.hardEdge,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 12,
//                           mainAxisExtent: 300,
//                           mainAxisSpacing: 20,
//                         ),
//                         itemBuilder: (context, index) {
//                           String name = filteredProduct[index]['name'];
//                           bool isMenProduct = name.toLowerCase().contains('men');
//                           bool isWomenProduct = name.toLowerCase().contains('women');
//
//                           // Check if men is selected and the product name contains 'men'
//                           bool shouldDisplayMenProduct = isGenderSelected && isMenProduct;
//
//                           // Check if women is selected and the product name contains 'women'
//                           bool shouldDisplayWomenProduct = !isGenderSelected && isWomenProduct;
//
//                           // Include product if it matches search query and selected gender, or if no gender is selected
//                           if ((shouldDisplayMenProduct || shouldDisplayWomenProduct) || (!isMenProduct && !isWomenProduct)) {
//                             return Container(
//                               child: Details(
//                                 image: filteredProduct[index]['thumbnailUrl'],
//                                 price: "Rs. ${double.parse(filteredProduct[index]['price']).toStringAsFixed(2)}",
//                                 name: filteredProduct[index]['name'],
//                                 index: index,
//                                 productId: filteredProduct[index]['usItemId'],
//                                 deliveryTime: filteredProduct[index]['deliveryTime'] ?? "",
//                                 sellerId: filteredProduct[index]['sellerId'] ?? "",
//                                 orderLimit: filteredProduct[index]['orderLimit'],
//                               ),
//                             );
//                           } else {
//                             // Return an empty container if the product should not be displayed
//                             return Container();
//                           }
//                         },
//                       );
//
//
//
//                     } else {
//                       return Center(child: spinkit);
//                     }
//                   },
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Details extends StatelessWidget {
//   final String image;
//   final String price;
//   final String name;
//   final String productId;
//   final String deliveryTime;
//   final String sellerId;
//   final int orderLimit;
//   final int index;
//
//   Details({
//     Key? key,
//     required this.image,
//     required this.price,
//     required this.name,
//     required this.productId,
//     required this.index,
//     required this.deliveryTime,
//     required this.sellerId,
//     required this.orderLimit,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Size mq = MediaQuery.of(context).size;
//     return SizedBox(
//       height: mq.height * .4,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProductDetails(
//                       info: this,
//                       products: product,
//                     ),
//                   ),
//                 );
//               },
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 elevation: 10,
//                 child: Container(
//                   width: mq.width,
//                   child: Image.network(
//                     image,
//                     height: 220,
//                     width: 70,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//             ),
//             name.length > 10
//                 ? Text(
//               '${name.toString().substring(0, 12)}...',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             )
//                 : Text(
//               '${name.toString()}',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Container(
//               child: Text(
//                 price,
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Details detailsFromJson(dynamic json) {
//   double price = double.parse(json['price'].toString());
//   String formattedPrice = price.toStringAsFixed(2);
//
//   return Details(
//     image: json['thumbnailUrl'],
//     price: formattedPrice,
//     name: json['name'],
//     productId: json['usItemId'],
//     deliveryTime: json['deliveryTime'] ?? "",
//     sellerId: json['sellerId'],
//     orderLimit: json['orderLimit'],
//     index: 0, // Assuming index is not available in JSON and set to 0 for now
//   );
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:mall/screens/customer/shopping/product_details.dart';
// import 'package:mall/screens/customer/shopping/view_cart.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../../../../../controller/auth.dart';
//
// class CustomerProductCollection extends StatefulWidget {
//   final String shopManagerId;
//   final String shopName;
//
//   CustomerProductCollection({
//     Key? key,
//     required this.shopManagerId,
//     required this.shopName,
//   }) : super(key: key);
//
//   @override
//   State<CustomerProductCollection> createState() =>
//       _CustomerProductCollectionState();
// }
//
// class _CustomerProductCollectionState extends State<CustomerProductCollection> {
//   final searchController = TextEditingController();
//   var a;
//   List product = [];
//   List filteredProduct = [];
//   bool isSpinkitVisible = true;
//   bool isMenSelected = false;
//   bool isWomenSelected = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final spinkit = Center(
//       child: SpinKitPulse(
//         itemBuilder: (BuildContext context, int index) {
//           return DecoratedBox(
//             decoration: BoxDecoration(
//               color: index.isEven ? Colors.black : Colors.pink,
//             ),
//           );
//         },
//       ),
//     );
//
//     Size mq = MediaQuery.of(context).size;
//
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ViewCart(),
//                   ),
//                 );
//               },
//               icon: Icon(
//                 Icons.shopping_cart,
//                 color: Color(0xFFC8A2C8),
//                 size: 30,
//               ),
//             )
//           ],
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//           title: ShaderMask(
//             shaderCallback: (Rect bounds) {
//               return LinearGradient(
//                 colors: [Colors.pink, Colors.black],
//               ).createShader(bounds);
//             },
//             child: Text(
//               widget.shopName,
//               style: TextStyle(
//                 fontSize: 30.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Positioned(
//                 width: mq.width,
//                 child: Container(
//                   height: mq.height,
//                   width: mq.width * 2,
//                   child: Image.network(
//                     "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               isMenSelected = true;
//                               isWomenSelected = false;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: isMenSelected ? Colors.grey : null,
//                           ),
//                           child: Text('Men'),
//                         ),
//                         SizedBox(width: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               isMenSelected = false;
//                               isWomenSelected = true;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: isWomenSelected ? Colors.grey : null,
//                           ),
//                           child: Text('Women'),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       onChanged: (String value) {
//                         setState(() {});
//                       },
//                       controller: searchController,
//                       cursorColor: Color(0xff974C7C),
//                       decoration: InputDecoration(
//                         hoverColor: Color(0xff974C7C),
//                         fillColor: Color(0xff974C7C),
//                         focusColor: Color(0xff974C7C),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Color(0xff974C7C)),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         hintText: 'Search Here',
//                         prefixIconColor: Color(0xff974C7C),
//                         prefixIcon: Icon(Icons.search),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'The Fashion Mute At one Place!',
//                       style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                     ),
//                     SizedBox(height: 5),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: mq.height,
//                 margin: EdgeInsets.only(top: mq.height * 0.20),
//                 child: StreamBuilder(
//                   stream: Auth.productRef.snapshots(),
//                   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                     print("Data is ${snapshot.data}");
//                     if (snapshot.hasData || snapshot.data != null) {
//                       if (product.length == 0) {
//                         for (int i = 0; i < snapshot.data!.docs.length; i++) {
//                           a = snapshot.data!.docs[i];
//                           if (a
//                               .get('sellerId')
//                               .toString()
//                               .toLowerCase()
//                               .contains(widget.shopManagerId.toLowerCase())) {
//                             product.add(a);
//                           }
//                         }
//                       }
//                       print("Length of the product ${product.length}");
//                       isSpinkitVisible = false;
//
//                       filteredProduct = product.where((item) {
//                         String name = item['name'];
//                         bool isMenProduct = name.toLowerCase().contains('men');
//                         bool isWomenProduct = name.toLowerCase().contains('women');
//                         return searchController.text.isEmpty &&
//                             ((isMenSelected && isMenProduct) ||
//                                 (isWomenSelected && isWomenProduct));
//                       }).toList();
//
//                       return filteredProduct.isEmpty
//                           ? Center(
//                         child: Text(
//                           'No Items Found',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       )
//                           : GridView.builder(
//                         itemCount: filteredProduct.length,
//                         scrollDirection: Axis.vertical,
//                         shrinkWrap: true,
//                         physics: AlwaysScrollableScrollPhysics(),
//                         primary: false,
//                         clipBehavior: Clip.hardEdge,
//                         gridDelegate:
//                         SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 12,
//                           mainAxisExtent: 300,
//                           mainAxisSpacing: 20,
//                         ),
//                         itemBuilder: (context, index) {
//                           String name = filteredProduct[index]['name'];
//                           return Container(
//                             child: Details(
//                               image: filteredProduct[index]
//                               ['thumbnailUrl'],
//                               price:
//                               "Rs. ${double.parse(filteredProduct[index]['price']).toStringAsFixed(2)}",
//                               name: filteredProduct[index]['name'],
//                               index: index,
//                               productId: filteredProduct[index]
//                               ['usItemId'],
//                               deliveryTime: filteredProduct[index]
//                               ['deliveryTime'] ??
//                                   "".toString(),
//                               sellerId: filteredProduct[index]
//                               ['sellerId'] ??
//                                   "".toString(),
//                               orderLimit: filteredProduct[index]
//                               ['orderLimit'],
//                             ),
//                           );
//                         },
//                       );
//                     } else {
//                       return Center(child: spinkit);
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Details extends StatelessWidget {
//   final String image;
//   final String price;
//   final String name;
//   final String productId;
//   final String deliveryTime;
//   final String sellerId;
//   final int orderLimit;
//   final int index;
//
//   Details({
//     Key? key,
//     required this.image,
//     required this.price,
//     required this.name,
//     required this.productId,
//     required this.index,
//     required this.deliveryTime,
//     required this.sellerId,
//     required this.orderLimit,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Size mq = MediaQuery.of(context).size;
//     return SizedBox(
//       height: mq.height * .4,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProductDetails(info: this),
//                   ),
//                 );
//               },
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 elevation: 10,
//                 child: Container(
//                   width: mq.width,
//                   child: Image.network(
//                     image,
//                     height: 220,
//                     width: 70,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//             ),
//             Text(
//               '${name.toString().substring(0, 12)}...',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Container(
//               child: Text(
//                 price,
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Details detailsFromJson(dynamic json) {
//   double price = double.parse(json['price'].toString());
//   String formattedPrice = price.toStringAsFixed(2);
//
//   return Details(
//     image: json['thumbnailUrl'],
//     price: formattedPrice,
//     name: json['name'],
//     productId: json['usItemId'],
//     deliveryTime: json['deliveryTime'] ?? "",
//     sellerId: json['sellerId'],
//     orderLimit: json['orderLimit'],
//     index: 0, // Assuming index is not available in JSON and set to 0 for now
//   );
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mall/screens/customer/shopping/product_details.dart';
import 'package:mall/screens/customer/shopping/view_cart.dart';

import '../../../../../controller/auth.dart';

List product = [];

class CustomerProductCollection extends StatefulWidget {
  final String shopManagerId;
  final String shopName;

  CustomerProductCollection({
    Key? key,
    required this.shopManagerId,
    required this.shopName,
  }) : super(key: key);

  @override
  State<CustomerProductCollection> createState() =>
      _CustomerProductCollectionState();
}

class _CustomerProductCollectionState extends State<CustomerProductCollection> {
  String categorySelected = 'All';

  final searchController = TextEditingController();
  var a;
  List filteredProduct = []; // Define filteredProduct list here
  bool isSpinkitVisible = true; // Set this based on your condition

  @override
  Widget build(BuildContext context) {
    final spinkit = Center(
      child: SpinKitPulse(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.black : Colors.pink,
            ),
          );
        },
      ),
    );

    Size mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewCart(),
                  ),
                );
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Color(0xFFC8A2C8),
                size: 30,
              ),
            )
          ],
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [Colors.pink, Colors.black],
              ).createShader(bounds);
            },
            child: Text(
              widget.shopName,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                width: mq.width,
                child: Container(
                  height: mq.height,
                  width: mq.width * 2,
                  child: Image.network(
                    "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: mq.width * .22,
                          height: mq.height * .05,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: categorySelected == 'All'
                                  ? Colors.blue
                                  : Colors.grey,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10), // Adjust padding
                            ),
                            onPressed: () {
                              setState(() {
                                categorySelected = 'All';
                                filteredProduct.clear();
                              });
                            },
                            icon: Icon(Icons.check),
                            label: Text('All'),
                          ),
                        ),
                        SizedBox(width: mq.width * .1),
                        Container(
                          width: mq.width * .22,
                          height: mq.height * .05,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: categorySelected == 'Men'
                                  ? Colors.blue
                                  : Colors.grey,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10), // Adjust padding
                            ),
                            onPressed: () {
                              setState(() {
                                categorySelected = 'Men';
                                filteredProduct.clear();
                              });
                            },
                            icon: Icon(Icons.check),
                            label: Text('Men'),
                          ),
                        ),
                        SizedBox(width: mq.width * .1),
                        Container(
                          width: mq.width * .27,
                          height: mq.height * .05,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: categorySelected == 'Women'
                                  ? Colors.blue
                                  : Colors.grey,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10), // Adjust padding
                            ),
                            onPressed: () {
                              setState(() {
                                categorySelected = 'Women';
                                filteredProduct.clear();
                              });
                            },
                            icon: Icon(Icons.check),
                            label: Text('Women'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mq.height * .03),
                    TextFormField(
                      onChanged: (String value) {
                        setState(() {});
                      },
                      controller: searchController,
                      cursorColor: Color(0xff974C7C),
                      decoration: InputDecoration(
                        hoverColor: Color(0xff974C7C),
                        fillColor: Color(0xff974C7C),
                        focusColor: Color(0xff974C7C),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff974C7C)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Search Here',
                        prefixIconColor: Color(0xff974C7C),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: mq.height / 6,
                margin: EdgeInsets.only(top: mq.height * 0.12),
                child: Center(
                  child: Text(
                    'The Fashion Mute At one Place!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: mq.height,
                margin: EdgeInsets.only(top: mq.height * 0.22),
                child: StreamBuilder(
                  stream: Auth.productRef.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    product.clear();
                    print("Data is ${snapshot.data}");
                    if (snapshot.hasData || snapshot.data != null) {
                      if (product.length == 0) {
                        for (int i = 0; i < snapshot.data!.docs.length; i++) {
                          a = snapshot.data!.docs[i];
                          if (a
                              .get('sellerId')
                              .toString()
                              .toLowerCase()
                              .contains(widget.shopManagerId.toLowerCase())) {
                            product.add(a);
                          }
                        }
                      }
                      isSpinkitVisible =
                          false; // Set to false once data is loaded
                      // Filter matching items based on searchController
                      if (categorySelected == 'All') {
                        filteredProduct = product.where((item) {
                          String name = item['name'];
                          return searchController.text.isEmpty ||
                              name.toLowerCase().contains(
                                  searchController.text.toLowerCase());
                        }).toList();
                      } else if (categorySelected == 'Men') {
                        filteredProduct = product.where((item) {
                          String name = item['name']
                                      .toString()
                                      .toLowerCase()
                                      .contains('men') &&
                                  item['name']
                                          .toString()
                                          .toLowerCase()
                                          .contains('women') ==
                                      false
                              ? item['name']
                              : "";
                          return (name != "") &&
                              (searchController.text.isEmpty ||
                                  name.toLowerCase().contains(
                                      searchController.text.toLowerCase()));
                        }).toList();
                      } else if (categorySelected == 'Women') {
                        filteredProduct = product.where((item) {
                          String name = item['name']
                                      .toString()
                                      .toLowerCase()
                                      .contains('women') ||
                                  item['name']
                                      .toString()
                                      .toLowerCase()
                                      .contains('woman')
                              ? item['name']
                              : "";
                          return (name != "") &&
                              (searchController.text.isEmpty ||
                                  name.toLowerCase().contains(
                                      searchController.text.toLowerCase()));
                        }).toList();
                      }
                      return filteredProduct.isEmpty
                          ? Center(
                              child: Text(
                                'No Items Found',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : GridView.builder(
                              itemCount: filteredProduct.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              primary: false,
                              clipBehavior: Clip.hardEdge,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisExtent: 300,
                                mainAxisSpacing: 20,
                              ),
                              itemBuilder: (context, index) {
                                String name = filteredProduct[index]['name'];
                                return Container(
                                  child: Details(
                                    image: filteredProduct[index]
                                        ['thumbnailUrl'],
                                    price:
                                        "Rs. ${double.parse(filteredProduct[index]['price']).toStringAsFixed(2)}",
                                    name: filteredProduct[index]['name'],
                                    index: index,
                                    productId: filteredProduct[index]
                                        ['usItemId'],
                                    deliveryTime: filteredProduct[index]
                                            ['deliveryTime'] ??
                                        "".toString(),
                                    sellerId: filteredProduct[index]
                                            ['sellerId'] ??
                                        "".toString(),
                                    orderLimit: filteredProduct[index]
                                        ['orderLimit'],
                                  ),
                                );
                              },
                            );
                    } else {
                      return Center(child: spinkit);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Details extends StatelessWidget {
  final String image;
  final String price;
  final String name;
  final String productId;
  final String deliveryTime;
  final String sellerId;
  final int orderLimit;
  final int index;

  Details({
    Key? key,
    required this.image,
    required this.price,
    required this.name,
    required this.productId,
    required this.index,
    required this.deliveryTime,
    required this.sellerId,
    required this.orderLimit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return SizedBox(
      height: mq.height * .4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(
                      info: this,
                      products: product,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: Container(
                  width: mq.width,
                  child: Image.network(
                    image,
                    height: 220,
                    width: 70,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            name.length > 10
                ? Text(
                    '${name.toString().substring(0, 12)}...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                : Text(
                    '${name.toString()}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            Container(
              child: Text(
                price,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Details detailsFromJson(dynamic json) {
  double price = double.parse(json['price'].toString());
  String formattedPrice = price.toStringAsFixed(2);

  return Details(
    image: json['thumbnailUrl'],
    price: formattedPrice,
    name: json['name'],
    productId: json['usItemId'],
    deliveryTime: json['deliveryTime'] ?? "",
    sellerId: json['sellerId'],
    orderLimit: json['orderLimit'],
    index: 0, // Assuming index is not available in JSON and set to 0 for now
  );
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:mall/screens/customer/shopping/product_details.dart';
// import 'package:mall/screens/customer/shopping/view_cart.dart';
//
// import '../../../../../controller/auth.dart';
//
// class CustomerProductCollection extends StatefulWidget {
//   final String shopManagerId;
//   final String shopName;
//
//   CustomerProductCollection({
//     Key? key,
//     required this.shopManagerId,
//     required this.shopName,
//   }) : super(key: key);
//
//   @override
//   State<CustomerProductCollection> createState() =>
//       _CustomerProductCollectionState();
// }
//
// class _CustomerProductCollectionState extends State<CustomerProductCollection> {
//   final searchController = TextEditingController();
//   var a;
//   List product = [];
//   List filteredProduct = []; // Define filteredProduct list here
//   bool isSpinkitVisible = true; // Set this based on your condition
//
//   @override
//   Widget build(BuildContext context) {
//     final spinkit = Center(
//       child: SpinKitPulse(
//         itemBuilder: (BuildContext context, int index) {
//           return DecoratedBox(
//             decoration: BoxDecoration(
//               color: index.isEven ? Colors.black : Colors.pink,
//             ),
//           );
//         },
//       ),
//     );
//
//     Size mq = MediaQuery.of(context).size;
//
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ViewCart(),
//                   ),
//                 );
//               },
//               icon: Icon(
//                 Icons.shopping_cart,
//                 color: Color(0xFFC8A2C8),
//                 size: 30,
//               ),
//             )
//           ],
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//           title: ShaderMask(
//             shaderCallback: (Rect bounds) {
//               return LinearGradient(
//                 colors: [Colors.pink, Colors.black],
//               ).createShader(bounds);
//             },
//             child: Text(
//               widget.shopName,
//               style: TextStyle(
//                 fontSize: 30.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Positioned(
//                 width: mq.width,
//                 child: Container(
//                   height: mq.height,
//                   width: mq.width * 2,
//                   child: Image.network(
//                     "https://i.pinimg.com/736x/b0/ee/03/b0ee038e2310e0b40d1ec07546aefb38.jpg",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: TextFormField(
//                   onChanged: (String value) {
//                     setState(() {});
//                   },
//                   controller: searchController,
//                   cursorColor: Color(0xff974C7C),
//                   decoration: InputDecoration(
//                     hoverColor: Color(0xff974C7C),
//                     fillColor: Color(0xff974C7C),
//                     focusColor: Color(0xff974C7C),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Color(0xff974C7C)),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     hintText: 'Search Here',
//                     prefixIconColor: Color(0xff974C7C),
//                     prefixIcon: Icon(Icons.search),
//                   ),
//                 ),
//               ),
//               Container(
//                 height: mq.height / 16,
//                 margin: EdgeInsets.only(top: mq.height * 0.12),
//                 child: Center(
//                   child: Text(
//                     'The Fashion Mute At one Place!',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 5,
//               ),
//               Container(
//                 height: mq.height,
//                 margin: EdgeInsets.only(top: mq.height * 0.20),
//                 child: StreamBuilder(
//                   stream: Auth.productRef.snapshots(),
//                   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                     print("Data is ${snapshot.data}");
//                     if (snapshot.hasData || snapshot.data != null) {
//                       if (product.length == 0) {
//                         for (int i = 0; i < snapshot.data!.docs.length; i++) {
//                           a = snapshot.data!.docs[i];
//                           if (a
//                               .get('sellerId')
//                               .toString()
//                               .toLowerCase()
//                               .contains(widget.shopManagerId.toLowerCase())) {
//                             product.add(a);
//                           }
//                         }
//                       }
//                       print("Length of the product ${product.length}");
//                       isSpinkitVisible =
//                       false; // Set to false once data is loaded
//
//                       // Filter matching items based on searchController
//                       filteredProduct = product.where((item) {
//                         String name = item['name'];
//                         return searchController.text.isEmpty ||
//                             name
//                                 .toLowerCase()
//                                 .contains(searchController.text.toLowerCase());
//                       }).toList();
//
//                       return filteredProduct.isEmpty
//                           ? Center(
//                         child: Text(
//                           'No Items Found',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       )
//                           : GridView.builder(
//                         itemCount: filteredProduct.length,
//                         scrollDirection: Axis.vertical,
//                         shrinkWrap: true,
//                         physics: AlwaysScrollableScrollPhysics(),
//                         primary: false,
//                         clipBehavior: Clip.hardEdge,
//                         gridDelegate:
//                         SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 12,
//                           mainAxisExtent: 300,
//                           mainAxisSpacing: 20,
//                         ),
//                         itemBuilder: (context, index) {
//                           String name = filteredProduct[index]['name'];
//                           return Container(
//                             child: Details(
//                               image: filteredProduct[index]
//                               ['thumbnailUrl'],
//                               price:
//                               "Rs. ${double.parse(filteredProduct[index]['price']).toStringAsFixed(2)}",
//                               name: filteredProduct[index]['name'],
//                               index: index,
//                               productId: filteredProduct[index]
//                               ['usItemId'],
//                               deliveryTime: filteredProduct[index]
//                               ['deliveryTime'] ??
//                                   "".toString(),
//                               sellerId: filteredProduct[index]
//                               ['sellerId'] ??
//                                   "".toString(),
//                               orderLimit: filteredProduct[index]
//                               ['orderLimit'],
//                             ),
//                           );
//                         },
//                       );
//                     } else {
//                       return Center(child: spinkit);
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Details extends StatelessWidget {
//   final String image;
//   final String price;
//   final String name;
//   final String productId;
//   final String deliveryTime;
//   final String sellerId;
//   final int orderLimit;
//   final int index;
//
//   Details({
//     Key? key,
//     required this.image,
//     required this.price,
//     required this.name,
//     required this.productId,
//     required this.index,
//     required this.deliveryTime,
//     required this.sellerId,
//     required this.orderLimit,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Size mq = MediaQuery.of(context).size;
//     return SizedBox(
//       height: mq.height * .4,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProductDetails(info: this),
//                   ),
//                 );
//               },
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 elevation: 10,
//                 child: Container(
//                   width: mq.width,
//                   child: Image.network(
//                     image,
//                     height: 220,
//                     width: 70,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//             ),
//             Text(
//               '${name.toString().substring(0, 12)}...',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Container(
//               child: Text(
//                 price,
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Details detailsFromJson(dynamic json) {
//   double price = double.parse(json['price'].toString());
//   String formattedPrice = price.toStringAsFixed(2);
//
//   return Details(
//     image: json['thumbnailUrl'],
//     price: formattedPrice,
//     name: json['name'],
//     productId: json['usItemId'],
//     deliveryTime: json['deliveryTime'] ?? "",
//     sellerId: json['sellerId'],
//     orderLimit: json['orderLimit'],
//     index: 0, // Assuming index is not available in JSON and set to 0 for now
//   );
// }
//
