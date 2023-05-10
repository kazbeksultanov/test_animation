part of 'main_page_bloc.dart';

abstract class MainPageState extends Equatable {
  const MainPageState();
}

enum NavBarIndex { discover, favourite, myPlace, myBag, profile }

extension NavBarIndexExt on NavBarIndex {
  int toInt() {
    switch (this) {
      case NavBarIndex.discover:
        return 0;
      case NavBarIndex.favourite:
        return 1;
      case NavBarIndex.myPlace:
        return 2;
      case NavBarIndex.myBag:
        return 3;
      case NavBarIndex.profile:
        return 4;
    }
  }

  static NavBarIndex fromInt(int index) {
    switch (index) {
      case 0:
        return NavBarIndex.discover;
      case 1:
        return NavBarIndex.favourite;
      case 2:
        return NavBarIndex.myPlace;
      case 3:
        return NavBarIndex.myBag;
      case 4:
        return NavBarIndex.profile;
    }

    throw UnsupportedError('index:$index is not defined');
  }
}

class MainPageBaseState extends MainPageState {
  final NavBarIndex indexNavBar;
  final List<MyBagItem> myBagListSet;
  final bool reset;

  const MainPageBaseState({
    required this.indexNavBar,
    required this.myBagListSet,
    required this.reset,
  });

  @override
  List<Object> get props => [indexNavBar, myBagListSet, reset];
}
