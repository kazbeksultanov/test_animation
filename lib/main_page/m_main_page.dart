import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CardItemData extends Equatable {
  final Color color;
  final String tagBox;
  final String tagImage;
  final String assetUrl;
  final String brandName;
  final String model;
  final String cost;

  const CardItemData({
    required this.color,
    required this.tagBox,
    required this.tagImage,
    required this.assetUrl,
    required this.brandName,
    required this.model,
    required this.cost,
  });

  @override
  List<Object?> get props => [color, tagBox, tagImage, assetUrl, brandName, model, cost];
}

class BranData extends Equatable {
  final String name;
  final bool isSelected;

  const BranData(this.name, {this.isSelected = false});

  @override
  List<Object?> get props => [name, isSelected];
}
