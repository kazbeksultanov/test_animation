part of 'main_page_bloc.dart';

abstract class MainPageState extends Equatable {
  const MainPageState();
}

class MainPageBaseState extends MainPageState {
  final int indexNavBar;
  final List<MyBagItem> myBagList;

  const MainPageBaseState({
    required this.indexNavBar,
    required this.myBagList,
  });

  @override
  List<Object> get props => [indexNavBar, myBagList];
}
