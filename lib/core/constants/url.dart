import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = dotenv.env['BASE_URL']!;
final networkImageUrl = dotenv.env['NETWORK_URL']!;
const bool kDevMode = true;
