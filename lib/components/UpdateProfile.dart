import 'dart:io';

import 'package:fanxange/appwrite/auth_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File file = File('');
  Future<String> uploadImage(imageFile) async {
    // var uploadTask = storageRef.ref("post_$postId.jpg").putFile(imageFile);
    // var storageSnap = await uploadTask;
    // String downloadUrl = await storageSnap.ref.getDownloadURL();
    return 'downloadUrl';
  }

  Future handleChooseFromGallery() async {
    // ignore: deprecated_member_use
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    // var file = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      this.file = File(file!.path);
    });
    return this.file;
  }

  late String phone = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authApi = context.watch<AuthAPI>();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF21899C),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: height / 4.5,
              width: width,
              color: const Color(0xFF21899C),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      handleChooseFromGallery().then((value) {
                        uploadImage(value).then((value) {
                          Fluttertoast.showToast(
                              msg: "Profile Picture Updated",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM_RIGHT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        });
                      });
                    },
                    child: (file != null)
                        ? Container(
                            height: height / 10,
                            width: height / 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200),
                                color: Colors.white,
                                image: DecorationImage(
                                    image: FileImage(file), fit: BoxFit.cover)),
                          )
                        : Container(
                            height: height / 10,
                            width: height / 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(200),
                                color: Colors.white,
                                image: DecorationImage(
                                    image: (authApi.isVerified == false)
                                        ? NetworkImage('userData.profilePic')
                                        : NetworkImage(
                                            'assets/images/avtar1.png'),
                                    fit: BoxFit.cover)),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      authApi.username.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: height / 50),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style:
                        TextStyle(color: Colors.black38, fontSize: height / 55),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: TextField(
                      style: TextStyle(
                        fontSize: height / 60, // This is not so important
                      ),
                      onChanged: (value) {
                        nameController.text = value;
                      },
                      decoration: InputDecoration(
                        // errorText: doctorRegisterValidation.address.error,
                        hintText: authApi.username,
                        suffixIcon: Icon(Icons.person),
                        hintStyle: TextStyle(color: Colors.black38),
                        alignLabelWithHint: false,
                        helperText: "",
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Mobile",
                    style:
                        TextStyle(color: Colors.black38, fontSize: height / 55),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: TextField(
                      style: TextStyle(
                        fontSize: height / 60, // This is not so important
                      ),
                      onChanged: (value) {
                        phone = value;
                      },
                      decoration: InputDecoration(
                        // errorText: doctorRegisterValidation.address.error,
                        hintText: phone,
                        suffixIcon: Icon(Icons.phone_android),
                        hintStyle: TextStyle(color: Colors.black38),
                        alignLabelWithHint: false,
                        helperText: "",
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "E-mail",
                    style:
                        TextStyle(color: Colors.black38, fontSize: height / 55),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: TextField(
                      style: TextStyle(
                        fontSize: height / 60, // This is not so important
                      ),
                      onChanged: (value) {
                        emailController.text = value;
                      },
                      decoration: InputDecoration(
                        // errorText: doctorRegisterValidation.address.error,
                        hintText: authApi.email,
                        suffixIcon: Icon(Icons.mail),
                        hintStyle: TextStyle(color: Colors.black38),
                        alignLabelWithHint: false,
                        helperText: "",
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: InkWell(
                      onTap: () async {
                        if (nameController.text.isNotEmpty) {}
                        if (phone.isNotEmpty) {}

                        if (emailController.text.isNotEmpty) {}

                        if (addressController.text.isNotEmpty) {}

                        Fluttertoast.showToast(
                            msg: "Profile Updated",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM_RIGHT,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                      child: Container(
                        height: height / 13,
                        width: width,
                        decoration: BoxDecoration(
                            color: const Color(0xFF21899C),
                            borderRadius: BorderRadius.circular(height / 80)),
                        child: Center(
                            child: Text(
                          "UPDATE",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
