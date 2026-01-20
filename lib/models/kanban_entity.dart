class KanbanEntity {
  final String? buyerName;
  final String? style;
  final String? buyerPO;
  final String? lineName;
  final String? color;
  final String? kanbanType;
  final String? sectionName;
  final double? totalQuantity;
  final double? totalProduction;
  final double? scanType1;
  final double? scanType3;
  final double? scanType4;
  final double? scanType5;

  KanbanEntity({
    this.buyerName,
    this.style,
    this.buyerPO,
    this.lineName,
    this.color,
    this.kanbanType,
    this.sectionName,
    this.totalQuantity,
    this.totalProduction,
    this.scanType1,
    this.scanType3,
    this.scanType4,
    this.scanType5,
  });

  factory KanbanEntity.fromJson(Map<String, dynamic> json) => KanbanEntity(
    buyerName: json['BuyerName'],
    style: json['Style'],
    buyerPO: json['BuyerPO'],
    lineName: json['LineName'],
    color: json['Color'],
    kanbanType: json['KanbanType'],
    sectionName: json['SectionName'],
    totalQuantity: _toDouble(json['TotalQuantity']),
    totalProduction: _toDouble(json['TotalProduction']),
    scanType1: _toDouble(json['ScanType1']),
    scanType3: _toDouble(json['ScanType3']),
    scanType4: _toDouble(json['ScanType4']),
    scanType5: _toDouble(json['ScanType5']),
  );

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}