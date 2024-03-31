import 'package:WhatsApp/auth/firebase.dart';
import 'package:WhatsApp/helper/show_alert_dialog.dart';
import 'package:WhatsApp/widgets/custom_elevated_button.dart';
import 'package:WhatsApp/widgets/custom_text_field.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController countryNameController;
  late TextEditingController countryCodeController;
  late TextEditingController phoneNumberController;
  bool isLoading = false;

  sendCodeToPhone() async {
    final phoneNumber = phoneNumberController.text;
    final countryName = countryNameController.text;
    final countryCode = countryCodeController.text;

    if (countryCode != '91') {
      return showAlertDialog(
        context: context,
        message:
            "Right now only India is supported\n\nPlease select India from the list",
      );
    }
    if (phoneNumber.isEmpty) {
      return showAlertDialog(
        context: context,
        message: "Please enter your phone number",
      );
    } else if (phoneNumber.contains(RegExp(r'[^0-9]'))) {
      return showAlertDialog(
        context: context,
        message: "Please enter a valid phone number",
      );
    } else if (phoneNumber.length < 10) {
      return showAlertDialog(
        context: context,
        message:
            'The phone number you entered is too short for the country: $countryName\n\nInclude your area code if you haven\'t',
      );
    } else if (phoneNumber.length > 10) {
      return showAlertDialog(
        context: context,
        message:
            "The phone number you entered is too long for the country: $countryName",
      );
    }
    setState(() {
      isLoading = true;
    });
    await signInWithGoogle(phoneNumber);
    setState(() {
      isLoading = true;
    });
  }

  showCountryPickerBottomSheet() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      favorite: ['IN'],
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: 600,
        flagSize: 22,
        borderRadius: BorderRadius.circular(20),
        textStyle: TextStyle(color: Theme.of(context).hintColor),
        inputDecoration: InputDecoration(
          labelStyle: TextStyle(color: Theme.of(context).hintColor),
          prefixIcon: Icon(
            Icons.language,
            color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          ),
          hintText: 'Search country by code or name',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).hintColor.withOpacity(.2),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor!,
            ),
          ),
        ),
      ),
      onSelect: (country) {
        countryNameController.text = country.name;
        countryCodeController.text = country.phoneCode;
      },
    );
  }

  @override
  void initState() {
    countryNameController = TextEditingController(text: 'India');
    countryCodeController = TextEditingController(text: '91');
    phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    countryNameController.dispose();
    countryCodeController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Enter your phone number',
          style: TextStyle(),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'WhatsApp will need to verify your number. ',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: "What's my number?",
                      style: TextStyle(
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: CustomTextField(
                onTap: isLoading ? null : showCountryPickerBottomSheet,
                controller: countryNameController,
                readOnly: true,
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                    child: CustomTextField(
                      onTap: showCountryPickerBottomSheet,
                      controller: countryCodeController,
                      prefixText: '+',
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: phoneNumberController,
                      hintText: 'phone number',
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.phone,
                      readOnly: isLoading,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Carrier charges may apply',
              style: TextStyle(
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLoading
          ? const CircularProgressIndicator()
          : CustomElevatedButton(
              onPressed: sendCodeToPhone,
              text: 'NEXT',
              buttonWidth: 90,
            ),
    );
  }
}
