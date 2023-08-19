class ProductData{
  ProductData(this.name , this.price , this.imagePath);

  factory ProductData.fromMap(Map<String , dynamic> map){
    return ProductData(
      map['name'],
      map['price'],
      map['image']
    );
  }

  String name;
  String price;
  String imagePath;
}