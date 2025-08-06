// lib/models/history_item.dart

class HistoryItem {
final String projectName;
final double totalCost;
final DateTime date;

HistoryItem({
required this.projectName,
required this.totalCost,
required this.date,
});
}