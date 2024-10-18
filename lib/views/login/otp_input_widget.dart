import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpInputWidget extends StatefulWidget {
  final Function(String) onOtpChanged;

  OtpInputWidget({Key? key, required this.onOtpChanged}) : super(key: key);

  @override
  _OtpInputWidgetState createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _controllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[i].text.length,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  void _updateOtp() {
    String otp = _controllers.map((controller) => controller.text).join();
    widget.onOtpChanged(otp);

    if (otp.length == 4) {
      FocusScope.of(context).unfocus(); // Dismiss keyboard when OTP is complete
    }
  }

  void _handleBackspace() {
    final currentFocus = FocusScope.of(context).focusedChild;
    if (currentFocus != null) {
      final currentIndex = _focusNodes.indexOf(currentFocus as FocusNode);
      if (currentIndex != -1) {
        if (_controllers[currentIndex].text.isEmpty && currentIndex > 0) {
          _controllers[currentIndex - 1].clear();
          FocusScope.of(context).requestFocus(_focusNodes[currentIndex - 1]);
        } else {
          _controllers[currentIndex].clear();
        }
        _updateOtp();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace) {
          _handleBackspace();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          4,
          (index) => SizedBox(
            width: 50,
            height: 60,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
              decoration: InputDecoration(
                counterText: "",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade900, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white10,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                if (value.isNotEmpty) {
                  if (index < 3) {
                    FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                  } else {
                    _focusNodes[index].unfocus();
                  }
                }
                _updateOtp();
              },
              onTap: () {
                if (_controllers[index].text.isEmpty &&
                    index > 0 &&
                    _controllers[index - 1].text.isEmpty) {
                  FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
