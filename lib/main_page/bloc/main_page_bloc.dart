import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_animation/main_page/m_main_page.dart';

part 'main_page_event.dart';
part 'main_page_state.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  MainPageBloc()
      : super(const MainPageBaseState(
          indexNavBar: 0,
          myBagList: [],
        )) {
    on<OnBottomNavTap>(_onNavBarTap);
    on<OnAddToMyBagTap>(_onAddToMyBagTap);
    on<OnRemoveFromMyBagTap>(_onRemoveFromMyBagTap);
    on<OnChangeCountToMyBagItemTap>(_onChangeCountToMyBagItemTap);
  }

  Future<void> _onNavBarTap(OnBottomNavTap event, Emitter<MainPageState> emit) async {
    final currentState = state as MainPageBaseState;
    emit(MainPageBaseState(
      indexNavBar: event.index,
      myBagList: currentState.myBagList,
    ));
  }

  Future<void> _onAddToMyBagTap(OnAddToMyBagTap event, Emitter<MainPageState> emit) async {
    final currentState = state as MainPageBaseState;
    emit(MainPageBaseState(
      indexNavBar: currentState.indexNavBar,
      myBagList: [...currentState.myBagList, MyBagItem(cardItemData: event.data, count: 1)],
    ));
  }

  Future<void> _onRemoveFromMyBagTap(
    OnRemoveFromMyBagTap event,
    Emitter<MainPageState> emit,
  ) async {
    final currentState = state as MainPageBaseState;
    emit(MainPageBaseState(
      indexNavBar: currentState.indexNavBar,
      myBagList: [...currentState.myBagList]
        ..removeWhere((e) => e.cardItemData.tagBox == event.data.tagBox),
    ));
  }

  Future<void> _onChangeCountToMyBagItemTap(
    OnChangeCountToMyBagItemTap event,
    Emitter<MainPageState> emit,
  ) async {
    final currentState = state as MainPageBaseState;
    final result = <MyBagItem>[];
    MyBagItem? myBagItem;
    for (final e in currentState.myBagList) {
      if (e.cardItemData.tagBox == event.tagBox) {
        final newCount = event.isAdd ? e.count + 1 : e.count - 1;
        myBagItem = MyBagItem(
          cardItemData: e.cardItemData,
          count: newCount >= 0 ? newCount : 0,
        );
      } else {
        myBagItem = e;
      }

      result.add(myBagItem);
    }
    emit(MainPageBaseState(
      indexNavBar: currentState.indexNavBar,
      myBagList: result,
    ));
  }
}
