import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:test_animation/main_page/m_main_page.dart';

part 'main_page_event.dart';
part 'main_page_state.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  MainPageBloc() : super(const MainPageInitial(indexNavBar: 0)) {
    on<OnBottomNavTap>(_onNavBarTap);
  }

  Future<void> _onNavBarTap(OnBottomNavTap event, Emitter<MainPageState> emit) async {
    emit(MainPageInitial(indexNavBar: event.index));
  }
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
    cost: r'$130',
    model: 'EPIC-REACT',
  ),
  CardItemData(
    tagBox: '2',
    tagImage: '2i',
    color: Colors.green,
    // color: Color(0xFF433381),
    assetUrl: 'images/sneaker_02.png',
    brandName: 'NIKE',
    cost: r'$130',
    model: 'AIR-MAX',
  ),
  CardItemData(
    tagBox: '3',
    tagImage: '3i',
    color: Colors.brown,
    // color: Color(0xFF214A6D),
    assetUrl: 'images/sneaker_03.png',
    brandName: 'NIKE',
    cost: r'$150',
    model: 'AIR-270',
  ),
  CardItemData(
    tagBox: '4',
    tagImage: '4i',
    color: Colors.orange,
    // color: const Color(0xFF4760B9),
    assetUrl: 'images/sneaker_04.png',
    brandName: 'NIKE',
    cost: r'$110',
    model: 'AIR-200',
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
