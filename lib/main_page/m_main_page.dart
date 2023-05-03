import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum MyBagItemState { toBeAdd, add, remove, set }

// extension MyBagItemStateExt on MyBagItemState {
//   AnimationAction toAction() {
//     switch (this) {
//       case MyBagItemState.toBeAdd:
//       case MyBagItemState.add:
//       case MyBagItemState.set:
//         return AnimationAction.appear;
//       case MyBagItemState.remove:
//         return AnimationAction.disappear;
//     }
//   }
// }

class MyBagItem extends Equatable {
  final CardItemData cardItemData;
  final int count;
  final MyBagItemState state;

  const MyBagItem({
    required this.cardItemData,
    required this.count,
    required this.state,
  });

  @override
  List<Object?> get props => [cardItemData, count, state];

  @override
  String toString() {
    return 'MyBagItem(cardItemData.tagBox: ${cardItemData.tagBox}, state:$state, count:$count)';
  }
}

class CardItemData extends Equatable {
  final Color color;
  final String tagBox;
  final String tagImage;
  final String assetUrl;
  final String brandName;
  final String model;
  final String shortInfo;
  final int cost;

  const CardItemData({
    required this.color,
    required this.tagBox,
    required this.tagImage,
    required this.assetUrl,
    required this.brandName,
    required this.model,
    required this.shortInfo,
    required this.cost,
  });

  @override
  List<Object?> get props => [color, tagBox, tagImage, assetUrl, brandName, model, cost, shortInfo];
}

class BranData extends Equatable {
  final String name;
  final bool isSelected;

  const BranData(this.name, {this.isSelected = false});

  @override
  List<Object?> get props => [name, isSelected];
}

const brandNames = <BranData>[
  BranData('Nike', isSelected: true),
  BranData('Addidas'),
  BranData('Jordan'),
  BranData('Puma'),
  BranData('Rebook'),
  BranData('Nike'),
  BranData('Addidas'),
  BranData('Jordan'),
  BranData('Puma'),
  BranData('Rebook'),
];

const cardList = <CardItemData>[
  CardItemData(
    tagBox: '1',
    tagImage: '1i',
    color: Colors.cyan,
    // color: Color(0xFF35739F),
    assetUrl: 'images/sneaker_01.png',
    brandName: 'NIKE',
    cost: 130,
    model: 'EPIC-REACT',
    shortInfo:
        r"The Nike Epic React is a $150 neutral runneing shoe featuring a Flyknit upper with a stack height of 28mm (heel) to 18mm (forefoot) that features Nike's brand new proprietary foam called Epic React.",
  ),
  CardItemData(
    tagBox: '2',
    tagImage: '2i',
    color: Colors.green,
    // color: Color(0xFF433381),
    assetUrl: 'images/sneaker_02.png',
    brandName: 'NIKE',
    cost: 130,
    model: 'AIR-MAX',
    shortInfo:
        r"Nike Air Max is a line of shoes produced by Nike, Inc., with the first model released in 1987. Air Max shoes are identified by their midsoles incorporating flexible urethane pouches filled with pressurized gas, visible from the exterior of the shoe and intended to provide cushioning to the underfoot.",
  ),
  CardItemData(
    tagBox: '3',
    tagImage: '3i',
    color: Colors.brown,
    // color: Color(0xFF214A6D),
    assetUrl: 'images/sneaker_03.png',
    brandName: 'NIKE',
    cost: 150,
    model: 'AIR-270',
    shortInfo:
        r"Embrace Swoosh heritage when you step out in these men's Air Max 270 sneakers from Nike. Τhese running-inspired kicks have a breathable mesh and lightweight synthetic upper for a classic look and feel. They feature a low-cut, padded ankle collar, as well as a tonal lace-up front and a heel pull for easy on-and-off. Underfoot, a soft foam midsole combines with 270 degrees of visisble Air cushioning for an ultra-plush, responsive ride. With a grippy rubber outsole for street-ready traction, these trainers are finished off with signature Swoosh and Air Max branding throughout.",
  ),
  CardItemData(
    tagBox: '4',
    tagImage: '4i',
    color: Colors.orange,
    // color: const Color(0xFF4760B9),
    assetUrl: 'images/sneaker_04.png',
    brandName: 'NIKE',
    cost: 110,
    model: 'AIR-200',
    shortInfo:
        r"Embrace Swoosh heritage when you step out in these men's Air Max 270 sneakers from Nike. Τhese running-inspired kicks have a breathable mesh and lightweight synthetic upper for a classic look and feel. They feature a low-cut, padded ankle collar, as well as a tonal lace-up front and a heel pull for easy on-and-off. Underfoot, a soft foam midsole combines with 270 degrees of visisble Air cushioning for an ultra-plush, responsive ride. With a grippy rubber outsole for street-ready traction, these trainers are finished off with signature Swoosh and Air Max branding throughout.",
  ),
  // CardItemData(
  //   id: '5',
  //   color: Colors.brown,
  //   assetUrl: 'images/sneaker_01.png',
  //   brandName: 'NIKE',
  //   cost: r'$90',
  //   model: 'EPIC-MAX',
  // ),
];

const brandTypes = ['Upcoming', 'Featured', 'New'];
