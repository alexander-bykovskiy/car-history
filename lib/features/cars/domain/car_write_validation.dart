import 'dart:typed_data';

import '../../../core/car_photo_limits.dart';

/// Shared by repository create/update, gallery pick UX, and backup import.
bool isCarPhotoTooLarge(Uint8List? photo) {
  return photo != null && photo.lengthInBytes > kMaxCarPhotoBytes;
}
