// Copyright (c) 2017, zidenis. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_route/shelf_route.dart';

import 'config.dart';

Map config;

main(List<String> args) async {
  var parser = new ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080')
    ..addOption('host', abbr: 'h', defaultsTo: '0.0.0.0');
  var cmdArgs = parser.parse(args);

  config = await new Config().load();
  print(config['servers']);

  Router routes = router();
  routes.addAll(new ServersRouter(), path: '/api/v1/servers');

  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(routes.handler);

  try {
    int port = int.parse(cmdArgs['port']);
    String host = cmdArgs['host'];
    await io.serve(handler, host, port);
    print("Listening on $host:$port");
    printRoutes(routes);
  } on SocketException  catch (e) {
      print(e.message);
  } on FormatException catch (e) {
      print("Invalid arguments");
  }
}


class ServersRouter {

  call(Router routes) {
    routes.addAll((Router r) => r
      ..get('/', (request) => apiGetServers(request))
      ..post('/', (request) => apiPostServers(request))
      ..delete('/{serverID}', (request) => apiDeleteServerByID(request))
      ..get('/{serverID}', (request) => apiGetServerByID(request)));
  }

  Response apiGetServerByID(Request request) {
    String id = getPathParameters(request)["serverID"];
    for (var server in config['servers']) {
      if (server['id'] == id) return new Response.ok(server.toString());
    }
    return new Response.notFound('');
  }

  Response apiDeleteServerByID(Request request) {
    //TODO
  }

  Response apiPostServers(Request request) {
    //TODO
  }

  Response apiGetServers(Request request) {
    return new Response.ok(config['servers'].toString());
  }

  Response atlasGUI(Request request) {
    //TODO
  }

}