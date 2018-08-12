import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart' show load, env;
import 'package:http/http.dart' as http;

const url = 'https://api.github.com/graphql';

main(List<String> arguments) {
  load();
  final token = env['github_token'];
  http
      .post(url,
          headers: {HttpHeaders.authorizationHeader: 'bearer $token'},
          body: jsonEncode(gq))
      .then((res) => print(res.body));
}

final gq = {'query': 'query { viewer { login }}'};
