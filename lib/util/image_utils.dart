/*
 *     Copyright (C) 2021  DanXi-Dev
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class ImageUtils {
  /// Only extract a frame.
  static Future<Int64List> providerToBytes(
      BuildContext context, ImageProvider provider) async {
    Completer<Int64List> completer = Completer();
    var stream = provider.resolve(createLocalImageConfiguration(context));
    stream.addListener(
        ImageStreamListener((ImageInfo image, bool synchronousCall) async {
      ByteData byteData = await image.image.toByteData();
      // TODO: does the [buffer] represent the WHOLE image's byte array,
      //  or just a fixed-size (e.g. 512 Bytes) buffer array
      //  that should be filled with data for multiple times to read in the image?
      //  We need more inspection.
      completer.complete(byteData.buffer.asInt64List());
    }));
    return completer.future;
  }
}