class NewItems {
  final int id;
  final String items;
  final int quantity;

  NewItems(this.id, this.items, this.quantity);

  @override
  String toString() {
    return 'NewLists{items: $id, $items, $quantity}';
  }
}