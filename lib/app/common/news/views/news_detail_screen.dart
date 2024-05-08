part of '../index.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({Key? key, required this.newsId}) : super(key: key);
  static const id = "NewsDetailScreen";
  final String newsId;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final _key = GlobalKey<ScaffoldState>();
  late Future<News> newsDetailFuture;

  AppBar _buildAppbar() => AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        centerTitle: true,
        leading: const YrBackButton(),
        title: Text(
          "Tin tức",
          style: kText28_Light,
        ),
        actions: const [
          NotificationButton(),
        ],
      );

  @override
  void initState() {
    super.initState();
    newsDetailFuture = APIServices().getNewsDetail(newsId: widget.newsId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: yrColorPrimary,
      drawer: const Menu(),
      drawerEnableOpenDragGesture: false,
      appBar: _buildAppbar(),
      body: FutureBuilder<News>(
        future: newsDetailFuture,
        builder: (context, data) {
          switch (data.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (data.hasData) {
                return _HtmlView(
                  data: data.data!,
                );
              } else {
                return const Text("Error");
              }
            default:
              return const Text("Error");
          }
        },
      ),
    );
  }
}

class _HtmlView extends StatelessWidget {
  const _HtmlView({
    Key? key,
    required this.data,
  }) : super(key: key);
  final News data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Html(
        data: data.vi.content,
        shrinkWrap: true,
        style: {
          "html": Style(
            color: yrColorLight,
            fontSize: FontSize.large,
          ),
        },
        onLinkTap: (link, ___, _, __) {
          Utils.launchUrl(context, link ?? "");
        },
        onImageTap: (url, rContext, __, ___) {
          if (url != null) {
            openPhotoViewer(rContext.buildContext,
                index: 0, imagePaths: [url], viewOnly: true, useCached: false);
          }
        },
        customRenders: {
          tagMatcher("div"):
              CustomRender.widget(widget: (rContext, defaultWidget) {
            const empty = SizedBox.shrink();
            switch (rContext.tree.attributes["class"]) {
              case "knc-menu-nav":
              case "clearall":
              case "react-relate animated":
                return empty;
            }
            if (rContext.tree.attributes["data-check-position"] ==
                "body_start") {
              return empty;
            }
            switch (rContext.tree.attributes["id"]) {
              case "urlSourceCafeF":
                return empty;
            }

            return RichText(
              text: TextSpan(children: defaultWidget()),
            );
          }),
          tagMatcher("img"):
              CustomRender.widget(widget: (rContext, defaultWidget) {
            final link = rContext.tree.attributes["src"];
            if (link != null) {
              return getImage(
                link,
                borderRadius: BorderRadius.circular(20),
                height: 240.h,
                fit: BoxFit.cover,
                onTap: () {
                  openPhotoViewer(
                    rContext.buildContext,
                    index: 0,
                    imagePaths: [link],
                    viewOnly: true,
                    useCached: false,
                  );
                },
              );
            }
            return const SizedBox();
          })
        },
      ),
    );
  }
}
