import 'package:firebase_messaging/firebase_messaging.dart';

class MyMassaging {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> getToken() async {
    // final serviceAccountJson = {
    //   "type": "service_account",
    //   "project_id": "my-store-41300",
    //   "private_key_id": "d2d25fb83bee9907c9d2adad9a1dba2ddb74fc49",
    //   "private_key":
    //       "-----BEGIN PRIVATE KEY-----\nMIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQC9/Fv10l+SEBGU\nZo6pwKDIUolCotPpkxtYwWB33xQVJ+5eRGXvscUOe9+SK0En8JilSlv5XgNvRkXl\n7RNgBb8WFVQr2l9712fsuVNAdNneAjdLfpAGEfTMqw87XeiEFIuzf/kUexqBWWxk\nb4aTPJXswk8g9SBqVKGE5YYArmb37THW0QIU6zJNkpvakVilHLYeq41BSxTNDQU/\n6iQS6/uFAjWPwW4ReZc1e9PofP+EHPhnsgUpTGpTJHQAALzhnMG2ytk2S8RrMK9q\nCWA+3fOHxgnSR+Ums/9RRBKE54eChP8hiy4iTHJLoy/k2BBKUBq/UmiA8OZLS0Bc\na3LxHuXzAgMBAAECggEAQOhzqKgfs8DeqLNjQVbI97fPIl+MA+yY9rlWko26CEJU\nu4slwn8bQogKyZ8Siyk1lZ8yjh9TEBTTs6rMKE2+S7asw7C/V4mv/V4Rtd9WQfXC\n232ZiiFfX/9/XDqIwntcgU6TFC68zv10vVmnAi28UR/PtgRZd0qDxmo+XoQ3NLOT\nqBY0hfEzCB7bBBSCldQkVp+oXdTDPwMU8bwfiboRNsB9WiCj0IixJLWGKmEQJJwY\nGc8Igkvr1dc/AuaYYpeYoEux2QmOYDTfn0WWRqIbkKqTJ83/i5gKVLsl2hCvpCmc\niDj4KzAKK1JFJFV7KsOA5C7Vc9S6CmaAVFagkyz/zQKBgQDnnrFqwSU/7BaT9Yms\nyYeFdaUuAKcw/C5Cu0U/Jdyo0wo9eGXxs5Z1xgy7Hv9ITaXq007Fp/R+TlZHcUpX\nJ1Ilte4bJPIkEFePVLGVDPP1g6XtUU0ATvrbW+dYy+VXBDDHA65KfJl/K4y8pxL2\nyeeToY1PYmCiiSOU/ep1UuNolQKBgQDR+8eGITNe4tIVOgxv6ga7xIQ/mWV34CQ2\ncB7Pt/8DkQm9vUvhPehqohfyb004dzFRdgHvQYpAF2gXqrwNu+RwFr3/EGnlqr9s\nydziSEGaslLMOEAUSlHEG+YXY3gPVpnFrnMqaCrtjZp458Wkh3jjItOd9OpN6Otj\nyU3PWuIKZwKBgEV0LLdaW5UjclHD2xjZBa5bbMCyqW/i7uxLw6P/8n8daYCtTcSA\nmamPTdn+nYZM4mfcHU7f4kzNqMmbizM/Mz7joxa4qXNvAxKTzvxm+fCxHVxgeLqS\n9F463NCfs5G4S/ghfm4PluevY3BemS0vtiVq2Djpwxh6DxVqXpf31wFRAoGBAMdo\nLoX1qW8GPzLhOUZeG57cdCphZbZ9KGZ5+wiPVqDwbyu8Q/7WZ4w7+jnD8LUam78c\nLaIjv0I1+Cfhf0wbjkfTkQJTd/0eNUL+P8CzlXlutqoxEMkz+oodZFf5od4PA2By\n1fMDkSCeRH9kupAQBoDMZeGu34K1GjRcyoOLbvUpAn8iLmWUcCL7u/hKTbaoJGXs\nnWwzSxdCJkz39V40ykhbHRcj6b6eoBIwL7KO7X4TlgBgxtpTxWiXCLf8SYeC8mpv\n4C5ii+iG+C3CL8oc4OjukD40RIzc2vXU+ep2hvUccqPZZNl+fzS4iQ5YGaXZIh6X\nJMtUZHrDqhZsghUMynOz\n-----END PRIVATE KEY-----\n",
    //   "client_email":
    //       "firebase-adminsdk-juywu@my-store-41300.iam.gserviceaccount.com",
    //   "client_id": "106711411410854014919",
    //   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    //   "token_uri": "https://oauth2.googleapis.com/token",
    //   "auth_provider_x509_cert_url":
    //       "https://www.googleapis.com/oauth2/v1/certs",
    //   "client_x509_cert_url":
    //       "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-juywu%40my-store-41300.iam.gserviceaccount.com",
    //   "universe_domain": "googleapis.com"
    // };

    

    // Create a JWT from the service account credentials

    return _messaging.getToken();
  }
}
