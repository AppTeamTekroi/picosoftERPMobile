// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BarcodeSearchModel {
  String? filter;
  BarcodeSearchModel({
    this.filter,
  });

  BarcodeSearchModel copyWith({
    String? filter,
  }) {
    return BarcodeSearchModel(
      filter: filter ?? this.filter,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filter': filter,
    };
  }

  factory BarcodeSearchModel.fromMap(Map<String, dynamic> map) {
    return BarcodeSearchModel(
      filter: map['filter'] != null ? map['filter'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BarcodeSearchModel.fromJson(String source) => BarcodeSearchModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BarcodeSearchMode(filter: $filter)';

  @override
  bool operator ==(covariant BarcodeSearchModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.filter == filter;
  }

  @override
  int get hashCode => filter.hashCode;
}
