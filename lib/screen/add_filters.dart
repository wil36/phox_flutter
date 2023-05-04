import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phox_mizz_up/helpers.dart';
import 'package:phox_mizz_up/services/database_service.dart';

class AddFiltersScreen extends StatefulWidget {
  const AddFiltersScreen({super.key});

  @override
  State<AddFiltersScreen> createState() => _AddFiltersScreenState();
}

class _AddFiltersScreenState extends State<AddFiltersScreen> {
  String typeValue = "";
  String dateTime = DateTime.now().toString();
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool _isLoading = false;
  bool _showRadioError = false;
  final formKey = GlobalKey<FormState>();
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
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: ScreenUtil().screenWidth > 500
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    'Filter Name',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 17),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    controller: nameController,
                    autofocus: false,
                    style:
                        const TextStyle(fontSize: 15.0, color: Colors.black87),
                    decoration: inputDecorationComponent(
                        hintText: 'Enter filter name ...'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter filter name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Date Filter Changed',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 17),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: dateController,
                    readOnly: true,
                    style:
                        const TextStyle(fontSize: 15.0, color: Colors.black87),
                    decoration: inputDecorationComponent(
                      hintText:
                          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
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
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio(
                        value: 'Glass V2',
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          return Colors.white;
                        }),
                        groupValue: typeValue,
                        onChanged: (String? value) {
                          setState(() {
                            typeValue = value!;
                          });
                        },
                      ),
                      Text(
                        'Glass V2',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 17),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio(
                        value: 'The Wave',
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          return Colors.white;
                        }),
                        groupValue: typeValue,
                        onChanged: (String? value) {
                          setState(() {
                            typeValue = value!;
                          });
                        },
                      ),
                      Text(
                        'The Wave',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 17),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio(
                        value: 'Compatible',
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          return Colors.white;
                        }),
                        groupValue: typeValue,
                        onChanged: (String? value) {
                          setState(() {
                            typeValue = value!;
                          });
                        },
                      ),
                      Text(
                        'Compatible',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 17),
                      )
                    ],
                  ),
                  _showRadioError
                      ? const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            "Please select at least one of these options",
                            style: TextStyle(
                                fontSize: 13, color: Colors.redAccent),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 40.h,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          )
                        : elevatedButtonComponent(
                            context: context,
                            texte: "ADD FILTER",
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            textColor: Colors.white,
                            function: () {
                              saveFilter();
                            },
                          ),
                  )
                ],
              ),
            ),
          ),
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

  saveFilter() async {
    if (formKey.currentState!.validate() &&
        _isLoading == false &&
        typeValue.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _showRadioError = false;
      });
      Map<String, dynamic> filterData = {
        'name': nameController.text,
        "dateChange": dateController.text,
        "dateExpires": DateTime.parse(dateController.text)
            .add(const Duration(days: timeDurationOfFilter))
            .toString(),
        'type': typeValue,
      };

      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .savingFilter(filterData)
          .then((value) {
        if (value) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    } else {
      if (typeValue.isEmpty) {
        setState(() {
          _showRadioError = true;
        });
      }
    }
  }
}
