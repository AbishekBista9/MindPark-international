import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindgames/cloud_store_service.dart';
import 'package:mindgames/controllers/language_controller.dart';
import 'package:mindgames/services/auth_service.dart';
import 'package:mindgames/widgets/snackbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settingspage extends StatefulWidget {
  const Settingspage({Key? key}) : super(key: key);

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> {
  bool _soundEnabled = true;
  bool _parentalLockEnabled = true;
  bool _vibrationEnabled = true;
  bool _hasChanges = false; // Track if changes have been made
  final LocalizationController _localizationController =
      Get.find<LocalizationController>();
  late SharedPreferences _prefs;
  final currentUser = AuthService.user;
  CloudStoreService cloudStoreService = CloudStoreService();

  @override
  void initState() {
    _loadPreferences();
    super.initState();
  }

  bool getSoundSetting() {
    return _soundEnabled;
  }

  Future<void> saveSoundSetting(bool value) async {
    _soundEnabled = value;
    await _prefs.setBool('sound_enabled', _soundEnabled);
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundEnabled = _prefs.getBool('sound_enabled') ?? true;
      _parentalLockEnabled = _prefs.getBool('parental_lock_enabled') ?? true;
      _vibrationEnabled = _prefs.getBool('vibration_enabled') ?? true;
      int selectedIndex = _prefs.getInt('language_index') ?? 0;
      _localizationController.setSelectIndex(selectedIndex);
      _localizationController.setLanguage(
        Locale(
          _localizationController.languages[selectedIndex].languageCode,
          _localizationController.languages[selectedIndex].countryCode,
        ),
      );
      print('Loaded language index: $selectedIndex'); // Debugging line
    });
  }

  Future<void> _showPinVerificationDialog() async {
    final TextEditingController _pinController = TextEditingController();
    double screenWidth = MediaQuery.of(context).size.width;

    Future<bool> checkPIN() async {
      try {
        bool isValid = await cloudStoreService.verifyPIN(
            currentUser!.uid, _pinController.text);
        return isValid;
      } catch (e) {
        print(e);
        return false;
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter PIN to disable parental lock'.tr,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: const Color(0xFF309092),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            cursorColor: const Color(0xFF309092),
            style: TextStyle(fontSize: screenWidth * 0.05),
            controller: _pinController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'PIN'.tr,
              counterStyle: TextStyle(
                  fontSize: screenWidth * 0.03, color: const Color(0xFF309092)),
              labelStyle: TextStyle(
                  fontSize: screenWidth * 0.03, color: const Color(0xFF309092)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Color(0xFF309092)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Color(0xFF309092)),
              ),
            ),
            obscureText: true,
            maxLength: 4,
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF309092)),
                      onPressed: () async {
                        if (await checkPIN()) {
                          setState(() {
                            _parentalLockEnabled = false;
                            _hasChanges = true;
                          });
                          Navigator.of(context).pop();
                        } else {
                          showCustomSnackbar(
                              context, 'Error'.tr, 'Incorrect PIN'.tr);
                        }
                      },
                      child: Text('Submit'.tr,
                          style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          ],
        );
      },
    );
  }

  void _applyChanges() async {
    // Save settings to SharedPreferences
    await _prefs.setBool('sound_enabled', _soundEnabled);
    await _prefs.setBool('parental_lock_enabled', _parentalLockEnabled);
    await _prefs.setBool('vibration_enabled', _vibrationEnabled);
    await _prefs.setInt(
        'language_index', _localizationController.selectedIndex);
    setState(() {
      _hasChanges = false;
    });
  }

  void _resetSettings() {
    // Reset settings to default positions
    setState(() {
      _soundEnabled = true;
      _parentalLockEnabled = true;
      _vibrationEnabled = true;
      _localizationController.setSelectIndex(0);
      _localizationController.setLanguage(
        Locale(
          _localizationController.languages[0].languageCode,
          _localizationController.languages[0].countryCode,
        ),
      );
      _hasChanges = true;
    });
  }

  void _onSettingChanged() {
    setState(() {
      _hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/levelscreen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: screenWidth * 0.1),
              Column(
                children: [
                  Text(
                    "Settings".tr,
                    style: TextStyle(
                        color: Color(0xFF309092),
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: screenWidth * 0.045,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Customize your app to fit your needs".tr,
                      style: TextStyle(
                          color: Color(0xFF309092),
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenWidth * 0.05,
              ),
              Divider(
                color: Color.fromARGB(255, 107, 107, 107),
                height: 20,
                thickness: 1,
                indent: 18,
                endIndent: 20,
              ),
              SizedBox(
                height: screenWidth * 0.7,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: ListView(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      children: [
                        ListTile(
                          title: Text(
                            'Sound'.tr,
                            style: TextStyle(
                              color: Color(0xFF309092),
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Transform.scale(
                            scale: screenWidth * 0.0025,
                            child: Switch(
                              value: _soundEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  _soundEnabled = value;
                                  _onSettingChanged();
                                });
                              },
                              activeColor: Color(0xFF309092),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Vibration'.tr,
                            style: TextStyle(
                              color: Color(0xFF309092),
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Transform.scale(
                            scale: screenWidth * 0.0025,
                            child: Switch(
                              value: _vibrationEnabled,
                              onChanged: (bool value) {
                                setState(() {
                                  _vibrationEnabled = value;
                                  _onSettingChanged();
                                });
                              },
                              activeColor: Color(0xFF309092),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Parental Lock'.tr,
                            style: TextStyle(
                                color: Color(0xFF309092),
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Transform.scale(
                            scale: screenWidth * 0.0025,
                            child: Switch(
                              value: _parentalLockEnabled,
                              onChanged: (bool value) {
                                if (!value) {
                                  // If trying to disable parental lock, show PIN verification
                                  _showPinVerificationDialog();
                                } else {
                                  setState(() {
                                    _parentalLockEnabled = value;
                                    _onSettingChanged();
                                  });
                                }
                              },
                              activeColor: Color(0xFF309092),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Language'.tr,
                                style: TextStyle(
                                    color: Color(0xFF309092),
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold),
                              ),
                              GetBuilder<LocalizationController>(
                                builder: (localizationController) {
                                  String selectedLanguage =
                                      localizationController
                                          .languages[localizationController
                                              .selectedIndex]
                                          .languageName;

                                  print(
                                      'Selected language: $selectedLanguage'); // Debugging line

                                  return SizedBox(
                                    width: screenWidth * 0.35,
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFF309092),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xFF309092),
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                      value: selectedLanguage,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: screenWidth * 0.05,
                                      elevation: 16,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenWidth * 0.05,
                                          fontFamily: 'ShantellSans'),
                                      onChanged: (String? newValue) {
                                        int index = localizationController
                                            .languages
                                            .indexWhere((lang) =>
                                                lang.languageName == newValue);
                                        if (index != -1) {
                                          localizationController.setLanguage(
                                            Locale(
                                              localizationController
                                                  .languages[index]
                                                  .languageCode,
                                              localizationController
                                                  .languages[index].countryCode,
                                            ),
                                          );
                                          localizationController
                                              .setSelectIndex(index);
                                          _onSettingChanged();
                                          setState(() {});
                                        }
                                      },
                                      items: localizationController.languages
                                          .map<DropdownMenuItem<String>>(
                                              (language) {
                                        return DropdownMenuItem<String>(
                                          value: language.languageName,
                                          child: Text(language.languageName,
                                              style: TextStyle(
                                                  fontSize:
                                                      screenWidth * 0.04)),
                                        );
                                      }).toList(),
                                      itemHeight: 90,
                                    ),
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
              ),
              Divider(
                color: Color.fromARGB(255, 107, 107, 107),
                height: 20,
                thickness: 1,
                indent: 18,
                endIndent: 20,
              ),
              SizedBox(
                height: screenWidth * 0.025,
              ),
              if (_hasChanges) // Show buttons only if changes have been made
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _resetSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF309092),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Reset'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _applyChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF309092),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Apply'.tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}