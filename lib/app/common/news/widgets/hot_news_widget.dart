part of '../index.dart';

class HotNewsWidget extends StatefulWidget {
  const HotNewsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<HotNewsWidget> createState() => _HotNewsWidgetState();
}

class _HotNewsWidgetState extends State<HotNewsWidget> {
  int _currentIndex = 0;
  final carouselItemHeight = 280.h;
  final indicatorHeight = 8.w;
  final paddingBottom = 24.h;

  double get widgetHeight =>
      carouselItemHeight + indicatorHeight + paddingBottom;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        return SliverPersistentHeader(
            delegate: SliverPersistentHeaderCustomDelegate(
          minHeight: 0,
          maxHeight: widgetHeight,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: state.isLoading
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: carouselItemHeight,
                          child: CarouselSlider(
                            items: state.hotNews
                                .map((e) => NewsCarouselItem(item: e))
                                .toList(),
                            options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                }),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: state.hotNews.map((url) {
                            int index = state.hotNews.indexOf(url);
                            return Container(
                              width: indicatorHeight,
                              height: indicatorHeight,
                              margin: EdgeInsets.symmetric(horizontal: 2.0.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? yrColorSecondary
                                    : yrColorLight,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
          ),
        ));
      },
    );
  }
}

class NewsCarouselItem extends StatelessWidget {
  const NewsCarouselItem({Key? key, required this.item}) : super(key: key);
  final News item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: true)
          .pushNamed(NewsDetailScreen.id, arguments: item.id),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          getImage(
            item.thumbnail.filename,
            fit: BoxFit.cover,
            width: 1.sw,
            height: 280.h,
            borderRadius: BorderRadius.circular(15),
          ),
          Container(
            height: 90.h,
            width: 1.sw,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: yrColorLight,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15.r),
                bottomLeft: Radius.circular(15.r),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Bất động sản",
                          style: kText14Weight400_Accent,
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        Text(
                          item.getCreatedDate(),
                          style: kText14Weight400_Dark,
                        ),
                      ],
                    ),
                    Material(
                      color: yrColorLight,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () => NewsItem.showPopup(context, item: item),
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: SvgPicture.asset(
                            "assets/icons/menu-dots-vertical.svg",
                            color: yrColorHint,
                            height: 14.h,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Flexible(
                  child: Text(
                    item.vi.title,
                    style: kText18_Primary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
