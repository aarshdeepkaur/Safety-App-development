import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:safe_app/constats.dart';

///
/// authors @musabisimwa
///
/// sms repositoty
/// purpose: provides an SMS send using  a free twilio account
///

//extend  on the SmS Status to display error messages
extension SmsErrorMsg on SmsStatus {
  String get message {
    switch (this) {
      case SmsStatus.OK:
        return 'SOS Sent';
      case SmsStatus.NOT_SENT:
        return 'not sent';
      case SmsStatus.PHONE_NUM_INVALID:
        return 'inval #';
      default:
        return 'NONE';
    }
  }
}

///

class SMSRepository {
  ///
  ///
  late TwilioFlutter _twilioFlutter;
  SMSRepository() {
    _twilioFlutter = TwilioFlutter(
        accountSid: TWILIO_SID,
        authToken: TWILIO_TOKEN,
        twilioNumber: TWILIO_PHONE_NUMBER);
  }

  /// send an sms to a number
  Future<SmsStatus> sendSms(
      {required String number, required String messageBody}) async {
    int _num = -1;
    String aegis = "SMS from AEGIS Alert Services";

    // sample +1 613 234 1234
    //len = 11
      _num = await _twilioFlutter.sendSMS(
          toNumber: '+1$number', messageBody: 'SOS - $messageBody \n $aegis');

      return Future.value((_num == 201) ? SmsStatus.OK : SmsStatus.NOT_SENT);
    } 
  
}
