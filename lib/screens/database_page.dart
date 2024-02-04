import 'package:flutter/material.dart';
import 'package:hushh_proto/screens/home.dart';
import 'package:hushh_proto/screens/widgets/colors.dart';
import 'package:hushh_proto/screens/widgets/dataset.dart';
import 'package:hushh_proto/screens/widgets/dropdown.dart';
import 'package:hushh_proto/screens/widgets/textfield.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  //Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  List dailyController = [];
  List partyController = [];
  List formalsController = [];

  //Lists
  List dailyWear = [];
  List formalsWear = [];
  List partyWear = [];

  //Variables
  String userGender = gender[0];

  fetchData() {
    _nameController.text = database['name'];
    _ageController.text = database['age'];
    dailyWear = database['daily'];
    formalsWear = database['formals'];
    partyWear = database['party'];
    userGender = database['gender'];

    //generate controllers for each
    dailyController = List.generate(dailyWear.length,
        (index) => TextEditingController(text: dailyWear[index]));
    partyController = List.generate(partyWear.length,
        (index) => TextEditingController(text: partyWear[index]));
    formalsController = List.generate(formalsWear.length,
        (index) => TextEditingController(text: formalsWear[index]));
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightMode ? Pallet.white : Pallet.black,
      appBar: AppBar(
        backgroundColor: lightMode ? Pallet.white : Pallet.black,
        iconTheme: IconThemeData(
          color: lightMode ? Pallet.black : Pallet.white,
        ),
        title: Text(
          'Database',
          style: TextStyle(
            color: lightMode ? Pallet.black : Pallet.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              customTextField(
                context,
                'Name',
                _nameController,
                lightMode ? Pallet.black : Pallet.white,
              ),
              const SizedBox(height: 10),
              customTextField(
                context,
                'Age',
                _ageController,
                lightMode ? Pallet.black : Pallet.white,
              ),
              const SizedBox(height: 10),
              customDropDown(context, lightMode, userGender, (value) {
                setState(() {
                  userGender = value!;
                  database['gender'] = value;
                });
              }, gender, 'Gender'),
              const SizedBox(height: 5),

              //Daily Wear
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Wear',
                      style: TextStyle(
                        color: lightMode ? Pallet.black : Pallet.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dailyWear.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTextField2(
                              context,
                              dailyController[index],
                              lightMode ? Pallet.black : Pallet.white,
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              //Party wear
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Party Wear',
                      style: TextStyle(
                        color: lightMode ? Pallet.black : Pallet.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: partyWear.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTextField2(
                              context,
                              partyController[index],
                              lightMode ? Pallet.black : Pallet.white,
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              //Formals
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Formal Wear',
                      style: TextStyle(
                        color: lightMode ? Pallet.black : Pallet.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: formalsWear.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTextField2(
                              context,
                              formalsController[index],
                              lightMode ? Pallet.black : Pallet.white,
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
