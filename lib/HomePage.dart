import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'Post.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _url = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperaDados() async {
    http.Response response = await http.get(_url + "/posts");
    var dados = json.decode(response.body);
    print(_url + "/posts");
    List<Post> postagens = List();
    for (var post in dados) {
      Post posts =
          Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(posts);
    }

    return postagens;
  }

  _post() async {
    var corpo = json.encode({
      "title": "blabla",
      "body": "bleble",
      "userId": 120,
      "id": null,
    });
    http.Response response = await http.post(_url + "/posts",
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body: corpo);
    print(response.statusCode.toString());
    print(response.body);
    print("FIM");
  }

  _put() async {
    var body = json.encode(
     { "userId": 300,
        "body": "PQP",
        "title": "Canequinha"
     }
    );
    http.Response response = await http.put(_url + "/posts/3",
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: body
    );
    print(response.statusCode.toString());
    print(response.body);
    print("FIM");

  }

  _patch() async {
    var body = json.encode(
      {
        "body": "hehehe"
      }
    );
    http.Response response = await http.patch(_url+"/posts/4",
    headers: {"Content-type": "application/json; charset=UTF-8"},
    body: body
    );
    print(response.statusCode.toString());
    print(response.body);
    print("FIM");
  }

  _delete() async {
    http.Response response = await http.delete(_url+"/posts/5");
    print(response.statusCode.toString());
    print(response.body);
    print("FIM");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Future ListView"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => _post(),
                    child: Text("Salvar"),
                  ),
                  RaisedButton(
                    onPressed: ()=> _patch(),
                    child: Text("Atualizar"),
                  ),
                  RaisedButton(
                    onPressed: ()=> _delete(),
                    child: Text("Deletar"),
                  )
                ],
              ),
              //futureBuilder, para usar uma ListView com outros widgets temos que usar o Expanded
              Expanded(
                child: FutureBuilder<List<Post>>(
                  future: _recuperaDados(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        break;
                      case ConnectionState.active:
                        break;
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          print("deu merda");
                        } else {
                          print("não deu merda");
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              List<Post> lista = snapshot.data;
                              Post post = lista[index];
                              return ListTile(
                                title: Text(post.id.toString()),
                                subtitle: Text(post.body),
                              );
                            },
                          );
                        }
                        break;
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
