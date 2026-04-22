import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class SSLPinning {
  static const String _certificatePath =
      'assets/certificates/api_themoviedb_org.pem';

  static Future<IOClient> createPinnedClient() async {
    final context = SecurityContext(withTrustedRoots: false);
    final certBytes = await _loadCertificate();
    context.setTrustedCertificatesBytes(certBytes);

    final httpClient = HttpClient(context: context);
    return IOClient(httpClient);
  }

  static Future<Uint8List> _loadCertificate() async {
    final byteData = await rootBundle.load(_certificatePath);
    return byteData.buffer.asUint8List();
  }
}
