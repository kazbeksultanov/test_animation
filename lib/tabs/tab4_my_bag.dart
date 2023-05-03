import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_animation/main_page/bloc/main_page_bloc.dart';
import 'package:test_animation/main_page/m_main_page.dart';

MainPageBloc _bloc(BuildContext context) => BlocProvider.of(context);

const _cardHeight = 120.0;
const _cardSpace = 28.0;
const _animationInMillSec = 1000;

class Tab4MyBag extends StatelessWidget {
  const Tab4MyBag({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarTitleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 32,
        );
    final textStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        );

    return BlocBuilder<MainPageBloc, MainPageState>(
      builder: (context, state) {
        if (state is MainPageBaseState) {
          final itemList = state.myBagListSet.where((e) => e.state != MyBagItemState.remove);
          final totalCost = itemList.isNotEmpty
              ? '\$${itemList.map((e) => e.cardItemData.cost * e.count).toList().reduce((v, e) => v + e)}'
              : r'$0';
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('My Bag', style: appBarTitleStyle),
                  const Spacer(),
                  Text('Total ${itemList.length} item(s)', style: textStyle),
                ],
              ),
            ),
            body: Column(
              children: [
                const SizedBox(height: 1, child: Divider(color: Colors.grey)),
                Expanded(
                  child: ClipRect(
                    child: _AnimatedListView(state),
                  ),
                ),
                const SizedBox(height: 1, child: Divider(color: Colors.grey)),
                _BottomPart(totalCost),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _AnimatedListView extends StatelessWidget {
  final MainPageBaseState state;

  const _AnimatedListView(this.state);

  static const transitionStepDelayMilSec = 100;

  @override
  Widget build(BuildContext context) {
    final allList = state.myBagListSet.where((e) => e.state != MyBagItemState.toBeAdd).toList();
    final addList = state.myBagListSet.where((e) => e.state == MyBagItemState.add).toList();
    final removingItemIndex =
        state.myBagListSet.indexWhere((e) => e.state == MyBagItemState.remove);
    final isRemoving = removingItemIndex >= 0;

    final diffOnAdd = allList.length - addList.length;
    final delayBeforeAddItemsAppear =
        (diffOnAdd) > 0 ? diffOnAdd * transitionStepDelayMilSec + _animationInMillSec ~/ 2 : 0;
    final numCardToSlideOnAdd = addList.length;
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: allList.length,
      itemBuilder: (BuildContext context, int index) {
        final item = allList[index];
        int millisecondsDelay = 0;

        if (addList.isNotEmpty && item.state != MyBagItemState.add) {
          millisecondsDelay = transitionStepDelayMilSec * ((allList.length - index));
        } else if (isRemoving) {
          millisecondsDelay = transitionStepDelayMilSec * (index);
        }

        final actualNumCardSlid = isRemoving && removingItemIndex < index
            ? -1
            : item.state == MyBagItemState.set
                ? numCardToSlideOnAdd
                : 0;
        final translateDelay =
            isRemoving ? millisecondsDelay + _animationInMillSec ~/ 2 : millisecondsDelay;
        final appearDelay = item.state == MyBagItemState.add ? delayBeforeAddItemsAppear : 0;
        debugPrint('state: ${item.state}, '
            'index:$index, '
            'millisecondsDelay:$millisecondsDelay, '
            'delayBeforeAddItemsAppear:$delayBeforeAddItemsAppear, '
            'removingItemIndex:$removingItemIndex, '
            'actualNumCardSlid:$actualNumCardSlid');
        return _CardItemUi(
          data: item,
          numCardToSlide: actualNumCardSlid,
          translateDelay: translateDelay,
          itemState: item.state,
          reset: state.reset,
          appearDelay: appearDelay,
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: _cardSpace),
    );
  }
}

class _CardItemUi extends StatelessWidget {
  final MyBagItem data;
  final MyBagItemState itemState;
  final int numCardToSlide;
  final int translateDelay;
  final int appearDelay;
  final bool reset;

  const _CardItemUi({
    required this.data,
    required this.itemState,
    required this.numCardToSlide,
    required this.translateDelay,
    required this.appearDelay,
    required this.reset,
  });

  @override
  Widget build(BuildContext context) {
    double? end;
    double? begin;
    if (itemState == MyBagItemState.add) {
      begin = 0;
      end = 1;
    } else if (itemState == MyBagItemState.remove) {
      begin = 1;
      end = 0;
    } else {
      begin = 1;
      end = 1;
    }

    final duration = reset ? Duration.zero : const Duration(milliseconds: _animationInMillSec);
    if (reset) {
      return _CardBase(
        begin: begin,
        end: end,
        duration: duration,
        data: data,
        delayBeforeAppear: Duration(milliseconds: appearDelay),
      );
    } else {
      final double yOffsetForImmediateTranslate =
          numCardToSlide < 0 ? 0 : -(_cardHeight + _cardSpace) * numCardToSlide.toDouble();

      return Transform.translate(
        offset: Offset(0, yOffsetForImmediateTranslate),
        child: FutureBuilder(
          key: Key(data.cardItemData.tagBox),
          initialData: 0,
          future: Future.delayed(
            Duration(milliseconds: translateDelay),
            () => numCardToSlide,
          ),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            final shift = (_cardHeight + _cardSpace) * snapshot.data!.toDouble();
            return TweenAnimationBuilder<double>(
              duration: duration,
              tween: Tween<double>(end: shift),
              curve: Curves.easeOutExpo,
              child: _CardBase(
                begin: begin,
                end: end,
                duration: duration,
                data: data,
                delayBeforeAppear: Duration(milliseconds: appearDelay),
              ),
              builder: (_, value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: child,
                );
              },
            );
          },
        ),
      );
    }
  }
}

class _CardBase extends StatelessWidget {
  final double? begin;
  final double? end;
  final Duration delayBeforeAppear;
  final Duration duration;
  final MyBagItem data;

