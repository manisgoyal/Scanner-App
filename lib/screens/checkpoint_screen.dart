import 'package:animated_background/animated_background.dart';
import 'package:scanner_app/fooderlich_theme.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import '../components/checkpoint.dart';
import '../api.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/checkpoint_name.dart';

class CheckPointScreen extends StatefulWidget {
  const CheckPointScreen({Key? key}) : super(key: key);

  @override
  State<CheckPointScreen> createState() => _CheckPointScreenState();
}

class _CheckPointScreenState extends State<CheckPointScreen>
    with SingleTickerProviderStateMixin {
  final nameController = TextEditingController();

  String qrCodeResult = "";
  String getStored() {
    return context.read<CheckPointProvider>().checkId;
  }

  ParticleOptions particles = const ParticleOptions(
    baseColor: Color.fromARGB(255, 0, 13, 110),
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.1,
    maxOpacity: 0.4,
    particleCount: 70,
    spawnMaxRadius: 15.0,
    spawnMaxSpeed: 100.0,
    spawnMinSpeed: 30,
    spawnMinRadius: 7.0,
  );

  @override
  Widget build(BuildContext context) {
    String code = getStored();
    return Scaffold(
      appBar: AppBar(
        title: const Text("MPL By SIAM VIT"),
      ),
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particles),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                customCard(Column(
                  children: [
                    Image.asset('assets/images/logo.png'),
                    getStored() != ""
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width / 0.75,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Your Stall Code is '$code'.",
                                    style: FooderlichTheme
                                        .darkTextTheme.headline2),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                )),
                customCard(
                  Column(
                    children: [
                      Text('Enter your Stall\'s Code',
                          style: FooderlichTheme.darkTextTheme.headline2),
                      CheckPointCode(nameController: nameController),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 213, 73),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 255, 213, 73)),
                            // elevation: MaterialStateProperty.all(3),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: () {
                            CheckPointProvider checkPointProvider =
                                Provider.of<CheckPointProvider>(context,
                                    listen: false);
                            checkPointProvider.changeId(nameController.text);
                            setState(() {});
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                                maxWidth: 250.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: const Text(
                              "Update Stall Code",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                customCard(
                  Container(
                    constraints:
                        const BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //Message displayed over here
                        const Text(
                          "Press the Button to Scan",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                  blurRadius: 5.0)
                            ],
                          ),
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 255, 213, 73)),
                              // elevation: MaterialStateProperty.all(3),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),

                            onPressed: () async {
                              var codeSanner =
                                  await BarcodeScanner.scan(); //barcode scanner
                              qrCodeResult = codeSanner.rawContent;
                              String track = await ApiConnector.getCheckpoint(
                                  id: qrCodeResult);
                              if (qrCodeResult != "" && track != "") {
                                if (track == getStored()) {
                                  await ApiConnector.incCheckpoint(
                                      id: qrCodeResult);
                                  AudioPlayer audio = AudioPlayer();
                                  AssetSource sc =
                                      AssetSource('audio/success.mp3');
                                  audio.play(sc);
                                } else {
                                  await ApiConnector.incPenalty(
                                      id: qrCodeResult);
                                  AudioPlayer audio = AudioPlayer();
                                  AssetSource sc =
                                      AssetSource('audio/buzzer.mp3');
                                  audio.play(sc);
                                }
                              }
                            },
                            label: const Text(
                              "Open Scanner",
                            ),
                            icon: const Icon(Icons.qr_code),
                            //Button having rounded rectangle border
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget customCard(Widget child) {
  return Card(
    elevation: 8.0,
    color: const Color.fromARGB(196, 58, 58, 58),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      padding: const EdgeInsets.all(15),
      child: child,
    ),
  );
}
