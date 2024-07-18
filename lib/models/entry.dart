 class Entry {
  String name;
  double amount;
  DateTime date;
  DateTime dueDate;
  bool paid;

  Entry({
    required this.name,
    required this.amount,
    required this.date,
    required this.dueDate,
    this.paid = false,
  });
}
