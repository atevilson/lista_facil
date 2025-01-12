class Lists {
  final int id;
  final String nameList;
  final double? budget;
  final String? createdAt;
  bool bookMarked = false;

  Lists(this.id, 
  this.nameList, 
  this.budget,
  this.createdAt, 
  {this.bookMarked = false});

}
