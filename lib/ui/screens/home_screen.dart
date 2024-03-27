import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:sarafy/data/model/crypto_model/crypto_data.dart';
import 'package:sarafy/provider/crypto_data_provider.dart';
import 'package:sarafy/provider/state_data.dart';
import 'package:sarafy/ui/ui_helper/Theme_switcher.dart';
import 'package:sarafy/ui/ui_helper/banner.dart';
import 'package:sarafy/util/decimal_rounder.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final PageController pageViewController = PageController(
      initialPage: 0,
    );
    final cryptoProvider = Provider.of<CryptoDataProvider>(context);

    var height = MediaQuery.of(context).size.height;

    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        backgroundColor: Theme.of(context).primaryColor,
        actions: const [
          ThemeSwitcher(),
        ],
        title: const Text('ExchangeBs'),
        titleTextStyle: textTheme.titleLarge,
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            getBanner(pageViewController: pageViewController),
            const SizedBox(height: 10),
            getNews(textTheme: textTheme),
            const SizedBox(height: 10),
            Buttons(textTheme: textTheme),
            const SizedBox(height: 10),
            choicelist(textTheme: textTheme),
            const SizedBox(height: 10),
            ShowData(height: height, textTheme: textTheme),
          ],
        ),
      ),
    );
  }
}

class ShowData extends StatelessWidget {
  const ShowData({
    super.key,
    required this.height,
    required this.textTheme,
  });

  final double height;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Consumer<CryptoDataProvider>(
          builder: (context, cryptoDataProvider, child) {
        switch (cryptoDataProvider.state.status) {
          case Status.LOADING:
            return SizedBox(
              height: 80,
              child: Shimmer.fromColors(
                  child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsets.only(top: 8.0, bottom: 8, left: 8),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: Icon(Icons.add),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8.0, left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 15,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        width: 25,
                                        height: 15,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: SizedBox(
                                width: 70,
                                height: 40,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 15,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        width: 25,
                                        height: 15,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  baseColor: Colors.grey.shade400,
                  highlightColor: Colors.white),
            );
          case Status.COMPLETED:
            List<CryptoData>? model =
                cryptoDataProvider.dataFuture.data!.cryptoCurrencyList;

            // print(model![0].symbol);
            return ListView.separated(
                itemBuilder: (context, index) {
                  var number = index + 1;
                  var tokenId = model![index].id;

                  MaterialColor filterColor = DecimalRounder.setColorFilter(
                      model[index].quotes![0].percentChange24h);

                  var finalPrice = DecimalRounder.removePriceDecimals(
                      model[index].quotes![0].price);

                  // percent change setup decimals and colors
                  var percentChange = DecimalRounder.removePercentDecimals(
                      model[index].quotes![0].percentChange24h);

                  Color percentColor = DecimalRounder.setPercentChangesColor(
                      model[index].quotes![0].percentChange24h);
                  Icon percentIcon = DecimalRounder.setPercentChangesIcon(
                      model[index].quotes![0].percentChange24h);

                  return SizedBox(
                    height: height * 0.075,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            number.toString(),
                            style: textTheme.bodySmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 15),
                          child: CachedNetworkImage(
                              fadeInDuration: const Duration(milliseconds: 500),
                              height: 32,
                              width: 32,
                              imageUrl:
                                  "https://s2.coinmarketcap.com/static/img/coins/32x32/$tokenId.png",
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) {
                                return const Icon(Icons.error);
                              }),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model[index].name!,
                                style: textTheme.bodySmall,
                              ),
                              Text(
                                model[index].symbol!,
                                style: textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  filterColor, BlendMode.srcATop),
                              child: SvgPicture.network(
                                  "https://s3.coinmarketcap.com/generated/sparklines/web/1d/2781/$tokenId.svg")),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$$finalPrice",
                                  style: textTheme.bodySmall,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    percentIcon,
                                    Text(
                                      percentChange + "%",
                                      style: GoogleFonts.ubuntu(
                                          color: percentColor, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: 10);
          case Status.ERROR:
            return Text(cryptoDataProvider.state.message);
          default:
            return Container();
        }
      }),
    );
  }
}

class choicelist extends StatefulWidget {
  const choicelist({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;
  @override
  State<choicelist> createState() => _choicelistState();
}

class _choicelistState extends State<choicelist> {
  final List<String> _choicesList = [
    'Top MarketCaps',
    'Top Gainers',
    'Top Losers'
  ];
  var defaultChoiceIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Consumer<CryptoDataProvider>(
            builder: (context, cryptoDataProvider, child) {
              return Wrap(
                spacing: 8,
                children: List.generate(
                  _choicesList.length,
                  (index) {
                    return ChoiceChip(
                      label: Text(_choicesList[index],
                          style: widget.textTheme.titleSmall),
                      selected: cryptoDataProvider.defaultChoiceIndex == index,
                      selectedColor: Colors.blue,
                      onSelected: (value) {
                        switch (index) {
                          case 0:
                            cryptoDataProvider.getTopMarketCapData();
                            break;
                          case 1:
                            cryptoDataProvider.getTopGainersData();
                            break;
                          case 2:
                            cryptoDataProvider.getTopLosersData();
                            break;
                        }
                      },
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  const Buttons({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(18),
                  primary: Colors.green[700]),
              child: const Text(
                "buy",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(18),
                  primary: Colors.red[700]),
              child: const Text(
                "sell",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class getNews extends StatelessWidget {
  const getNews({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: double.infinity,
      child: Marquee(
        text: '🔊  this is place for news in application     ',
        style: textTheme.bodySmall,
      ),
    );
  }
}

class getBanner extends StatelessWidget {
  const getBanner({
    super.key,
    required this.pageViewController,
  });

  final PageController pageViewController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        children: [
          HomeBanner(controller: pageViewController),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: SmoothPageIndicator(
                controller: pageViewController,
                count: 4,
                effect: const ExpandingDotsEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor: Colors.white,
                ),
                onDotClicked: (index) => pageViewController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
