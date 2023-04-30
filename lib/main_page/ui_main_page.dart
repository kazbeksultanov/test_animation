import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_animation/main_page/bloc/main_page_bloc.dart';
import 'package:test_animation/tabs/tab1_discover.dart';
import 'package:test_animation/tabs/tab2_favourite.dart';
import 'package:test_animation/tabs/tab3_my_location.dart';
import 'package:test_animation/tabs/tab4_my_bag.dart';
import 'package:test_animation/tabs/tab5_profile.dart';

MainPageBloc _bloc(BuildContext context) => BlocProvider.of(context);

class DiscoverPageProvider extends StatelessWidget {
  const DiscoverPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainPageBloc(),
      child: const DiscoverPage(),
    );
  }
}

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.grey.shade300),
        ClipPath(
          clipper: _CircularClipper(),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocBuilder<MainPageBloc, MainPageState>(
            builder: (context, state) {
              if (state is MainPageInitial) {
                return IndexedStack(
                  index: state.indexNavBar,
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
              if (state is MainPageInitial) {
                return BottomNavigationBar(
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border_outlined),
                      label: 'Business',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.location_on_outlined),
                      label: 'School',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart_outlined),
                      label: 'School',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outlined),
                      label: 'School',
                    ),
                  ],
                  currentIndex: state.indexNavBar,
                  selectedItemColor: Colors.pink,
                  onTap: (value) => _bloc(context).add(OnBottomNavTap(value)),
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

class _CircularClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    const h = 200;
    var path = Path();
    path.lineTo(0, height - h);
    path.quadraticBezierTo(width / 2, height - 100, width, height - h);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
