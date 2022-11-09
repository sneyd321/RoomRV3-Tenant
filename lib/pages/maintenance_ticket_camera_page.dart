import 'dart:async';
import 'dart:io';

import 'package:camera_example/pages/create_maintenance_ticket_page.dart';
import 'package:camera_example/services/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../business_logic/tenant.dart';

class MaintenanceTicketCamera extends StatefulWidget {
  final String houseKey;
  final Tenant tenant;
  const MaintenanceTicketCamera({Key? key, required this.houseKey, required this.tenant}) : super(key: key);

  @override
  State<MaintenanceTicketCamera> createState() => _MaintenanceTicketCameraState();
}

class _MaintenanceTicketCameraState extends State<MaintenanceTicketCamera> {
  XFile? imageFile;

  void setImage(XFile? value) {
    imageFile = value;
  }

  void caputure(BuildContext context) {
    final ImagePicker picker = ImagePicker();
    picker
        .pickImage(
      source: ImageSource.camera,
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
      imageQuality: 100,
    )
        .then((pickedFile) {
      try {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateMaintenanceTicketPage(
                      file: pickedFile!,
                      houseKey: widget.houseKey,
                      tenant: widget.tenant
                    )));
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => caputure(context));
  }

  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: MediaQuery.of(context!).size.width,
        maxHeight: MediaQuery.of(context).size.height,
        imageQuality: 100,
      );
      setImage(pickedFile);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreateMaintenanceTicketPage(
                    file: pickedFile!,
                    houseKey: widget.houseKey,
                    tenant: widget.tenant,
                  )));
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
          setImage(response.file);
        } else {
          imageFile = response.files![0];
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
      ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.done:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                  }
                },
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
