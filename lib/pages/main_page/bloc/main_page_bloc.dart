import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_animation/pages/main_page/m_main_page.dart';

part 'main_page_event.dart';
part 'main_page_state.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  MainPageBloc()
      : super(const MainPageBaseState(
          indexNavBar: NavBarIndex.discover,
          myBagListSet: [],
          reset: false,
        )) {
    on<OnBottomNavTap>(_onNavBarTap);
    on<OnAddToMyBagTap>(_onAddToMyBagTap);
    on<OnChangeCountToMyBagItemTap>(_onChangeCountToMyBagItemTap);
  }

  Future<void> _onNavBarTap(OnBottomNavTap event, Emitter<MainPageState> emit) async {
    final currentState = state as MainPageBaseState;
    final isAnythingToAdd = currentState.myBagListSet
        .where(
          (e) => e.state == MyBagItemState.toBeAdd,
        )
        .isNotEmpty;
    if (event.index == NavBarIndex.myBag && isAnythingToAdd) {
      final res = <MyBagItem>[];
      for (final e in currentState.myBagListSet) {
        if (e.state == MyBagItemState.toBeAdd) {
          res.add(MyBagItem(
            count: e.count,
            cardItemData: e.cardItemData,
            state: MyBagItemState.add,
          ));
        } else {
          res.add(e);
        }
      }
      emit(MainPageBaseState(
        indexNavBar: event.index,
        myBagListSet: res,
        reset: false,
      ));
      await _putSetToAll(emit);
    } else {
      emit(MainPageBaseState(
        indexNavBar: event.index,
        myBagListSet: currentState.myBagListSet,
        reset: true,
      ));
    }
  }

  Future<void> _onAddToMyBagTap(OnAddToMyBagTap event, Emitter<MainPageState> emit) async {
    final currentState = state as MainPageBaseState;
    emit(MainPageBaseState(
      indexNavBar: currentState.indexNavBar,
      reset: false,
      myBagListSet: [
        MyBagItem(
          cardItemData: event.data,
          count: 1,
          state: MyBagItemState.toBeAdd,
        ),
        ...currentState.myBagListSet,
      ],
    ));
  }

  Future<void> _onChangeCountToMyBagItemTap(
    OnChangeCountToMyBagItemTap event,
    Emitter<MainPageState> emit,
  ) async {
    final currentState = state as MainPageBaseState;
    final result = <MyBagItem>[];
    MyBagItem? myBagItem;
    bool isRemoving = false;
    for (final e in currentState.myBagListSet) {
      if (e.cardItemData.tagBox == event.tagBox) {
        final newCount = event.isAdd ? e.count + 1 : e.count - 1;
        if (!isRemoving && newCount <= 0) {
          isRemoving = true;
        }
        myBagItem = MyBagItem(
          cardItemData: e.cardItemData,
          count: newCount >= 0 ? newCount : 0,
          state: newCount <= 0 ? MyBagItemState.remove : MyBagItemState.set,
        );
      } else {
        myBagItem = e;
      }
      result.add(myBagItem);
    }
    emit(MainPageBaseState(
      indexNavBar: currentState.indexNavBar,
      myBagListSet: result,
      reset: false,
    ));

    if (isRemoving) {
      await _putSetToAll(emit);
    }
  }

  Future<void> _putSetToAll(Emitter<MainPageState> emit) async {
    final currentState = state as MainPageBaseState;
    await Future.delayed(Duration(milliseconds: currentState.myBagListSet.length * 100 + 1500));
    final result = <MyBagItem>[];
    MyBagItem? myBagItem;
    for (final e in currentState.myBagListSet) {
      if (e.state == MyBagItemState.add) {
        myBagItem = MyBagItem(
          cardItemData: e.cardItemData,
          count: e.count,
          state: MyBagItemState.set,
        );
      } else if (e.state == MyBagItemState.remove) {
        myBagItem = null;
      } else {
        myBagItem = e;
      }
      if (myBagItem != null) {
        result.add(myBagItem);
      }
    }
    final currentStateNew = state as MainPageBaseState;
    emit(MainPageBaseState(
      indexNavBar: currentStateNew.indexNavBar,
      myBagListSet: result,
      reset: true,
    ));
  }
}
