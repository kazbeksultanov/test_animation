import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_animation/main_page/bloc/main_page_bloc.dart';
import 'package:test_animation/main_page/m_main_page.dart';

MainPageBloc _bloc(BuildContext context) => BlocProvider.of(context);

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
          final itemList = state.myBagList;
          final totalCost = itemList.isNotEmpty
              ? '\$${itemList.map((e) => e.cardItemData.cost).toList().reduce((v, e) => v + e)}'
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
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    itemCount: itemList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _CardItemUi(data: itemList[index]),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 28),
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

class _CardItemUi extends StatelessWidget {
  final MyBagItem data;

  const _CardItemUi({required this.data});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Colors.grey.shade900,
    );
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          height: 120,
          width: 150,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  height: 100,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: const BorderRadius.all(Radius.circular(36)),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: -20,
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset(data.cardItemData.assetUrl),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.cardItemData.model,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '\$${data.cardItemData.cost}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _bloc(context).add(
                      OnChangeCountToMyBagItemTap(data.cardItemData.tagBox, false),
                    );
                  },
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
                  onTap: () {
                    _bloc(context).add(
                      OnChangeCountToMyBagItemTap(data.cardItemData.tagBox, true),
                    );
                  },
                  child: Container(
                    color: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    child: Text('+', style: style),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
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

// class _AnimatedCounter extends StatelessWidget {
//   final int value;
//   final TextStyle style;
//
//   const _AnimatedCounter({
//     required this.value,
//     required this.style,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final styleR = DefaultTextStyle.of(context).style.merge(style);
//     // Layout number "8" (probably the widest digit) to see its size
//     final prototypeDigit = TextPainter(
//       text: TextSpan(text: value.toString(), style: styleR),
//       textDirection: TextDirection.ltr,
//       textScaleFactor: MediaQuery.of(context).textScaleFactor,
//     )..layout();
//     print(prototypeDigit.size);
//     return TweenAnimationBuilder(
//       curve: Curves.linear,
//       duration: const Duration(milliseconds: 100),
//       tween: Tween<double>(end: prototypeDigit.size.height),
//       builder: (BuildContext c, double? v, Widget? cc) {
//         print(v);
//         return SizedBox(
//           height: prototypeDigit.height,
//           width: prototypeDigit.width,
//           child: Stack(
//             children: [
//               Positioned(
//                 right: 0,
//                 left: 0,
//                 bottom: -(v ?? 0) + prototypeDigit.size.height,
//                 child: Text(
//                   value.toString(),
//                   style: style,
//                 ),
//               ),
//               Positioned(
//                 right: 0,
//                 left: 0,
//                 bottom: -(v ?? 0),
//                 child: Text(
//                   value.toString(),
//                   style: style,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
