import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_animation/pages/main_page/bloc/main_page_bloc.dart';
import 'package:test_animation/tabs/tab1_discover.dart';
import 'package:test_animation/tabs/tab2_favourite.dart';
import 'package:test_animation/tabs/tab3_my_location.dart';
import 'package:test_animation/tabs/tab4_my_bag.dart';
import 'package:test_animation/tabs/tab5_profile.dart';

MainPageBloc _bloc(BuildContext context) => BlocProvider.of(context);

class MainPageProvider extends StatelessWidget {
  const MainPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainPageBloc(),
      child: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final circleD = screenWidth * 3;

    return Stack(
      children: [
        Container(color: Colors.grey.shade200),
        Positioned(
          bottom: screenHeight / 8,
          left: -(circleD - screenWidth) / 2,
          child: Container(
            height: circleD,
            width: circleD,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<MainPageBloc, MainPageState>(
            builder: (context, state) {
              if (state is MainPageBaseState) {
                return IndexedStack(
                  index: state.indexNavBar.toInt(),
                  children: [
                    Tab1Discover(),
                    const Tab2Favourite(),
                    const Tab3MyLocation(),
                    const Tab4MyBag(),
                    const Tab5Profile(),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          bottomNavigationBar: BlocBuilder<MainPageBloc, MainPageState>(
            builder: (context, state) {
              if (state is MainPageBaseState) {
                return BottomNavigationBar(
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.grey.shade200,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: <BottomNavigationBarItem>[
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border_outlined),
                      label: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.location_on_outlined),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: _IconWithCounter(count: state.myBagListSet.length),
                      label: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.person_outlined),
                      label: '',
                    ),
                  ],
                  currentIndex: state.indexNavBar.toInt(),
                  selectedItemColor: Colors.pink,
                  onTap: (value) => _bloc(context).add(
                    OnBottomNavTap(NavBarIndexExt.fromInt(value)),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }
}

class _IconWithCounter extends StatelessWidget {
  final int count;

  const _IconWithCounter({required this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: 32,
      child: Stack(
        children: [
          if (count > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          const Positioned(
            bottom: 3,
            child: Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
    );
  }
}
