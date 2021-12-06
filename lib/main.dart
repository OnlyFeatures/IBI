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
  Widget _searchPage = SearchList();
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

class User extends StatefulWidget {

  String name = "";
  int id = 0;
  Image im = Image.asset("", fit: BoxFit.contain);


  User({ Key? key, required this.name, required this.id, required this.im}) : super(key: key);
  @override
  _UserState createState() => _UserState(this.name, this.id, this.im);
}

class _UserState extends State<User> {

  String name = "";
  int id = 0;
  Image im = Image.asset("", fit: BoxFit.contain);

      _UserState(this.name, this.id, this.im);

  @override
  Widget build(BuildContext context) {

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
                  child: InkWell(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => BooksRead()));},
                      child: Container(child: Text('Прочитанные книги', style: TextStyle(fontSize: 25), textAlign: TextAlign.left),
                        padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                        margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black38),
                        ),
                      )
                  ),
              ),
            ]
            ),
            Row(children: <Widget>[
              Expanded(
                  child: InkWell(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ReadGoals()));},
                    child: Container(child: Text('Цели по чтению', style: TextStyle(fontSize: 25), textAlign: TextAlign.left),
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                      margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38)
                    ),
                    )
                  )
              ),
            ]
            ),
            Row(children: <Widget>[
              Expanded(
                  child: InkWell(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SearchList()));},
                    child: Container(child: Text('Заказать доставку', style: TextStyle(fontSize: 25), textAlign: TextAlign.left),
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                      margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38)
                      ),
                    )
                  )
              ),
            ]
            )
          ]
        )
        )
      ]
    );
  }

}

class BooksRead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Прочитанные книги'),
            backgroundColor: Colors.amber),
        body: Center(child: Text('Вывести массив прочитанных книг через ListTile', style: TextStyle(fontSize: 25)))
    );
  }
}

class ReadGoals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Цели'),
          backgroundColor: Colors.amber),
      body: Center(child: Text('Вывести массив целей по чтению через ListTile', style: TextStyle(fontSize: 25)))
    );
  }
}

class OrderPage extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Заказать'),
            backgroundColor: Colors.amber),
        body: Container(child: Column(children: <Widget>[
          TextField(decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: "ФИО",
          helperText: "Фамилия, Имя, Отчество",
        )),
          TextField(decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Номер телефона",
            helperText: "+7 (XXX) XXX-XX-XX",
          )),
          TextField(decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Адрес",
          ))
        ],
    ),
        margin: EdgeInsets.fromLTRB(10,30,10,0)));
    }
}

class Book extends StatefulWidget {

  String name = "";
  int price = 0;
  Image im = Image.asset("", fit: BoxFit.contain);

  Book({ Key? key, required this.name, required this.price, required this.im}) : super(key: key);
  @override
  _BookState createState() => _BookState(this.name, this.price, this.im);
}

class _BookState extends State<Book> {

  String name = "";
  int price = 0;
  Image im = Image.asset("", fit: BoxFit.contain);

  _BookState(this.name, this.price, this.im);

  @override
  Widget build(BuildContext context) {
    return Text('book');
  }

  }

class SearchList extends StatefulWidget {
  SearchList({ Key? key }) : super(key: key);
  @override
  _SearchListState createState() => new _SearchListState();

}

class _SearchListState extends State<SearchList> {
  Widget appBarTitle = new Text("Поиск", style: new TextStyle(color: Colors.white),);
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<Book> _list = <Book>[];
  bool _IsSearching = true;
  String _searchText = "";

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          String _searchText = "";
        });
      }
      else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    init();

  }

  void init() {
    _list = books;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: appBarTitle,
          backgroundColor: Colors.deepOrangeAccent,
          actions: <Widget>[
            new IconButton(icon: actionIcon, onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(Icons.close, color: Colors.white,);
                  this.appBarTitle = new TextField(
                    controller: _searchQuery,
                    style: new TextStyle(
                      color: Colors.white,

                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)
                    ),
                  );
                  _handleSearchStart();
                }
                else {
                  _handleSearchEnd();
                }
              });
            },),
          ]
      ),
      key: key,
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: _IsSearching ? _buildSearchList() : _buildList(),
      ),
    );
  }

  List<ChildItem> _buildList() {
    return _list.map((contact) => new ChildItem(contact)).toList();
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => new ChildItem(contact))
          .toList();
    }
    else {

      List<Book> _searchList = <Book>[];
      for (int i = 0; i < _list.length; i++) {
        String name = _list.elementAt(i).name;
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(_list.elementAt(i));
        }
      }
      return _searchList.map((contact) => new ChildItem(contact))
          .toList();
    }
  }


  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.white,);
      this.appBarTitle =
      new Text("Search Sample", style: new TextStyle(color: Colors.white),);
      _IsSearching = false;
      _searchQuery.clear();
    });
  }

}

class ChildItem extends StatelessWidget {
  final Book book;
  ChildItem(this.book);
  @override
  Widget build(BuildContext context) {
    return new ListTile(title: new Container(child: InkWell(child: Row(children: <Widget>[
      Expanded(child: Text(this.book.name)),
      Expanded(child: Container(child: this.book.im, width: 70, height: 140))]
    ),
        onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));}),
        padding: EdgeInsets.fromLTRB(30, 0, 0, 0)));
  }
}

final List<Book> books = <Book>[Book(name: "Catch-22",price: 406, im: Image.asset("assets/images/heller.jpg")),
  Book(name: "The Catcher in the Rye", price: 350, im: Image.asset("assets/images/rye.jpg")),
  Book(name: "The Call of Cthulhu", price: 310, im: Image.asset("assets/images/cthulhu.jpg")),
  Book(name: "One Flew Over the Cuckoo's Nest",price: 327, im: Image.asset("assets/images/kizy.jpg")),
  Book(name: "The Cherry Orchard", price: 253, im: Image.asset("assets/images/chehov.jpg"))];