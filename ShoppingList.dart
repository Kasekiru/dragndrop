class ShoppingList {
  ShoppingList(this.id, this.name, this.sum);
  int id;
  String name;
  int sum;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sum': sum,
    };
  }

  @override
  String toString() {
    return "id : $id\nname : $name\nsum : $sum";
  }
}