import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_animation/common/widgets/image_png_with_shadow.dart';
import 'package:test_animation/pages/main_page/bloc/main_page_bloc.dart';
import 'package:test_animation/pages/main_page/m_main_page.dart';

const smallImages = <String>[];

MainPageBloc _bloc(BuildContext context) => BlocProvider.of(context);

class DetailPage extends StatelessWidget {
  final CardItemData data;

  const DetailPage(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final hBackground = MediaQuery.of(context).size.height / 2.8;
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: hBackground + 60),
                      _SmallPictureCarousel(
                        assetUrls: [
                          for (int i = 0; i < 5; i++) data.assetUrl,
                        ],
                      ),
                      const Divider(indent: 16, endIndent: 16, color: Colors.grey),
                      const SizedBox(height: 22),
                      _InfoSection(data),
                      const SizedBox(height: 26),
                      _SizeSection(data),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                _AddToBagButton(data),
              ],
            ),
          ),
          Positioned(
            top: -hBackground / 1.6,
            left: -5,
            child: Hero(
              tag: data.tagBox,
              child: Container(
                height: hBackground * 1.8,
                width: hBackground * 1.8,
                decoration: BoxDecoration(
                  color: data.color,
                  borderRadius: BorderRadius.all(Radius.circular(hBackground * 1.8)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 2,
                      blurRadius: 10,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: hBackground / 6,
            left: 16,
            right: 16,
            child: ImagePngWithShadow(
              assetUrl: data.assetUrl,
              tag: data.tagImage,
              degree: 12,
            ),
          ),
          SizedBox(
            height: 80,
            child: AppBar(
              leading: const BackButton(color: Colors.white),
              actions: [
                _FavoriteButton(
                  onTap: () => debugPrint('onTap $runtimeType favorite'),
                  color: data.color,
                ),
              ],
              elevation: 0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
              ),
              title: Text(data.brandName),
              centerTitle: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddToBagButton extends StatelessWidget {
  final CardItemData data;

  const _AddToBagButton(this.data);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageBloc, MainPageState>(
      builder: (context, state) {
        if (state is MainPageBaseState) {
          final isAddedToBag =
              state.myBagListSet.where((e) => e.cardItemData.tagBox == data.tagBox).isNotEmpty;
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Material(
              color: isAddedToBag ? Colors.grey : Colors.pink,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                onTap: () {
                  if (!isAddedToBag) {
                    _bloc(context).add(OnAddToMyBagTap(data));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          isAddedToBag ? 'Added' : 'ADD TO BAG',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _SizeSection extends StatefulWidget {
  final CardItemData data;

  const _SizeSection(this.data);

  @override
  State<_SizeSection> createState() => _SizeSectionState();
}

class _SizeSectionState extends State<_SizeSection> {
  int? selectedSizeTab;

  @override
  Widget build(BuildContext context) {
    final styleTitle =
        Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600);
    final styleText = Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(fontWeight: FontWeight.w800, color: Colors.black);

    const List<String> sizes = ['Try it', '7.5', '8', '8,5', '9'];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text('Size', style: styleTitle),
              const Spacer(),
              Text('UK', style: styleText),
              const SizedBox(width: 16),
              Text('USA', style: styleText?.copyWith(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sizes.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, index) {
              final isSelected = selectedSizeTab == index;
              return InkWell(
                onTap: () {
                  selectedSizeTab = index;
                  setState(() {});
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: AnimatedContainer(
                  height: 40,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black87 : Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        sizes[index],
                        style: styleText?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      if (index == 0)
                        Icon(
                          Icons.qr_code_scanner,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 8),
          ),
        ),
      ],
    );
  }
}

class _InfoSection extends StatefulWidget {
  final CardItemData data;

  const _InfoSection(this.data);

  @override
  State<_InfoSection> createState() => _InfoSectionState();
}

class _InfoSectionState extends State<_InfoSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final styleTitle =
        Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600);
    final styleText = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(fontWeight: FontWeight.w400, color: Colors.grey);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(widget.data.model, style: styleTitle),
              const Spacer(),
              Text('\$${widget.data.cost}', style: styleTitle),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSize(
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.topCenter,
            child: Text(
              widget.data.shortInfo * 3,
              style: styleText,
              maxLines: isExpanded ? 50 : 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              isExpanded = !isExpanded;
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 2),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
              child: Text(
                isExpanded ? 'LESS DETAILS' : 'MORE DETAILS',
                style: styleText?.copyWith(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SmallPictureCarousel extends StatelessWidget {
  final List<String> assetUrls;

  const _SmallPictureCarousel({
    required this.assetUrls,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: assetUrls.length,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) {
          final isLast = assetUrls.length - 1 == index;

          return AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(assetUrls[index]),
                  ),
                  if (isLast)
                    Center(
                      child: Icon(
                        Icons.play_circle,
                        size: 48,
                        color: Colors.grey.shade100,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onTap;

  const _FavoriteButton({
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(Icons.favorite_border_outlined),
      ),
    );
  }
}
