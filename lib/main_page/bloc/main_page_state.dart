part of 'main_page_bloc.dart';

abstract class MainPageState extends Equatable {
  const MainPageState();
}

class MainPageInitial extends MainPageState {
  final int indexNavBar;

  const MainPageInitial({required this.indexNavBar});

  @override
  List<Object> get props => [indexNavBar];
}
