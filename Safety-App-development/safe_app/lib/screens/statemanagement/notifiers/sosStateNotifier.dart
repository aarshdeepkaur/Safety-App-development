import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_app/constats.dart';
import 'package:safe_app/services/repositories/sms_repository.dart';

///
///
///SOS state notifier.dart
///@musabisimwa
///
///
///Manages the state of the context when SOS signal has been triggered
///this is the object that will be piped 😏  to the listener(s)
/// split in the localDB and firebase when the SOS button is clicked

//todo : include vide0/audio repos here
// will also be able to upload media to firebase, position to contact.s

//An SOS signal entails atleast a contact
//, a priority ,
//a message
// a video link
//a googlemaps pinpoint position

class SOSSignal {
  //one contact
  Contact? contact;
  //multiple contacts
  List<Contact>? contacts;
  Priority? priority;
  // message contains gmap and video links
  //to be added later
  String? message;
  SmsStatus? status;
  bool? withVideo;

  SOSSignal(
      {this.contact, this.contacts, this.message, this.priority, this.status});
  void addTo(
      {Contact? contact,
      List<Contact>? contacts,
      String? message,
      Priority? priority,
      SmsStatus? status,
      bool? withVideo}) {
    if (contact != null) {
      this.contact = contact;
    }
    if (contacts != null || contacts!.isNotEmpty) {
      this.contacts = contacts;
    }
    if (message != null) {
      this.message = message;
    }
    if (priority != null) {
      this.priority = priority;
    }
    if (status != null) {
      this.status = status;
    }
    if (withVideo != null) {
      this.withVideo = withVideo;
    }
  }
}

extension PriorityLabel on Priority {
  String get label {
    switch (this) {
      case Priority.HIGH:
        return 'HIGH';
      case Priority.LOW:
        return 'LOW';
      default:
        return 'NONE';
    }
  }
}

class SOSStateNotifier extends StateNotifier<SOSSignal> {
  late SMSRepository smsRepository;
  SOSStateNotifier()
      : super(SOSSignal(
            priority: Priority.LOW,
            status: SmsStatus.PHONE_NUM_INVALID,
            message: "NaN")) {
    smsRepository = SMSRepository();
  }

  // send message
  void sendSingleSMS(
      {required Contact contact,
      required String message,
      required Priority priority}) async {
    String _phone = contact.phones[0].number;
    SmsStatus status =
        await smsRepository.sendSms(number: _phone, messageBody: message);
    state.addTo(
        contact: contact,
        status: status,
        message: message,
        priority: priority,
        withVideo: false);
  }

  void setPriority(Priority priority) {
    state.addTo(priority: priority);
  }
}
