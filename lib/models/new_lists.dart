class NewLists {
  final int id;
  final String nameList;
  final double? budget;

  NewLists(this.id, this.nameList, this.budget);

  @override
  String toString() {
    return 'NewLists{lista: $id $nameList}';
  }
}
