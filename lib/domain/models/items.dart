class Items {
  final int? id;
  final String items;
  final int quantity;
  final String? createdAt;
  double? price;
  int? listId;
  bool isChecked;
  bool? isEditing;

  Items({this.id, 
  required this.items, 
  required this.quantity, 
  this.createdAt,
  this.listId, 
  this.price, 
  this.isChecked = false, 
  this.isEditing});

}