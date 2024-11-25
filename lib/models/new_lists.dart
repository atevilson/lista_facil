class NewLists {
  final int id;
  final String nameList;
  final double? budget;
  bool bookMarked = false;

  NewLists(this.id, this.nameList, this.budget, {this.bookMarked = false});

  @override
  String toString() {
    return 'NewLists{lista: $id $nameList}';
  }
}
