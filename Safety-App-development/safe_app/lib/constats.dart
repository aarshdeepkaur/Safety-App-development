// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/**
 *    constants
 * 
 * Contains all necessary constants
 * 
 */

//app name

const APP_NAME = 'Aegis';
const APP_VERSION = '0.9a';

//keys? dev
const G_API_KEY = 'AIzaSyCzWXqY0TiIke45Fu5b45OUsFJ05BarcAM';

//routes for client end
//login route
const CLIENT_LOGIN_ROUTE = '/login';

//isgnup
const CLIENT_SIGNUP_ROUTE = '/signup';

// main ui page route
const CLIENT_MAIN_ROUTE = '/main';

const CLIENT_SETTING_ROUTE = '/settings';

const CLIENT_FORGET_ROUTE = '/forget';

const CLIENT_ADD_CONTACT_ROUTE = '/contactMan';

const CLIENT_ADD_CONTACT_PHONE_ROUTE = '/contactPhone';

// home route
const ROOT_ROUTE = '/';

//end
/// google maps controllers
const DESTINATION_MARKER_ID = 'destination';
//home?
const HOME_MARKER_ID = 'home';

// twilio settings
const TWILIO_SID = 'ACadbfcd3636bcc3903fcb05a8d29e3ff9';
const TWILIO_TOKEN = '5e15d7bb7d3f60ab242fe0fcae41bde5';
const TWILIO_PHONE_NUMBER = '+13434296350';

// priorities
enum Priority { HIGH, LOW }

// SMS status when sms is sent
enum SmsStatus { OK, NOT_SENT, PHONE_NUM_INVALID }


// app permissions string

const APP_PERMISSION_STR =
    'This application requires access to the \n camera, mic, contacts and location services';
const APP_DEVELOPERS = 'Algonquin college';
