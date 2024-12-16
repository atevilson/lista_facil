class NewItems {
  final int? id;
  final String items;
  final int quantity;
  double? price;
  int? listId;
  bool isChecked;
  bool? isEditing;

  NewItems({this.id, required this.items, required this.quantity, this.listId, this.price, this.isChecked = false, this.isEditing});

  // @override
  // String toString() {
  //   return 'NewLists{items: $id, $items, $quantity, $listId}';
  // }
}