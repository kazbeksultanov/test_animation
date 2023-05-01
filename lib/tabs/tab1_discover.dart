import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_animation/common/widgets/image_png_with_shadow.dart';
import 'package:test_animation/detail_page.dart';
import 'package:test_animation/main_page/bloc/main_page_bloc.dart';
import 'package:test_animation/main_page/m_main_page.dart';

const oneDegree = pi / 180;

MainPageBloc _bloc(BuildContext context) => BlocProvider.of(context);

class Tab1Discover extends StatelessWidget {
  final PageController pageController = PageController(viewportFraction: 0.7);

  Tab1Discover({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarTitleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 32,
        );
    return Column(
      children: [
        AppBar(
          title: Text(
            'Discover',
            style: appBarTitleStyle,
          ),
          actions: [
            _ActionIcon(
              icon: Icons.search,
              onTap: () {
                pageController.previousPage(
                  duration: const Duration(seconds: 1),
                  curve: Curves.linearToEaseOut,
                );
              },
            ),
            const SizedBox(width: 6),
            _ActionIcon(
              icon: Icons.notifications_none_rounded,
              onTap: () {
                pageController.nextPage(
                  duration: const Duration(seconds: 1),
                  curve: Curves.linearToEaseOut,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 24,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: brandNames.map((e) => _BrandUi(e)).toList(),
          ),
        ),
        Expanded(
          child: _MainCardCarousel(
            pageController: pageController,
            brandTypes: brandTypes,
            cardList: cardList,
          ),
        ),
        const _LowerCarousel(cardList),
      ],
    );
  }
}

class _MainCardCarousel extends StatefulWidget {
  final List<String> brandTypes;
  final PageController pageController;
  final List<CardItemData> cardList;

  const _MainCardCarousel({
    required this.brandTypes,
    required this.pageController,
    required this.cardList,
  });

  @override
  State<_MainCardCarousel> createState() => _MainCardCarouselState();
}

class _MainCardCarouselState extends State<_MainCardCarousel> {
  int currentIndex = 0;
  double currentPos = 0;
  bool isOutOfRangeToRight = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.pageController.position.addListener(() {
        currentPos = widget.pageController.page ?? 0;
        isOutOfRangeToRight =
            widget.pageController.position.outOfRange && widget.pageController.offset > 0;
        setState(() {});
      });
    });

    super.initState();
  }

  void _onPageChange(int value) {
    currentIndex = value;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _BrandTypesList(brandTypes: widget.brandTypes),
        PageView.builder(
          pageSnapping: true,
          scrollBehavior: const CupertinoScrollBehavior(),
          physics: const BouncingScrollPhysics(),
          controller: widget.pageController,
          onPageChanged: _onPageChange,
          itemCount: widget.cardList.length,
          padEnds: true,
          itemBuilder: (BuildContext context, int index) {
            final cardData = widget.cardList[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: _bloc(context),
                      child: DetailPage(cardData),
                    ),
                  ),
                );
              },
              child: _CardItemTransform(
                data: cardData,
                index: index,
                pos: currentPos,
              ),
            );
          },
        ),
        if (currentPos % 1 == 0 && !isOutOfRangeToRight)
          _BrandTypesList(brandTypes: widget.brandTypes),
      ],
    );
  }
}

class _LowerCarousel extends StatelessWidget {
  final List<CardItemData> cardList;

  const _LowerCarousel(this.cardList);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'More',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                const Icon(Icons.arrow_right_alt_sharp),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: cardList.length,
              itemBuilder: (BuildContext context, int index) {
                final data = cardList[index];
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  padding: const EdgeInsets.only(right: 8, left: 8, bottom: 16, top: 8),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Image.asset(data.assetUrl)),
                          Text(
                            '${data.brandName} ${data.model}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${data.cost}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const Positioned(
                        right: 0,
                        top: 0,
                        child: Icon(Icons.favorite_border),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          color: Colors.pink,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                          child: RotatedBox(
                            quarterTurns: -1,
                            child: Text(
                              'NEW',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _BrandTypesList extends StatelessWidget {
  final List<String> brandTypes;

  const _BrandTypesList({
    required this.brandTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 22.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: brandTypes.map((e) => _BrandTypes(e)).toList(),
        ),
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  final CardItemData data;

  const _CardItem({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Hero(
          tag: data.tagBox,
          child: Container(
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: const BorderRadius.all(Radius.circular(26)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.brandName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data.model,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${data.cost}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                Row(
                  children: const [
                    Spacer(),
                    Icon(
                      Icons.arrow_right_alt_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardItemTransform extends StatelessWidget {
  final CardItemData data;
  final int index;
  final double pos;

  const _CardItemTransform({
    required this.data,
    required this.index,
    required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    final child = _CardItem(data: data);
    final double dif = (index.toDouble() - pos);

    if (dif >= 0) {
      // Right-Center movement
      final xPos = dif;
      final scale = 0.4 * xPos * xPos - 0.5 * xPos + 1;
      final angle = (125 * xPos - 125 * xPos * xPos) * oneDegree;
      return Stack(
        children: [
          Transform.scale(
            scale: scale,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              alignment: FractionalOffset.center,
              child: child,
            ),
          ),
          Transform.rotate(
            angle: -30 * xPos * oneDegree,
            child: ImagePngWithShadow(
              assetUrl: data.assetUrl,
              tag: data.tagImage,
            ),
          ),
        ],
      );
    } else {
      // Center-Left movement
      final xPos = dif.abs();
      final angle = -(65.5 * xPos - 65.5 * xPos * xPos) * oneDegree;
      final scale = 0.08 * xPos * xPos - 0.08 * xPos + 1;
      final offset = Offset(-xPos * 100, 0);
      return Stack(
        children: [
          Transform.translate(
            offset: offset,
            child: Transform.scale(
              alignment: Alignment.centerRight,
              scale: scale,
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle),
                child: child,
              ),
            ),
          ),
          Transform.translate(
            offset: offset,
            child: ImagePngWithShadow(
              assetUrl: data.assetUrl,
              tag: data.tagImage,
            ),
          ),
        ],
      );
    }
  }
}

class _BrandTypes extends StatelessWidget {
  final String name;

  const _BrandTypes(this.name);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint('Tapped: $runtimeType $name');
      },
      child: RotatedBox(
        quarterTurns: -1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          child: Text(
            name,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}

class _BrandUi extends StatelessWidget {
  final BranData data;

  const _BrandUi(this.data);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint('Tapped: $runtimeType ${data.name}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            gradient: data.isSelected
                ? LinearGradient(
                    colors: [Colors.grey.withOpacity(0.4), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.0, 0.5],
                  )
                : null,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            data.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionIcon({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: Colors.grey.withOpacity(0.3),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
