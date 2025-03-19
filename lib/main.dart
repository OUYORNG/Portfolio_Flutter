import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.robotoTextTheme()),
      home: PortfolioScreen(),
    );
  }
}

class PortfolioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Image.network(
              'https://gic.itc.edu.kh/img/logo.png', // Replace with your image URL
              height: 40, // Adjust the height as needed
              width: 40, // Adjust the width as needed
            ),
            SizedBox(width: 8), // Add spacing between the image and the text
            Text("GIC-25th", style: GoogleFonts.roboto(fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white, size: 35),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/ORNG.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Welcome Text
              Text(
                "WELCOME TO MY PORTFOLIO",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 10),

              // Name and Title
              Text(
                "HI I'M",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "OUYORNG KHEANG",
                style: GoogleFonts.roboto(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Text(
                "4th YEAR IT STUDENT",
                style: GoogleFonts.roboto(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "A very curious and passionate to learn new things with flexible and easy-going personality. I have a strong commitment to learn multiple programming languages and tools. I would prefer my leisure time to keep up with the upcomming technology and improves my skills.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey),
                ),
              ),
              SizedBox(height: 30),

              // Hire Me Button
              TextButton(
                onPressed: () async {
                  const telegramUrl =
                      'tg://resolve?domain=OUYORNG'; // Replace 'username' with the Telegram username
                  if (await canLaunchUrl(Uri.parse(telegramUrl))) {
                    await launchUrl(Uri.parse(telegramUrl));
                  } else {
                    // Fallback to the web version if the Telegram app is not installed
                    const fallbackUrl =
                        'https://t.me/OUYORNG'; // Replace 'username' with the Telegram username
                    if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
                      await launchUrl(Uri.parse(fallbackUrl));
                    } else {
                      throw 'Could not launch Telegram';
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 25,
                  ),
                  child: const Text(
                    'Hire Me',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Download CV Button
              OutlinedButton(
                onPressed: openLocalCV,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Download CV",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.download, color: Colors.blue),
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

Future<void> downloadCV() async {
  const url = 'https://example.com/cv.pdf'; // Replace with your CV URL
  final fileName = 'cv.pdf';

  // Request storage permission (needed for Android)
  if (Platform.isAndroid) {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      print('Permission denied');
      return;
    }
  }

  try {
    // Get download directory
    Directory? dir = await getApplicationDocumentsDirectory();
    String filePath = '${dir.path}/$fileName';

    // Download file
    Dio dio = Dio();
    await dio.download(url, filePath);

    print('Download completed: $filePath');

    // Open file
    OpenFile.open(filePath);
  } catch (e) {
    print('Download failed: $e');
  }
}

Future<String> copyCVToLocal() async {
  // Get the app's document directory
  Directory directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/OUYORNG_CV.pdf';

  // Check if the file already exists
  File file = File(filePath);
  if (!await file.exists()) {
    // Load file from assets
    ByteData data = await rootBundle.load('assets/OUYORNG_CV.pdf');
    List<int> bytes = data.buffer.asUint8List();

    // Write the file to local storage
    await file.writeAsBytes(bytes);
    print('CV copied to: $filePath');
  }
  return filePath;
}

Future<void> openLocalCV() async {
  String filePath = await copyCVToLocal();
  OpenFile.open(filePath);
}
