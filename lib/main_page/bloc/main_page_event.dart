part of 'main_page_bloc.dart';

abstract class MainPageEvent extends Equatable {
  const MainPageEvent();
}

class OnBottomNavTap extends MainPageEvent {
  final int index;

  const OnBottomNavTap(this.index);

  @override
  List<Object?> get props => [index];
}
