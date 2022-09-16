// ignore_for_file: prefer_const_constructors

/**
 *
 * authors @musabisimwa @diri0060
 *
 * main screen
 * contains the client main app screen with a map and a contact selector
 * for more information follow the link below
 * link: https://runtime-terror4001.atlassian.net/wiki/spaces/SA/blog/2022/03/16/753665/UI+UX+Design
 *
 *
 */
/// note to dev: should contain minimal business logic

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:line_icons/line_icons.dart';
import 'package:safe_app/constats.dart';
import 'package:safe_app/screens/client/navigationScreen.dart';
import 'package:safe_app/screens/client/wrapper.dart';
import 'package:safe_app/screens/common/iconTextField.dart';
import 'package:safe_app/screens/common/themedFrame.dart';
import 'package:safe_app/screens/common/themedHooks.dart';
import 'package:safe_app/services/database/database.dart';
import 'package:safe_app/services/database/localdb.dart';
import 'package:safe_app/services/models/auth_model.dart';
import 'package:safe_app/services/models/auth_model.dart';
import 'package:safe_app/services/models/contact_model.dart';

import 'package:safe_app/services/providers/geolocation_provider.dart';
import 'package:safe_app/services/providers/main_screen_provider.dart';
import 'package:safe_app/services/repositories/google_places_repository.dart';
import 'package:safe_app/services/authentication/auth.dart';
import 'package:safe_app/services/repositories/sms_repository.dart';
import 'package:provider/provider.dart' as stream_provider;
//import 'package:safe_app/screens/statemanagement/p'

class ClientMainScreen extends ConsumerStatefulWidget {

  final String? uid;
  final Stream<bool> stream;
  //final AppUser? appUser;
  const ClientMainScreen(this.uid, this.stream, {Key? key}) : super(key: key);

  @override
  _ClientMainScreen createState() => _ClientMainScreen(uid);
}

class _ClientMainScreen extends ConsumerState<ClientMainScreen> {
  // User id of current user
  String? _uid;
  AppUser? _appUser;
  List<AppContact>? appContacts;
  AppContact? assignContact;
  int? assignContactIndex;
  late GoogleMapController mapController;
  //uposition if available
  Position? _currentPosition;
  //reduce suggestions request interval
  Timer? _timer;
// placemarks
  String? navDistance;
  String? navTime;
  late List<Placemark> placemarks;
  // precise human legible location detail
  late Map<String, String> _positionDetails;
  //location service manager
  final LocationProvider locationProvider = LocationProvider();
  // sms services
  final SMSRepository _smsRepository = SMSRepository();
  //for google places search suggestions
  late GooglePlace googleplace;
  final _searchFieldController = TextEditingController();
  late List<AutocompletePrediction> predictions;
  //markers set
  late Set<Marker> _markers;

  late Set<Polyline> _polylines;

  //get full contacts
  //List<Contact>? contacts;

  //sos btn label and color
  String SOSLabel = "SOS";
  Color SOScolor = Color.fromARGB(255, 160, 56, 53);

  ///contact color bg
  Color contactColorbg = Colors.white.withOpacity(0.3);
  Color contactChoseColorbg = Colors.red.withOpacity(0.3);
  bool contactcolorsw = false;
  bool _contactExists = true;
  //context switch @ go button click
  bool _inNavigationMode = false;

  // priority button label
  String _priotrityLabel = 'LOW';
  Priority priority = Priority.LOW;
  //home address
  String? _homeAddress;
  // SOS timer
  Timer? countdownTimer;
  Duration myDuration = Duration();


  _ClientMainScreen(String? uid) {
    _positionDetails = {};
    _polylines = {};
    googleplace = GooglePlace(G_API_KEY);
    predictions = <AutocompletePrediction>[];
    _markers = {};
    _uid = uid;
    _appUser = AppUser(id: _uid!, isAdmin: false);
  }

  ///setting a marker on a map
  void _setMarker(LatLng location, String? id) {
    setState(() {
      if (id == HOME_MARKER_ID) {
        _markers.add(Marker(
            markerId: MarkerId(HOME_MARKER_ID),
            infoWindow: InfoWindow(title: 'home'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            position: location));
      } else {
        _markers.add(Marker(
            markerId: MarkerId(DESTINATION_MARKER_ID),
            infoWindow: InfoWindow(title: 'destination'),
            icon: BitmapDescriptor.defaultMarker,
            position: location));
      }
    });
  }

  void _drawPolylines(List<PointLatLng> points) {
    _polylines.add(Polyline(
      polylineId: PolylineId('polyline'),
      width: 3,
      color: Colors.blueAccent,
      points: points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
              _currentPosition?.latitude ?? 45.4336,
              _currentPosition?.longitude ??
                  -75.7227), // should get current position
          zoom: 15,
        ),
      ),
    );
  }

  void getAddress() async {
    _currentPosition = await locationProvider.getCurrentPosition();
    placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude);
    _positionDetails['postalCode'] = placemarks[0].postalCode!;
    _positionDetails['address'] = placemarks[0].street!;
    _positionDetails['city'] = placemarks[0].locality!;
    _positionDetails['country'] = placemarks[0].country!;
  }

