import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  String dateTime = DateTime.now().toString();
  TextEditingController dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var box = Hive.box('Phox');
  Map<String, dynamic>? data = {};
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    dateController.text =
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
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
        title: Image(
          image: const AssetImage('assets/logo.png'),
          width: 120.w,
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
                  SizedBox(
                    height: 40.h,
                  ),
                  Center(
                    child: Text(
                      data?['name'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  AnimatedCircularChart(
                    key: _chartKey,
                    size: Size(
                      ScreenUtil().screenWidth > 500
                          ? MediaQuery.of(context).size.width / 4
                          : MediaQuery.of(context).size.width / 1.2,
                      ScreenUtil().screenWidth > 500
                          ? MediaQuery.of(context).size.width / 4
                          : MediaQuery.of(context).size.width / 1.2,
                    ),
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
                      fontSize: 24.0.sp,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
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
                      height: ScreenUtil().screenWidth > 500 ? 20.h : 10.h),
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
                                      MediaQuery.of(context).size.height / 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "ARE YOU SURE YOU WANT TO RESET YOUR TIMER?",
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Text(
                                        'New Date Filter Changed',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 17),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Form(
                                        key: formKey,
                                        child: TextFormField(
                                          autofocus: false,
                                          controller: dateController,
                                          readOnly: true,
                                          style: const TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            hintText: 'Thrusday, May 4th, 2019',
                                            hintStyle: const TextStyle(
                                                color: Colors.white),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 14.0,
                                                    bottom: 8.0,
                                                    top: 8.0),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                              borderRadius:
                                                  BorderRadius.circular(25.7),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                              borderRadius:
                                                  BorderRadius.circular(25.7),
                                            ),
                                          ),
                                          onTap: () {
                                            _selectDate();
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter the date filter changed';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.h,
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
                                                  dateController.text,
                                                  DateTime.parse(
                                                          dateController.text)
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
                                                children: [
                                                  const Icon(Icons.check),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  const Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
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
                                                children: [
                                                  const Icon(Icons.close),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  const Text(
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
                  SizedBox(
                      height: ScreenUtil().screenWidth > 500 ? 20.h : 10.h),
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
                                        "ARE YOU SURE YOU WANT TO DELETE YOUR TIMER?",
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 20.h,
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
                                                DatabaseService().deleteFilter(
                                                    box.get(
                                                        "KEYDOCCURRENTFILTEROPEN",
                                                        defaultValue: ""));
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
                                                children: [
                                                  const Icon(Icons.check),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  const Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
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
                                                children: [
                                                  const Icon(Icons.close),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  const Text(
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
                        "DELETE FILTER",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(dateTime),
      firstDate: DateTime(2021),
      lastDate: DateTime(2099),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary, // <-- SEE HERE
              onPrimary:
                  Theme.of(context).colorScheme.secondary, // <-- SEE HERE
              onSurface: Colors.black87, // <-- SEE HERE
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dateController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }
}
