class NewItems {
  final int? id;
  final String items;
  final int quantity;
  int? listId;

  NewItems({this.id, required this.items, required this.quantity, this.listId});

  @override
  String toString() {
    return 'NewLists{items: $id, $items, $quantity, $listId}';
  }
}