//contacts
//   void getPhoneData() {
//     appContacts = _appUser!.contacts;
//   }

  Future<void> getCurrentUser() async {
    _appUser = await DatabaseService(uid: _uid).getUserData(_appUser!);
    if (_appUser!.contacts != null && _appUser!.contacts!.length != 0) {
      setState(() {
        appContacts = _appUser!.contacts;
        appContacts![0].chose = true;
        assignContactIndex = 0;
        assignContact = appContacts![0];
      });
    } else {
      setState(() {
        appContacts = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();

    widget.stream.listen((event) {
      callBack();
    });

    getAddress();
    //on textfield changed
    //ref.read(locationNotifier.notifier).getCurrentPosition();

    getCurrentUser();

    _searchFieldController.addListener(() {
      if (_timer?.isActive ?? false) {
        _timer!.cancel();
      }
      //wait 1 sec before sending the request
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        setState(() {
          if (assignContact == null) {
            _contactExists = false;
          } else {
            _contactExists = true;
          }
        });
        _currentPosition = await locationProvider.getCurrentPosition();
        if (_searchFieldController.value.text.isNotEmpty) {
          predictions = await autoCompleteSearch(
              search: _searchFieldController.value.text,
              googleplace: googleplace);
          if (predictions.isNotEmpty) {
            // _searchFieldController.text = predictions.first.description!;
          }
        }
      });
    });
  }

  void _navigate(String to, String prediction) async {
    //get text in   'where to text field
    //get current  location detail  -> to backend

    String? currentAdress =
        "${_positionDetails['address']},${_positionDetails['city']},${_positionDetails['country']}";
    final directions = await GooglePlacesRepository()
        .getDirections(from: currentAdress, to: to);

    // take the suggestion anyway
    final stream = Stream<Future<Position?>>.periodic(
        Duration(seconds: 1), (pos) => locationProvider.getCurrentPosition());

    onSuggestionTileTapped(prediction);
    setState(() {
      ///_positionDetails.forEach((key, value) {
      /// print("$key $value");
      ///});
      _drawPolylines(directions['polyline_dec']);
      // switch context
      //distance and time
      navDistance = directions['distance'];
      navTime = directions['duration'];
      _inNavigationMode = !_inNavigationMode;
    });
  }

  // on Go button pressed
  void onGoButtonPressed() async {
    //get text in   'where to text field
    //get current  location detail  -> to backend
    String? currentAdress =
        "${_positionDetails['address']},${_positionDetails['city']},${_positionDetails['country']}";
    String prediction = predictions[0].description ?? currentAdress;
    _navigate(_searchFieldController.value.text, prediction);
  }

//get home address if set,
  /// go automatically


  void onHomeButtonPressed() async {
    // automatically navigate to set home
    _homeAddress = await LocalStorageService.getAddress();
    if (_homeAddress == null) {
      setState(() {
        Navigator.pushNamed(context, CLIENT_SETTING_ROUTE);
      });
    } else {
      _navigate(_homeAddress!, _homeAddress!);
    }
  }

  ///
  ///on suggestion tile tapped
  ///camera moves to place suggested on the tile
  ///marker plced
  ///
  void onSuggestionTileTapped(String prediction) async {
    //marker lat,long pos
    LatLng position =
    await GooglePlacesRepository().getPlaceCoordinates(prediction);
    setState(() {
      //print(prediction);
      //print('$lat,$long');
      // move the camera(map) to prediction on the tile
      goToPlace(place: prediction, googleMapController: mapController);
      //set marker here
      _setMarker(position, DESTINATION_MARKER_ID);
    });
  }

  void onCloseNavigation() async {
    //close navigation context,
    //send the contact about the cancelation
    //todo : uncomment this code below when twilio is pro mode
    //String contact = assignContact!.phoneNumber;
    String contact = '6138799041'; //'3432979076';
    String message =
        "${_appUser?.firstName ?? 'user'} has cancelled their navigation\n"
        "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}";

    //phone number
    await _smsRepository.sendSms(number: contact, messageBody: message);

    ///send location with cancel notification
    _inNavigationMode = false;
    setState(() {
      Navigator.popAndPushNamed(context, CLIENT_MAIN_ROUTE);
    });
  }

  Future<void> callBack() async {
    await DatabaseService(uid: _appUser!.id)
        .getUserData(_appUser!)
        .then((value) {
      setState(() {
        // List<AppContact>? appContacts;
        // AppContact? assignContact;
        // int? assignContactIndex;
        appContacts = value.contacts;
        if (appContacts!.length != 0) {
          appContacts![0].chose = true;
          assignContact = appContacts![0];
          assignContactIndex = 0;
        } else {
          assignContact = null;
          assignContactIndex = 0;
        }
      });
    });
  }

  //starts counter for timer
  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  //stops timmer
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  //resets timer(not used but can be)
  void resetTimer() {
    stopTimer();
    setState(() => myDuration = Duration());
  }

  // sets the counter timer increments
  void setCountDown() {
    final addSeconds = 1;
    setState(() {
      final seconds = myDuration.inSeconds + addSeconds;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  ///
  ///
  ///on sos send signal to firebase and sms to the watcher list
  ///record Audio/Videos send to firebase
  ///generate positional link /video link
  void onSOSButtonpressed() async {
    // most important method

    //, _currentPosition!.longitude)
    String message =
        "${_appUser?.firstName ?? 'an annonymous user'} triggered an SOS signal\nview location\nhttps://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}";
    //if priority is low send only location
    SmsStatus _sosStatus;

    // Send sms to the selected contact
    //todo : uncomment this code below when twilio is pro mode
    //String contact = assignContact!.phoneNumber;
    String contact = '6138799041'; //'3432979076';
    //if high send with vid
    if (priority == Priority.LOW) {
      _sosStatus =
          await _smsRepository.sendSms(number: contact, messageBody: message);
      DatabaseService(uid: _appUser!.id).addAlert(
          message,
          assignContact ??
              AppContact(id: -1, phoneNumber: '', name: 'aegis system'),
          _currentPosition,
          _positionDetails['postalCode'],
          _positionDetails['address'],
          _positionDetails['city'],
          _positionDetails['country']);
    } else {
      _sosStatus =
      await _smsRepository.sendSms(number: contact, messageBody: message);
    }

    setState(() {
      //change btn color and name to
      SOSLabel = _sosStatus.message;

      SOScolor = Color.fromARGB(255, 69, 148, 151);
    });
  }

  //when the priority
  ///
  ///when priority btn is pressed
  ///show level,set level
  void onPriorityButtonPressed() {
    setState(() {
      if (priority == Priority.LOW) {
        _priotrityLabel = 'HIGH';
        priority = Priority.HIGH;
      } else {
        _priotrityLabel = 'LOW';
        priority = Priority.LOW;
      }
    });
  }

//on settings button pressed -Go to settings context screen
  void onSettingsButtonPressed() {
    setState(() {
      Navigator.pushNamed(context, CLIENT_SETTING_ROUTE);
    });
  }

  void assignAppContact(int index) {
    setState(() {
      if (index != assignContactIndex) {
        appContacts![assignContactIndex!].chose =
            !appContacts![assignContactIndex!].chose;
        appContacts![index].chose = !appContacts![index].chose;
        assignContactIndex = index;
        assignContact = appContacts![index];
      }
    });
  }

//garbage collection
  @override
  void dispose() {
    _searchFieldController.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //location from provider
    //final currentLocation = ref.watch(locationNotifier);
    final user = stream_provider.Provider.of<AppUser?>(context);
    //print(appContacts!.length);
    //contacts = List.from(user!.contacts);
    return ThemedFrame(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(), // push up when keyboard pops up
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  // circular profile widget
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height *
                        0.50, //50% of the screen height,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        heightFactor: 0.3,
                        widthFactor: 2.5,
                        child: GoogleMap(
                          markers: _markers,
                          polylines: _polylines,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(_currentPosition?.latitude ?? 45.4336,
                                _currentPosition?.longitude ?? -75.7227),
                            zoom: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
              //setting icon
              _inNavigationMode
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.all(6),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromARGB(62, 181, 198, 206),
                        ),
                        child: IconButton(
                          //onSettings button pressed
                          onPressed: onSettingsButtonPressed,
                          icon: Icon(
                            Icons.settings,
                            color: Color.fromARGB(255, 15, 69, 77),
                            size: 35,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 9)),
          HorizontalDivider(opacity: 0.3),

          ///contacts
          _inNavigationMode
              ? navigationGroup(
                  countdownTimer: countdownTimer,
                  onSOSButtonpressed: onSOSButtonpressed,
                  startTimer: startTimer,
                  stopTimer: stopTimer,
                  distance: navDistance,
                  eta: navTime,
                  sosBtnLabel: SOSLabel,
                  sosBtnColor: SOScolor,
                  priorityLabel: _priotrityLabel,
                  priority: priority,
                  upperText: navDistance??'25',
                  trackText: navTime??'tap every 25 sec',
                  height: MediaQuery.of(context).size.height *
                      ((Platform.isAndroid) ? 0.25 : 0.23),
                  width: MediaQuery.of(context).size.width * .9)
                  :
              //contact group
              Container(
                  height: MediaQuery.of(context).size.height * .10,
                  width: MediaQuery.of(context).size.width * .90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _contactExists
                        ? Color.fromARGB(190, 177, 253, 228)
                        : Color.fromARGB(193, 143, 60, 54),
                  ),
                  child: SizedBox(
                    height: 75, //icon size
                    child: (appContacts == null)
                        // if contact is empty show circular progress bar
                        ? Center(child: CircularProgressIndicator())
                        : (appContacts!.isEmpty)
                            ? Center(
                                child: Text(
                                  'No contact found',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemExtent: 75, // space the contact icons
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: appContacts!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Center(
                                      child: CircularPictureButton(
                                          bgcolor: (appContacts![index].chose)
                                              ? contactChoseColorbg
                                              : contactColorbg,
                                          onTap: () {
                                            assignAppContact(index);
                                          },
                                          name: (appContacts![index]
                                                      .name
                                                      .length <=
                                                  5)
                                              ? appContacts![index].name
                                              : appContacts![index]
                                                  .name
                                                  .substring(0, 5)));
                                },
                              ),
                  ),
                ),

              //contact widget group
              HorizontalDivider(opacity: 0.3),
              Padding(padding: EdgeInsets.only(top: 10)),
              //search widget group

              //context navigation : main home screen
              _inNavigationMode
                  ? ContactNavigationGroup(
                  onClosePressed: onCloseNavigation,
                  height: MediaQuery.of(context).size.height * .10,
                  width: MediaQuery.of(context).size.width * .90,
                  assignContact: assignContact,
                  myDuration: myDuration)
              : Container(
                  // search and button ensemble
                  height: MediaQuery.of(context).size.height *
                      ((Platform.isAndroid) ? 0.25 : 0.23),
                  width: MediaQuery.of(context).size.width * .90,
                  decoration: BoxDecoration(
                      color: _contactExists
                          ? Color.fromARGB(190, 177, 253, 228)
                          : Color.fromARGB(
                              193, 143, 60, 54), //(148, 210, 189, .9)
                      borderRadius: BorderRadius.circular(10)),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: IconTextField(
                            iconData: LineIcons.search,
                            controller: _searchFieldController,
                            width: 250,
                            height: 50,
                            fieldHintText: _contactExists
                                ? 'Where to?'
                                : 'assign a contact to navigate',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 70),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: (predictions.length > 3)
                                ? 1
                                : predictions.length,
                            itemBuilder: ((context, index) {
                              return ListTile(
                                onTap: () => onSuggestionTileTapped(
                                    predictions[0].description!),
                                title: Text(
                                  predictions[index].description.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 125),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  //immutable
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(
                                      'go home',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 40, 5),
                                    child: Text(
                                      'priority',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              //row here
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                    child: IconButton(
                                      onPressed: _contactExists
                                          ? onHomeButtonPressed
                                          : () {},
                                      icon: Icon(
                                        LineIcons.home,
                                        color: _contactExists
                                            ? Colors.white
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                  //Go button
                                  SimpleButton(
                                    // THE GO button
                                    height: 50,
                                    width: 120,
                                    onPressed: _contactExists
                                        ? onGoButtonPressed
                                        : () {},
                                    color: _contactExists
                                        ? Colors.green.shade900
                                        : Colors.grey.shade500,
                                    label: 'GO',
                                    fontSize: 20,
                                  ),
                                  SimpleButton(
                                    // THE prio
                                    height: 50,
                                    width: 100,
                                    onPressed: _contactExists
                                        ? onPriorityButtonPressed
                                        : () {},
                                    color: _contactExists
                                        ? Color.fromARGB(255, 24, 122, 146)
                                        : Colors.grey.shade500,
                                    label:
                                        _priotrityLabel, // label data should come from an external controller
                                    fontSize: 17,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}

///
///
