// Copyright (c) 2017, zidenis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_route/shelf_route.dart';

main(List<String> args) async {
  var parser = new ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080')
    ..addOption('host', abbr: 'h', defaultsTo: '0.0.0.0');
  var cmdArgs = parser.parse(args);

  var myRouter = router();
  myRouter.get('/atlas', (request) => atlasGUI(request));
  myRouter.get('/api/v1/servers', (request) => apiGetServers(request));

  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(myRouter.handler);

  try {
    int port = int.parse(cmdArgs['port']);
    String host = cmdArgs['host'];
    await io.serve(handler, host, port);
    print("Listening on $host:$port");
  } on SocketException  catch (e) {
      print(e.message);
  } on FormatException catch (e) {
      print("Invalid arguments");
  }
}

shelf.Response apiGetServers(shelf.Request request) {
  return new shelf.Response.ok('Request for "${request.url}"');
}

shelf.Response atlasGUI(shelf.Request request) {
  return new shelf.Response.ok('ATLAS GUI');
}