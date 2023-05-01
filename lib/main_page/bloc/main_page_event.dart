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

class OnAddToMyBagTap extends MainPageEvent {
  final CardItemData data;

  const OnAddToMyBagTap(this.data);

  @override
  List<Object?> get props => [data];
}

class OnRemoveFromMyBagTap extends MainPageEvent {
  final CardItemData data;

  const OnRemoveFromMyBagTap(this.data);

  @override
  List<Object?> get props => [data];
}

class OnChangeCountToMyBagItemTap extends MainPageEvent {
  final String tagBox;
  final bool isAdd;

  const OnChangeCountToMyBagItemTap(this.tagBox, this.isAdd);

  @override
  List<Object?> get props => [tagBox];
}
