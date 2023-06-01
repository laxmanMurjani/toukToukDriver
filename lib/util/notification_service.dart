import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static Future sendNotification(
      String body, String title, String token, String image) async {
    String baseUrl = 'https://fcm.googleapis.com/fcm/send';
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAJxfZGsg:APA91bGNnSjs_uNifiKoeeiMtSst0CUvkA4bs-cUigs5aVsE9BqoIgh1L05EArh9Kld8xrjyGFraPku4bfUgUk4Ub7ORIj085VVliiIK4v-roBxQ8s5eg_mNES7gRVqtOVwXpR9Nkp9A'
            //'key=AAAA1wR8eks:APA91bEH7IkNc9wsSU1oAV1Uu-SUF_VIzuBGItI7J32SCOE93G0glv7vA31tQPlJj0050Lq_JBTJ8dVWKm_htzbc2qk3WwirV5yFoYsZ8WF5J9cC4Yua3FaSOtllS9ZLW89l2LpTvh26'
            //'key=AAAAXz4ZAik:APA91bGxoE1c1Vm1lUo2L2zJQfFdyc1JXNOiFgaYAnUmupu3wL19LH1oxx_iSI1-8WQOKfFl0l2bKaCfo3uA0RdTIdzoaygzLcRDmLV2A9moKyQxbBgztiE2QBrUS4u1D164-nAbW39t',
      },
      body: jsonEncode({
        "notification": {"body": body, "title": title, "image": ""},
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "1",
          "status": "done",
          "open_val": "B",
          "image":
              "https://images.idgesg.net/images/article/2017/08/lock_circuit_board_bullet_hole_computer_security_breach_thinkstock_473158924_3x2-100732430-large.jpg"
        },
        "registration_ids": [token]
      }),
    );
    print('Status code : ${response.statusCode}');
    print('Body : ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      var message = jsonDecode(response.body);
      return message;
    } else {
      print('Status code : ${response.statusCode}');
    }
  }
}
