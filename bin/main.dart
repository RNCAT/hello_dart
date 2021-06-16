import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';

var users = [
  {'id': 1, 'name': 'RennyCat'}
];
var id = 1;
var data = {'data': users};
main() async {
  var app = Angel();
  var http = AngelHttp(app);

  app.get('/users', getUsers);
  app.get('/users/:id', getUser);
  app.post('/users', addUser);
  app.put('/users/:id', editUser);
  app.delete('/users/:id', deleteUser);

  await http.startServer('localhost', 3000);
}

void getUsers(req, res) {
  res.json(data);
}

void getUser(req, res) {
  var id = int.parse(req.params['id']);
  var userIndex = users.indexWhere((f) => f['id'] == id);

  res.json(users[userIndex]);
}

void addUser(req, res) async {
  await req.parseBody();

  var name = req.bodyAsMap['name'] as String;

  if (name == null) {
    throw AngelHttpException.badRequest(message: 'Missing name.');
  } else {
    id += 1;
    users.add({'id': id, 'name': name});
    res.statusCode = 201;
  }
}

void editUser(req, res) async {
  await req.parseBody();

  var id = int.parse(req.params['id']);
  var name = req.bodyAsMap['name'] as String;

  var userIndex = users.indexWhere((f) => f['id'] == id);

  users[userIndex]['name'] = name;

  res.json(users[userIndex]);
}

void deleteUser(req, res) {
  var id = int.parse(req.params['id']);
  var userIndex = users.indexWhere((f) => f['id'] == id);

  users.remove(users[userIndex]);

  res.statusCode = 204;
}
