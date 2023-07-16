import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDbUtil {
  FirebaseDbUtil._();
  static FirebaseDbUtil instance = FirebaseDbUtil._();
  FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>>? _ref;

  DocumentReference<Map<String, dynamic>>? getDocRef(String roomId) {
    _ref = db.collection('rooms').doc(roomId);
    return _ref;
  }

  Future<void> deleteRoomIfExist(String roomId) async {
    try {
      if (_ref == null) return;
      final roomRef = db.collection('rooms').doc(roomId);
      QuerySnapshot<Map<String, dynamic>> calleeCandidates = await roomRef.collection('calleeCandidates').get();
      calleeCandidates.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> document) => document.reference.delete());
      QuerySnapshot<Map<String, dynamic>> callerCandidates = await roomRef.collection('callerCandidates').get();
      callerCandidates.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> document) => document.reference.delete());
    } catch (_) {}
  }
}
