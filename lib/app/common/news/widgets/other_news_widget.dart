part of '../index.dart';

class OtherNewsWidget extends StatelessWidget {
  const OtherNewsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewsCubit>();
    return MultiSliver(
      children: [
        SliverPinnedHeader(
          child: Container(
            color: yrColorPrimary,
            child: Text(
              "Các tin tức khác",
              style: kText18_Light,
            ),
          ),
        ),
        8.verSp.toSliver(),
        PagedSliverList.separated(
          pagingController: cubit.pagingController,
          builderDelegate: PagedChildBuilderDelegate<News>(
            itemBuilder: (context, item, index) => NewsItem(news: item),
            firstPageErrorIndicatorBuilder: (context) {
              return LazyListError(
                onTap: () {
                  cubit.onRefresh();
                },
              );
            },
            newPageErrorIndicatorBuilder: (context) {
              return LazyListError(
                onTap: () {
                  cubit.pagingController.retryLastFailedRequest();
                },
              );
            },
            noItemsFoundIndicatorBuilder: (context) {
              return Center(
                child: Text(
                  "Hiện chưa có tin tức mới,\nvui lòng thử lại sau.",
                  style: kText14_Light,
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          separatorBuilder: (_, __) => SizedBox(
            height: 8.h,
          ),
        ),
      ],
    );
  }
}
