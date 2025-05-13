class DashboardStats {
  final int totalLocations;
  final int transferMovements;
  final int outMovements;
  final int inMovements;
  final int totalInventory;

  DashboardStats({
    required this.totalLocations,
    required this.transferMovements,
    required this.outMovements,
    required this.inMovements,
    required this.totalInventory,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalLocations: json['totalLocations'] ?? 0,
      transferMovements: json['transferMovements'] ?? 0,
      outMovements: json['outMovements'] ?? 0,
      inMovements: json['inMovements'] ?? 0,
      totalInventory: json['totalInventory'] ?? 0,
    );
  }
}