  const _CardBase({
    this.begin,
    this.end,
    required this.duration,
    required this.delayBeforeAppear,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final screeWidth = MediaQuery.of(context).size.width / 2.5;
    final modelText = Text(
      data.cardItemData.model,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
    final costText = Text(
      '\$${data.cardItemData.cost}',
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
      ),
    );
    return FutureBuilder<double>(
      initialData: begin!,
      future: Future.delayed(delayBeforeAppear, () => end!),
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        final end = snapshot.data;
        return SizedBox(
          height: _cardHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _ScaleAnimation(
                begin: begin,
                end: end,
                duration: duration,
                assetUrl: data.cardItemData.assetUrl,
              ),
              const SizedBox(width: 42),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FutureBuilder<double>(
                    initialData: begin,
                    future: Future.delayed(
                      const Duration(milliseconds: 0),
                      () => end!,
                    ),
                    builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                      return _FadeTranslateAnimation(
                        duration: duration,
                        begin: begin,
                        end: snapshot.data!,
                        screeWidth: screeWidth,
                        child: modelText,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<double>(
                    initialData: begin,
                    future: Future.delayed(
                      const Duration(milliseconds: 120),
                      () => end!,
                    ),
                    builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                      return _FadeTranslateAnimation(
                        duration: duration,
                        begin: begin,
                        end: snapshot.data!,
                        screeWidth: screeWidth,
                        child: costText,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<double>(
                    initialData: begin,
                    future: Future.delayed(
                      const Duration(milliseconds: 170),
                      () => end!,
                    ),
                    builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                      return _FadeTranslateAnimation(
                        duration: duration,
                        begin: begin,
                        end: snapshot.data!,
                        screeWidth: screeWidth,
                        child: _AddRemoveCount(data),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScaleAnimation extends StatelessWidget {
  final Duration duration;
  final double? begin;
  final double? end;
  final String assetUrl;

  const _ScaleAnimation({
    required this.duration,
    required this.begin,
    required this.end,
    required this.assetUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardHeight,
      width: 150,
      child: TweenAnimationBuilder<double>(
        duration: duration,
        tween: Tween<double>(begin: begin, end: end),
        curve: end == 1 ? Curves.elasticOut : Curves.easeInToLinear,
        builder: (_, value, __) {
          return Stack(
            children: [
              Positioned(
                left: 16,
                bottom: 0,
                child: Transform.scale(
                  scale: value,
                  child: Container(
                    height: 100,
                    width: 110,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: const BorderRadius.all(Radius.circular(36)),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 0,
                top: -20,
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Transform.scale(
                    scale: value,
                    child: Image.asset(assetUrl),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FadeTranslateAnimation extends StatelessWidget {
  final Duration duration;
  final double? begin;
  final double? end;
  final double screeWidth;
  final Widget child;

  const _FadeTranslateAnimation({
    required this.duration,
    required this.begin,
    required this.end,
    required this.screeWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(begin: begin, end: end),
      curve: Curves.linearToEaseOut,
      child: child,
      builder: (_, value, childR) {
        final v = 1 - value;
        final offset = Offset(screeWidth * v, 0);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: offset,
            child: childR,
          ),
        );
      },
    );
  }
}

class _AddRemoveCount extends StatelessWidget {
  final MyBagItem data;

  const _AddRemoveCount(this.data);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade900,
    );
    return Row(
      children: [
        InkWell(
          onTap: () => _bloc(context).add(
            OnChangeCountToMyBagItemTap(data.cardItemData.tagBox, isAdd: false),
          ),
          child: Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            child: Text('—', style: style),
          ),
        ),
        const SizedBox(width: 16),
        Text(data.count.toString(), style: style),
        const SizedBox(width: 16),
        InkWell(
          onTap: () => _bloc(context).add(
            OnChangeCountToMyBagItemTap(data.cardItemData.tagBox, isAdd: true),
          ),
          child: Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            child: Text('+', style: style),
          ),
        ),
      ],
    );
  }
}

class _BottomPart extends StatelessWidget {
  final String totalCost;

  const _BottomPart(this.totalCost);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'TOTAL',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                totalCost,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _AddToBagButton(),
        ],
      ),
    );
  }
}

class _AddToBagButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Material(
        color: Colors.pink,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Expanded(
                  child: Text(
                    'NEXT',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
