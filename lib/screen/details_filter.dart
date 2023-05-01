import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:phox_mizz_up/helpers.dart';
import 'package:phox_mizz_up/services/database_service.dart';

class DetailsFilterSccreen extends StatefulWidget {
  const DetailsFilterSccreen({super.key});

  @override
  State<DetailsFilterSccreen> createState() => _DetailsFilterSccreenState();
}

class _DetailsFilterSccreenState extends State<DetailsFilterSccreen> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      GlobalKey<AnimatedCircularChartState>();

  var box = Hive.box('Phox');
  Map<String, dynamic>? data = {};
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getdetailFilterOfUser(
            box.get("KEYDOCCURRENTFILTEROPEN", defaultValue: ""))
        .then((value) {
      // Get data from docs and convert map to List
      setState(() {
        if (value.exists) {
          data = value.data();
        }
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary, // <-- SEE HERE
        ),
        title: const Image(
          image: AssetImage('assets/logo.png'),
          width: 120,
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Text(
                      data?['name'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AnimatedCircularChart(
                    key: _chartKey,
                    size: Size(MediaQuery.of(context).size.width / 1.2,
                        MediaQuery.of(context).size.width / 1.2),
                    initialChartData: <CircularStackEntry>[
                      CircularStackEntry(
                        <CircularSegmentEntry>[
                          CircularSegmentEntry(
                            ((timeDurationOfFilter -
                                        (DateTime.parse(data?['dateExpires'] ??
                                                '${DateTime.now()}')
                                            .difference(DateTime.now())
                                            .inDays)) /
                                    timeDurationOfFilter) *
                                100,
                            Theme.of(context).colorScheme.secondary,
                            rankKey: 'completed',
                          ),
                          CircularSegmentEntry(
                            100 -
                                (((timeDurationOfFilter -
                                            (DateTime.parse(
                                                    data?['dateExpires'] ??
                                                        '${DateTime.now()}')
                                                .difference(DateTime.now())
                                                .inDays)) /
                                        timeDurationOfFilter) *
                                    100),
                            Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1),
                            rankKey: 'remaining',
                          ),
                        ],
                        rankKey: 'progress',
                      ),
                    ],
                    chartType: CircularChartType.Radial,
                    percentageValues: false,
                    holeLabel: (DateTime.parse(
                                    data?['dateExpires'] ?? '${DateTime.now()}')
                                .difference(DateTime.now())
                                .inDays) >
                            0
                        ? '${(DateTime.parse(data?['dateExpires'] ?? '${DateTime.now()}').difference(DateTime.now()).inDays)}\nDAYS LEFT'
                        : "0 DAYS LEFT\nIT'S TIME TO\nCHANGE YOUR\nFILTER!",
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.4,
                    child: elevatedButtonComponent(
                      context: context,
                      texte: "BUY REFILL",
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      textColor: Colors.white,
                      function: () {},
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                content: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "ARE YOU SURE YOU WANT TO RESET YOUR TIMER?",
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                DatabaseService().resetFilter(
                                                  box.get(
                                                      "KEYDOCCURRENTFILTEROPEN",
                                                      defaultValue: ""),
                                                  DateTime.now().toString(),
                                                  DateTime.parse(DateTime.now()
                                                          .toString())
                                                      .add(const Duration(
                                                          days:
                                                              timeDurationOfFilter))
                                                      .toString(),
                                                );
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor:
                                                    Colors.green.shade800,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3.0),
                                                    side: BorderSide(
                                                        color: Colors
                                                            .green.shade800)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.check),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor:
                                                    Colors.red.shade800,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3.0),
                                                    side: BorderSide(
                                                        color: Colors
                                                            .red.shade800)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: const [
                                                  Icon(Icons.close),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "No",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Text(
                        "RESET FILTER",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
