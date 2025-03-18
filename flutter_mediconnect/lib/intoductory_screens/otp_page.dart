import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mediconnect/screen_pages/homepage.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpPage({super.key, required this.verificationId, required this.phoneNumber});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _verificationId;
  bool isLoading = false;
  String? errorMessage;
  bool canResendOTP = false;

  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> otpFocusNodes =
      List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    _startResendOtpTimer();

    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _saveUserToFirestore(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
      }
    });
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  bool get isOtpFilled =>
      otpControllers.every((controller) => controller.text.length == 1);

  /// ✅ **Verify OTP**
  void verifyOTP() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    String otpCode = otpControllers.map((c) => c.text).join();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otpCode,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _saveUserToFirestore(userCredential.user!);
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Invalid OTP! Please try again.";
      });
    }
  }

  /// ✅ **Save User Data to Firestore (If Not Exists)**
  Future<void> _saveUserToFirestore(User user) async {
    final userRef = _firestore.collection("users").doc(user.uid);

    DocumentSnapshot userDoc = await userRef.get();

    if (!userDoc.exists) {
      await userRef.set({
        "phoneNumber": widget.phoneNumber,
        "uid": user.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  /// ✅ **Resend OTP with Cooldown**
  void resendOTP() async {
    if (!canResendOTP) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
      canResendOTP = false;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        await _saveUserToFirestore(_auth.currentUser!);
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
            (route) => false, // ❌ Removes all previous routes (Login/OTP)
          );
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          errorMessage = "Failed to resend OTP. Try again.";
          isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          isLoading = false;
          canResendOTP = false;
        });
        _startResendOtpTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// ✅ **Start 30-Second Resend OTP Timer**
  void _startResendOtpTimer() {
    Future.delayed(const Duration(seconds: 30), () {
      setState(() {
        canResendOTP = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Verify OTP"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter OTP sent to your mobile number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    width: 40,
                    child: TextField(
                      controller: otpControllers[index],
                      focusNode: otpFocusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(otpFocusNodes[index - 1]);
                        }
                      },
                    ),
                  ),
                );
              }),
            ),

            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),

            const SizedBox(height: 30),

            // Verify OTP Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isOtpFilled ? verifyOTP : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOtpFilled ? Colors.orange : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify OTP", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 20),

            // Resend OTP Button
            Center(
              child: TextButton(
                onPressed: canResendOTP ? resendOTP : null,
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: canResendOTP ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
