// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Address {
  String userId;
  String addressId;
  String name;
  double latitude;
  double longitude;
  String address;
  String phoneNumber;
  String area; // منطقة
  String street; // شارع
  String building; // عمارة
  String floor; // دور
  String apartment; // شقة
  String landmark; // علامة مميزة
  Address({
    required this.userId,
    required this.addressId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.phoneNumber,
    required this.area,
    required this.street,
    required this.building,
    required this.floor,
    required this.apartment,
    required this.landmark,
  });
 

  Address copyWith({
    String? userId,
    String? addressId,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    String? phoneNumber,
    String? area,
    String? street,
    String? building,
    String? floor,
    String? apartment,
    String? landmark,
  }) {
    return Address(
      userId: userId ?? this.userId,
      addressId: addressId ?? this.addressId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      area: area ?? this.area,
      street: street ?? this.street,
      building: building ?? this.building,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      landmark: landmark ?? this.landmark,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'addressId': addressId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'phoneNumber': phoneNumber,
      'area': area,
      'street': street,
      'building': building,
      'floor': floor,
      'apartment': apartment,
      'landmark': landmark,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      userId: map['userId'] as String,
      addressId: map['addressId'] as String,
      name: map['name'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      address: map['address'] as String,
      phoneNumber: map['phoneNumber'] as String,
      area: map['area'] as String? ?? '',
      street: map['street'] as String? ?? '',
      building: map['building'] as String? ?? '',
      floor: map['floor'] as String? ?? '',
      apartment: map['apartment'] as String? ?? '',
      landmark: map['landmark'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) => Address.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Address(userId: $userId, addressId: $addressId, name: $name, latitude: $latitude, longitude: $longitude, address: $address, phoneNumber: $phoneNumber, area: $area, street: $street, building: $building, floor: $floor, apartment: $apartment, landmark: $landmark)';
  }

  @override
  bool operator ==(covariant Address other) {
    if (identical(this, other)) return true;
  
    return 
      other.userId == userId &&
      other.addressId == addressId &&
      other.name == name &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.address == address &&
      other.phoneNumber == phoneNumber &&
      other.area == area &&
      other.street == street &&
      other.building == building &&
      other.floor == floor &&
      other.apartment == apartment &&
      other.landmark == landmark;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      addressId.hashCode ^
      name.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      address.hashCode ^
      phoneNumber.hashCode ^
      area.hashCode ^
      street.hashCode ^
      building.hashCode ^
      floor.hashCode ^
      apartment.hashCode ^
      landmark.hashCode;
  }
}
