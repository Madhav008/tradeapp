import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:fanxange/appwrite/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:showcaseview/showcaseview.dart';

class QRViewer extends StatefulWidget {
  const QRViewer({Key? key}) : super(key: key);

  @override
  _QRViewerState createState() => _QRViewerState();
}

class _QRViewerState extends State<QRViewer> {
  final GlobalKey _globalKey = GlobalKey();
  GlobalKey _saveQrKey = GlobalKey();
  GlobalKey _oneUpiKey = GlobalKey();
  bool isQrSaved = false; // Tracks whether the QR code has been saved
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([_saveQrKey, _oneUpiKey]);
    });
  }

  static const platform = MethodChannel('live.fanxange.app/channel');

  Future<void> launchAppByPackageName(String packageName) async {
    try {
      await platform
          .invokeMethod('launchAppByPackageName', {'packageName': packageName});
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the app: ${e.message}')),
      );
    }
  }

  Future<void> _saveScreen() async {
    try {
      // Check and request storage permission
      var status = await Permission.photos.status;
      if (!status.isGranted) {
        status = await Permission.photos.request();
      }

      if (status.isGranted) {
        RenderRepaintBoundary boundary = _globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image qrImage = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await qrImage.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          // Define the border size
          const int borderSize = 20; // You can adjust the border size

          // Create a new PictureRecorder and Canvas with extra size for the border
          ui.PictureRecorder recorder = ui.PictureRecorder();
          Canvas canvas = Canvas(
              recorder,
              Rect.fromLTWH(0, 0, qrImage.width + borderSize * 2,
                  qrImage.height + borderSize * 2));

          // Set the canvas background to white
          canvas.drawColor(Colors.white, BlendMode.srcOver);

          // Draw the QR image onto the canvas centered with the border
          ui.Image image =
              await decodeImageFromList(byteData.buffer.asUint8List());
          canvas.drawImage(image,
              Offset(borderSize.toDouble(), borderSize.toDouble()), Paint());

          // Convert the canvas drawing to an image
          ui.Picture picture = recorder.endRecording();
          ui.Image finalImage = await picture.toImage(
              qrImage.width + borderSize * 2, qrImage.height + borderSize * 2);
          ByteData? finalByteData =
              await finalImage.toByteData(format: ui.ImageByteFormat.png);

          if (finalByteData != null) {
            // Save the final image with a white background and border to the gallery
            final result = await SaverGallery.saveImage(
              finalByteData.buffer.asUint8List(),
              name: "${DateTime.now().millisecondsSinceEpoch}.png",
              androidRelativePath: "Pictures/appName/xx",
              androidExistNotSave: false,
            );
            setState(() {
              isQrSaved = true; // Enable the UPI payment buttons
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('QR CODE Saved')));
          }
        }
      } else if (status.isPermanentlyDenied) {
        openAppSettings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Storage permission is required to save the image')));
        status = await Permission.photos.request();
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletApi = context.watch<WalletProvider>();
    final upiId = walletApi.upiId;
    final amount = walletApi.amount;

    return ShowCaseWidget(
      builder: Builder(builder: (context) {
        return Column(
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: PrettyQrView.data(
                data:
                    'upi://pay?pa=paytmqr2810050501011dupyvwy1xxc@paytm&am=${amount}&pn=Fanxange&mc=5499&mode=02&orgid=000000&paytmqr=2810050501011DUPYVWY1XXC&tn=From_${upiId}&sign=MEUCIEvY00mXGj1Nj2D5leMdDqTsAQ09pyibK9BEnwPIpi4EAiEAxJ6oYZeGdqGMryeYnhil9Xw1PhIzCaOcTmRfghcfmNs=',
                decoration: const PrettyQrDecoration(
                  image: PrettyQrDecorationImage(
                    image: AssetImage('assets/images/cricket-ball.png'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Showcase(
              key: _saveQrKey,
              description: 'Tap to save the QR code to your gallery',
              child: GestureDetector(
                onTap: _saveScreen,
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF21899C),
                    borderRadius: BorderRadius.circular(50.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4C2E84).withOpacity(0.2),
                        offset: const Offset(0, 15.0),
                        blurRadius: 60.0,
                      ),
                    ],
                  ),
                  child: Text(
                    'SAVE QR TO GALLERY',
                    style: GoogleFonts.inter(
                      fontSize: 13.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Showcase(
              key: _oneUpiKey,
              description: 'Tap On UPI APP From Which you want to Pay',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  paymentButton(
                      'assets/images/gpay.png',
                      'com.google.android.apps.nbu.paisa.user',
                      isQrSaved), // Package name for Google Pay
                  paymentButton('assets/images/paytm.png', 'net.one97.paytm',
                      isQrSaved), // Package name for Paytm
                  paymentButton('assets/images/phonepe.png', 'com.phonepe.app',
                      isQrSaved), // Package name for PhonePe
                  paymentButton('assets/images/upi.png', 'in.org.npci.upiapp',
                      isQrSaved), // Package name for BHIM UPI
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget paymentButton(String assetName, String packageName, bool isEnabled) {
    return IconButton(
      icon: Image.asset(
        assetName,
        width: 40,
        height: 50,
      ),
      iconSize: 20,
      onPressed: () {
        if (isQrSaved) {
          launchAppByPackageName(packageName);
        } else {
          Fluttertoast.showToast(
              msg: "Please save the QR to the gallery first.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
    );
  }
}
