part of '../index.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  static const id = "NewsScreen";

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    cubit = context.read<NewsCubit>();
  }

  late NewsCubit cubit;
  AppBar _buildAppbar() => AppBar(
        backgroundColor: yrColorPrimary,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            _key.currentState!.openDrawer();
          },
          child: Icon(
            Icons.menu,
            color: yrColorLight,
            size: 38.w,
          ),
        ),
        title: Text(
          "Tin tức",
          style: kText28_Light,
        ),
        actions: const [
          NotificationButton(),
        ],
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: yrColorPrimary,
      drawer: const Menu(),
      drawerEnableOpenDragGesture: false,
      appBar: _buildAppbar(),
      body: RefreshIndicator(
        onRefresh: () async => cubit.onRefresh(),
        child: Scrollbar(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const HotNewsWidget(),
                const OtherNewsWidget(),
                50.verSp.toSliver(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
