import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String? image;
  int? quantity;
  String? sellerId;
  String? productId;
  String? deliveryTime;
  String? price;
  String? name;
  int? orderLimit;
  int? index;
  String? size;
  double? perprice;

  ProductModel(
      {this.image,
      this.quantity,
      this.sellerId,
      this.productId,
      this.deliveryTime,
      this.price,
      this.name,
      this.orderLimit,
      this.index,
      this.size,
      this.perprice});

  ProductModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    quantity = json['quantity'];
    sellerId = json['sellerId'];
    productId = json['productId'];
    deliveryTime = json['deliveryTime'];
    price = json['price'];
    name = json['name'];
    orderLimit = json['orderLimit'];
    index = json['index'];
    size = json['size'];
    perprice = json['perprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['quantity'] = this.quantity;
    data['sellerId'] = this.sellerId;
    data['productId'] = this.productId;
    data['deliveryTime'] = this.deliveryTime;
    data['price'] = this.price;
    data['name'] = this.name;
    data['orderLimit'] = this.orderLimit;
    data['index'] = this.index;
    data['size'] = this.size;
    data['perprice'] = this.perprice;
    return data;
  }
}
