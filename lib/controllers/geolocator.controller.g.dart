// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geolocator.controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GeolocatorController on GeolocatorControllerBase, Store {
  final _$longitudeAtom = Atom(name: 'GeolocatorControllerBase.longitude');

  @override
  String get longitude {
    _$longitudeAtom.reportRead();
    return super.longitude;
  }

  @override
  set longitude(String value) {
    _$longitudeAtom.reportWrite(value, super.longitude, () {
      super.longitude = value;
    });
  }

  final _$dateAtom = Atom(name: 'GeolocatorControllerBase.date');

  @override
  String get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  @override
  set date(String value) {
    _$dateAtom.reportWrite(value, super.date, () {
      super.date = value;
    });
  }

  final _$latitudeAtom = Atom(name: 'GeolocatorControllerBase.latitude');

  @override
  String get latitude {
    _$latitudeAtom.reportRead();
    return super.latitude;
  }

  @override
  set latitude(String value) {
    _$latitudeAtom.reportWrite(value, super.latitude, () {
      super.latitude = value;
    });
  }

  final _$accuracyAtom = Atom(name: 'GeolocatorControllerBase.accuracy');

  @override
  String get accuracy {
    _$accuracyAtom.reportRead();
    return super.accuracy;
  }

  @override
  set accuracy(String value) {
    _$accuracyAtom.reportWrite(value, super.accuracy, () {
      super.accuracy = value;
    });
  }

  final _$isLoadingAtom = Atom(name: 'GeolocatorControllerBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$GeolocatorControllerBaseActionController =
      ActionController(name: 'GeolocatorControllerBase');

  @override
  dynamic mudaLongitude(dynamic value) {
    final _$actionInfo = _$GeolocatorControllerBaseActionController.startAction(
        name: 'GeolocatorControllerBase.mudaLongitude');
    try {
      return super.mudaLongitude(value);
    } finally {
      _$GeolocatorControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudaDate(dynamic value) {
    final _$actionInfo = _$GeolocatorControllerBaseActionController.startAction(
        name: 'GeolocatorControllerBase.mudaDate');
    try {
      return super.mudaDate(value);
    } finally {
      _$GeolocatorControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudaLatitude(dynamic value) {
    final _$actionInfo = _$GeolocatorControllerBaseActionController.startAction(
        name: 'GeolocatorControllerBase.mudaLatitude');
    try {
      return super.mudaLatitude(value);
    } finally {
      _$GeolocatorControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudaAccuracy(dynamic value) {
    final _$actionInfo = _$GeolocatorControllerBaseActionController.startAction(
        name: 'GeolocatorControllerBase.mudaAccuracy');
    try {
      return super.mudaAccuracy(value);
    } finally {
      _$GeolocatorControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic mudaLoading(dynamic value) {
    final _$actionInfo = _$GeolocatorControllerBaseActionController.startAction(
        name: 'GeolocatorControllerBase.mudaLoading');
    try {
      return super.mudaLoading(value);
    } finally {
      _$GeolocatorControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
longitude: ${longitude},
date: ${date},
latitude: ${latitude},
accuracy: ${accuracy},
isLoading: ${isLoading}
    ''';
  }
}
