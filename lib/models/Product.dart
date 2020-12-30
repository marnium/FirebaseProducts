class Product {
  final String id;
  final String name;
  final double price;
  final String detail;
  final int amount;

  Product({this.id, this.name, this.price, this.detail, this.amount});
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "price": price,
      "detail": detail,
      "amount": amount,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        detail: json['detail'],
        amount: json['amount']);
  }
}
