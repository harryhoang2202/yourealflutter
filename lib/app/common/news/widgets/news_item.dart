part of '../index.dart';

class NewsItem extends StatefulWidget {
  final News news;

  const NewsItem({Key? key, required this.news}) : super(key: key);

  static void showPopup(BuildContext context, {required News item}) {
    showModalBottomSheet(
        useRootNavigator: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.w),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        builder: (BuildContext context) => NewsPopup(
              item: item,
            ),
        context: context);
  }

  @override
  _NewsItemState createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed(NewsDetailScreen.id, arguments: widget.news.id);
      },
      child: Container(
        height: 150.h,
        width: screenWidth,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
            color: yrColorLight, borderRadius: BorderRadius.circular(8.w)),
        child: Row(
          children: [
            getImage(
              widget.news.thumbnail.filename,
              fit: BoxFit.fill,
              width: 142.w,
              height: 134.h,
              borderRadius: BorderRadius.circular(8),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bất động sản",
                    style: kText14Weight400_Accent,
                  ),
                  8.verSp,
                  Expanded(
                    child: Text(
                      widget.news.vi.title,
                      style: kText14_Dark,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.news.getCreatedDate(),
                        style: kText14Weight400_Hint,
                      ),
                      SizedBox.fromSize(
                        size: Size(32.w, 32.w),
                        child: Material(
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              NewsItem.showPopup(context, item: widget.news);
                            },
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/menu-dots-vertical.svg",
                                height: 16.h,
                                color: yrColorHint,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
