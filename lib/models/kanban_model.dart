class KanbanModel {
  KanbanModel({
      String? buyerName, 
      String? style, 
      String? buyerPO, 
      String? lineName, 
      String? color, 
      String? kanbanType, 
      String? sectionName, 
      num? totalQuantity, 
      num? totalProduction, 
      num? scanType1, 
      num? scanType3, 
      num? scanType4, 
      num? scanType5,}){
    _buyerName = buyerName;
    _style = style;
    _buyerPO = buyerPO;
    _lineName = lineName;
    _color = color;
    _kanbanType = kanbanType;
    _sectionName = sectionName;
    _totalQuantity = totalQuantity;
    _totalProduction = totalProduction;
    _scanType1 = scanType1;
    _scanType3 = scanType3;
    _scanType4 = scanType4;
    _scanType5 = scanType5;
}

  KanbanModel.fromJson(dynamic json) {
    _buyerName = json['BuyerName'];
    _style = json['Style'];
    _buyerPO = json['BuyerPO'];
    _lineName = json['LineName'];
    _color = json['Color'];
    _kanbanType = json['KanbanType'];
    _sectionName = json['SectionName'];
    _totalQuantity = json['TotalQuantity'];
    _totalProduction = json['TotalProduction'];
    _scanType1 = json['ScanType1'];
    _scanType3 = json['ScanType3'];
    _scanType4 = json['ScanType4'];
    _scanType5 = json['ScanType5'];
  }
  String? _buyerName;
  String? _style;
  String? _buyerPO;
  String? _lineName;
  String? _color;
  String? _kanbanType;
  String? _sectionName;
  num? _totalQuantity;
  num? _totalProduction;
  num? _scanType1;
  num? _scanType3;
  num? _scanType4;
  num? _scanType5;
KanbanModel copyWith({  String? buyerName,
  String? style,
  String? buyerPO,
  String? lineName,
  String? color,
  String? kanbanType,
  String? sectionName,
  num? totalQuantity,
  num? totalProduction,
  num? scanType1,
  num? scanType3,
  num? scanType4,
  num? scanType5,
}) => KanbanModel(  buyerName: buyerName ?? _buyerName,
  style: style ?? _style,
  buyerPO: buyerPO ?? _buyerPO,
  lineName: lineName ?? _lineName,
  color: color ?? _color,
  kanbanType: kanbanType ?? _kanbanType,
  sectionName: sectionName ?? _sectionName,
  totalQuantity: totalQuantity ?? _totalQuantity,
  totalProduction: totalProduction ?? _totalProduction,
  scanType1: scanType1 ?? _scanType1,
  scanType3: scanType3 ?? _scanType3,
  scanType4: scanType4 ?? _scanType4,
  scanType5: scanType5 ?? _scanType5,
);
  String? get buyerName => _buyerName;
  String? get style => _style;
  String? get buyerPO => _buyerPO;
  String? get lineName => _lineName;
  String? get color => _color;
  String? get kanbanType => _kanbanType;
  String? get sectionName => _sectionName;
  num? get totalQuantity => _totalQuantity;
  num? get totalProduction => _totalProduction;
  num? get scanType1 => _scanType1;
  num? get scanType3 => _scanType3;
  num? get scanType4 => _scanType4;
  num? get scanType5 => _scanType5;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['BuyerName'] = _buyerName;
    map['Style'] = _style;
    map['BuyerPO'] = _buyerPO;
    map['LineName'] = _lineName;
    map['Color'] = _color;
    map['KanbanType'] = _kanbanType;
    map['SectionName'] = _sectionName;
    map['TotalQuantity'] = _totalQuantity;
    map['TotalProduction'] = _totalProduction;
    map['ScanType1'] = _scanType1;
    map['ScanType3'] = _scanType3;
    map['ScanType4'] = _scanType4;
    map['ScanType5'] = _scanType5;
    return map;
  }

}