import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';

class NotificationService {
  static Future sendNotification(
      String body, String title, String token, String image) async {

    String accessToken = await generateFCMAccessToken();

    try {
      var notification = {
        "message": {
          "token": token,
          "notification": {
            'title': title,
            'body': body,
            'image': image
          },
          'data': <String, String>{
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "id": "1",
            "status": "done",
            "open_val": "B",
            "image":
            "https://images.idgesg.net/images/article/2017/08/lock_circuit_board_bullet_hole_computer_security_breach_thinkstock_473158924_3x2-100732430-large.jpg"
          },
        }
      };

      // Send the notification
      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/touk-touk-taxi/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(notification),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
    // String baseUrl = 'https://fcm.googleapis.com/fcm/send';
    // final response = await http.post(
    //   Uri.parse(baseUrl),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Authorization':
    //         'key=AAAAJxfZGsg:APA91bGNnSjs_uNifiKoeeiMtSst0CUvkA4bs-cUigs5aVsE9BqoIgh1L05EArh9Kld8xrjyGFraPku4bfUgUk4Ub7ORIj085VVliiIK4v-roBxQ8s5eg_mNES7gRVqtOVwXpR9Nkp9A'
    //         //'key=AAAA1wR8eks:APA91bEH7IkNc9wsSU1oAV1Uu-SUF_VIzuBGItI7J32SCOE93G0glv7vA31tQPlJj0050Lq_JBTJ8dVWKm_htzbc2qk3WwirV5yFoYsZ8WF5J9cC4Yua3FaSOtllS9ZLW89l2LpTvh26'
    //         //'key=AAAAXz4ZAik:APA91bGxoE1c1Vm1lUo2L2zJQfFdyc1JXNOiFgaYAnUmupu3wL19LH1oxx_iSI1-8WQOKfFl0l2bKaCfo3uA0RdTIdzoaygzLcRDmLV2A9moKyQxbBgztiE2QBrUS4u1D164-nAbW39t',
    //   },
    //   body: jsonEncode({
    //     "notification": {"body": body, "title": title, "image": ""},
    //     "priority": "high",
    //     "data": {
    //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //       "id": "1",
    //       "status": "done",
    //       "open_val": "B",
    //       "image":
    //           "https://images.idgesg.net/images/article/2017/08/lock_circuit_board_bullet_hole_computer_security_breach_thinkstock_473158924_3x2-100732430-large.jpg"
    //     },
    //     "registration_ids": [token]
    //   }),
    // );
    // print('Status code : ${response.statusCode}');
    // print('Body : ${response.body}');
    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   var message = jsonDecode(response.body);
    //   return message;
    // } else {
    //   print('Status code : ${response.statusCode}');
    // }
  }

  static Future<String> generateFCMAccessToken() async {
    try {
      /* get these details from the file you downloaded(generated)
          from firebase console
      */
      String type = "service_account";
      String project_id = "touk-touk-taxi";
      String private_key_id = "af704f1acf2208893da0aa0b3b15bca06ee9ea89";
      String private_key = "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDB5H7BIY1KgQf1\naaWOIVBauQr9luCO/ztQHipG4o61XVJGbSiO/Q36CIm+gCBQW6XZiafgN0PNLCv8\nX+6fCKguJzYxUbNUiTC/2CQpe3DaVtjWcrodioxHOl9m47BwIuF+z+eQvOHZ/uiA\nC5ye1c8YP2tW303vx3xGrDpArOt6gzFOhhmfmEb7KOTebQ+YgPBBEvf0ZBrJFN1S\nszEwyulZjvvZ23jM3nFqXgS9ohY2i3r0V6KcNdJP1pC4D3aByXSNH+tWUF9rpKQW\nrFW5IJJIMsrNmP/1lVq+u5QZcgTwLDSe3pHmHlWf+V1u4y5AghNJVn5g7ewy7rRo\ntGK82PttAgMBAAECggEACqIHOXwnjXBqCVFT3OmCyJbhPWrqwazJiek9lEmUXenS\nOz59POovvAh/1UydeQqtm7Jq3GbrdvL3Lo3sPhhxcKaB2E6MsRQc8kheI1A7rh2Z\nIpmED16rtrRCyxetc1jWWOf54PwavqO2CF+apTNAeinwLwFr+rxL2mxTfXx+JWe3\n+GAmWpm1f+LVIIvDtVS43b2ubdo2BlHw9ZcwmMyKoCwyKt72JgG50Tb8PpSERwn7\noGcTtPrSQZ39ECeyNvit7P27RgYMuOYaM1rEMIJhP0GBK3C4p/4OjC8vhsdtK/84\nt7VoL1xwb02POwI2pmgDsre/jjNVSmRmbqAkND/XWQKBgQDlOG1gOoDU6dOs12ki\n0AmanYU5/fQunnVHf8h1y3VH24pyc6rJ4JKj9Ebm2lxYa9l6KswYheEil0xJIuXh\nSHpYVrJcdvm70WoB4CWVylK/RWHm5TuKxW5wOeUCtWaaZ15PTrtQRo685M6jvPln\nOxbcm8rpaiuRvaF7ERlUTyON9wKBgQDYi3mLeC08GrYpZfjv+0socjlAWLBSsxom\n4ZRjW0f+5RmYtXW0IASV1cQZ7guOht2w1wdUO8KTxH1EcDYXz9M/tWJI8TGwWzQA\nj1oxPWazaTDgtM1slvUESXOUPhUbXi5KQCxhnztGaGXzWcUwiiTUwYduXGl+qZs7\nsOMU9C/4uwKBgGEPpsjznPALX1W2FU/nddmhz/NBhO9kq9at1k2C7NOTtClIr04y\nqQWB/6/rUOUkLf/cNXZA4pdKJ8RkYaEmlp/nfjlHK/KK92954ZBvDuDtWUpzUOYv\nOdeNvFqMQ7koAjhk505TwkdcP9/3ukgrLkAWPDLggTiCaul40RfxNuX7AoGAeIrb\ntDnH5IdyFAWB2AVpRzCekiVMshylWDOGqPBtWYUrBIku5oBUTRxcN5r9r+9/hSuO\nFuPVYvCkUu6sDgFQtUxBVB1/7Y43moAyUuq9Ou45mTzMhcBa0HIa9tDAayW4Wvjy\nO72p/32qExdL38Nm0VCSFWs4Bpxfn5DOOCHeenUCgYAFx+uXY1OF5DIyPUatflw4\n4uSBrO8IDn2R/RL85ob7oJCy+gncMzYK/xyunifalpNCvW4wuMp2e5iFVenVopZ2\nrs3Irsx1OGov0vMRAfYs/PV4RmNUm/wdZtYN2iE3sBcm1aqbrmKkT6JnywMmY0Rm\n2yesGkLhHlk74BrDmkX1aw==\n-----END PRIVATE KEY-----\n";
      String client_email = "firebase-adminsdk-9xa11@touk-touk-taxi.iam.gserviceaccount.com";
      String client_id = "106040850169074600142";
      String auth_uri = "https://accounts.google.com/o/oauth2/auth";
      String token_uri = "https://oauth2.googleapis.com/token";
      String auth_provider_x509_cert_url = "https://www.googleapis.com/oauth2/v1/certs";
      String client_x509_cert_url = "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-9xa11%40touk-touk-taxi.iam.gserviceaccount.com";
      String universe_domain = "googleapis.com";

      final credentials = ServiceAccountCredentials.fromJson({
        "type": type,
        "project_id": project_id,
        "private_key_id": private_key_id,
        "client_email": client_email,
        "private_key": private_key,
        "client_id": client_id,
        "auth_uri": auth_uri,
        "token_uri": token_uri,
        "auth_provider_x509_cert_url": auth_provider_x509_cert_url,
        "client_x509_cert_url": client_x509_cert_url,
        "universe_domain": universe_domain
      });

      List<String> scopes = [
        "https://www.googleapis.com/auth/firebase.messaging"
      ];

      final client = await obtainAccessCredentialsViaServiceAccount(
          credentials, scopes, http.Client());
      final accessToken = client;
      // Timer.periodic(const Duration(minutes: 59), (timer) {
      //   accessToken.refreshToken;
      // });
      return accessToken.accessToken.data;
    } catch (e) {
      print('error: $e');
      // Reuse.logger.i("THis is the error: $e");
    }
    return "";
  }
}
