import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title of Application',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }

}

class MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  Widget _homePage = HomePage();
  Widget _searchPage = SearchPage();
  Widget _shelfPage = ShelfPage();
  Widget _myProfile = MyProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  this.getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: this.selectedIndex,
        backgroundColor: Colors.amber,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Главная"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Поиск"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            title: Text("Полка"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Профиль"),
          )
        ],
        onTap: (int index) {
          this.onTapHandler(index);
        },
      ),
    );
  }

  Widget getBody( )  {
    if(this.selectedIndex == 0) {
      return this._homePage;
    } else if(this.selectedIndex==1) {
      return this._searchPage;
    } else if(this.selectedIndex==2) {
      return this._shelfPage;
    }
    else {
      return this._myProfile;
    }
  }

  void onTapHandler(int index)  {
    this.setState(() {
      this.selectedIndex = index;
    });
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Подборки для Вас",
                          style: TextStyle(color: Colors.black54,
                          fontSize: 17, fontWeight: FontWeight.w700 )
                          ),
        backgroundColor: Colors.white,
      )
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Поиск",
              style: TextStyle(color: Colors.black54,
                  fontSize: 17, fontWeight: FontWeight.w700 )
          ),
          backgroundColor: Colors.white,
        )
    );
  }
}

class ShelfPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Книжная полка",
              style: TextStyle(color: Colors.black54,
                  fontSize: 17, fontWeight: FontWeight.w700 )
          ),
          backgroundColor: Colors.white,
        )
    );
  }
}

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return User(name: "anychka", id: 0, im: Image.asset("assets/images/photo.jpg"));
  }
}

class User extends StatefulWidget{

  String name = "";
  int id = 0;
  Image im = Image.asset("", fit: BoxFit.contain);

  User({ Key? key, required this.name, required this.id, required this.im}) : super(key: key);
  @override
  _UserState createState() => _UserState(this.name, this.id, this.im);
}
class _UserState extends State<User>{

  String name = "";
  int id = 0;
  Image im = Image.asset("", fit: BoxFit.contain);


      _UserState(this.name, this.id, this.im);

  @override
  Widget build(BuildContext context) {
    final List<String> rows = ["Прочитанные книги", "Цели по чтению", "Заказать доставку"];

    return Column(
      children: [
        Expanded(child:Column(
          children: [
            Container(child: im, width: 320, height: 320, margin: EdgeInsets.fromLTRB(50, 30, 50, 0), alignment: Alignment.center),
            Text("$name", style: TextStyle(fontSize: 27), textAlign: TextAlign.center, softWrap: true)
      ])
    ),
        Expanded(child: Column(
          children: [
            Row(children: <Widget>[
              Expanded(
                  child: Container(child: Text('Прочитанные книги', style: TextStyle(fontSize: 25), textAlign: TextAlign.left),
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38)
                    ),
                  )
              ),
            ]
            ),
            Row(children: <Widget>[
              Expanded(
                  child: Container(child: Text('Цели по чтению', style: TextStyle(fontSize: 25), textAlign: TextAlign.left),
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38)
                    ),
                  )
              ),
            ]
            ),
            Row(children: <Widget>[
              Expanded(
                  child: Container(child: Text('Заказать доставку', style: TextStyle(fontSize: 25), textAlign: TextAlign.left),
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38)
                    ),
                  )
              ),
            ]
            )
          ]
        ))

      ]
    );
  }

}
