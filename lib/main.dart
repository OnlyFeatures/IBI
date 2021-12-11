import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
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
      home: AuthorisationPage(),
    );
  }
}

class AuthorisationPage extends StatefulWidget{
  AuthorisationPage({Key? key}) : super(key: key);

  @override
  _AuthorisationPageState createState() => _AuthorisationPageState();
}

class _AuthorisationPageState extends State<AuthorisationPage>{
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AuthService _authService = AuthService();

  String _email = "";
  String _password = "";
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {

    Widget _logo(){
      return Padding(
          padding: EdgeInsets.only(top: 100),
          child: Container(
              child: Align(
                  child: Text('ProBook', style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.deepOrange))
              )
          )
      );
    }

    Widget _input(Icon icon, String hint, TextEditingController controller, bool obscure){
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
              hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey.shade800),
              hintText: hint,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 3)
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1)
              ),
              prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: IconTheme(
                      data: IconThemeData(color: Colors.black),
                      child: icon
                  )
              )
          ),
        ),
      );
    }

    Widget _button(String text, void fun()){
      return RaisedButton(
        splashColor: Colors.white,
        highlightColor: Colors.white,
        color: Colors.deepOrange,
        child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)
        ),
        onPressed: () {
          fun();
        },
      );
    }

    Widget _form(String label, void func()){
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 20, top: 10),
                child: _input(Icon(Icons.email), "email", _emailController, false)
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: _input(Icon(Icons.lock), "password", _passwordController, true)
            ),
            SizedBox(height: 20, ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: _button(label, func)
                )
            )
          ],
        ),
      );
    }

    void _loginButtonAction() async{
      _email = _emailController.text;
      _password = _passwordController.text;

      if(_email.isEmpty || _password.isEmpty) return;

      User user = await _authService.signInWithEmailAndPassword(_email.trim(), _password.trim());
      if(user == null){
        Fluttertoast.showToast(
            msg: "Can't Sign in you! Please check your email/password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      else{
        _emailController.clear();
        _passwordController.clear();
        if(_password.contains("courier")){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CourierPage()));
        }
        else{
          LocalUser u = LocalUser(_email.trim());
          users.add(u);
          index = users.indexOf(u);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(user: u)));
        }
      }
    }

    void _registerButtonAction() async{
      _email = _emailController.text;
      _password = _passwordController.text;

      if(_email.isEmpty || _password.isEmpty) return;

      User user = await _authService.registerWithEmailAndPassword(_email, _password);
      if(user == null){
        Fluttertoast.showToast(
            msg: "Can't Register you! Please check your email/password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
      else{
        _emailController.clear();
        _passwordController.clear();
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            _logo(),
            (
                showLogin
                    ? Column(
                  children: <Widget>[
                    _form('LOGIN', _loginButtonAction),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                          child: Text('Not registered yet? Register!', style: TextStyle(fontSize: 20, color: Colors.black)),
                          onTap:(){
                            setState((){
                              showLogin = false;
                            });
                          }
                      ),
                    )
                  ],
                )
                    : Column(
                  children: <Widget>[
                    _form('REGISTER', _registerButtonAction),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                          child: Text('Already registered? Login!', style: TextStyle(fontSize: 20, color: Colors.black)),
                          onTap:(){
                            setState((){
                              showLogin = true;
                            });
                          }
                      ),
                    )
                  ],
                )
            )
          ],
        )
    );
  }
}

class AuthService {

  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await  _fAuth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return User.fromFirebase(user);
    }
    catch(e){
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    print(email);
    print(password);
    try{
      AuthResult result = await  _fAuth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return User.fromFirebase(user);
    }
    catch(e){
      print(e);
      return null;
    }
  }

  Future logOut() async{
    await _fAuth.signOut();
  }

  Stream<User?> get currentUser{
    return _fAuth.onAuthStateChanged.map((FirebaseUser user) => user != null ? User.fromFirebase(user) : null);
  }
}

class Book extends StatefulWidget {

  String name = "";
  String author = "";
  String note = "";
  int price = 0;
  Image im = Image.asset("", fit: BoxFit.contain);

  Book({ Key? key, required this.name, required this.author, required this.price, required this.im, required this.note}) : super(key: key);
  @override
  _BookState createState() => _BookState(this.name, this.author, this.price, this.im, this.note);
}

class _BookState extends State<Book> {

  String name = "";
  int price = 0;
  Image im = Image.asset("", fit: BoxFit.contain);
  String author = "";
  String note = "";

  _BookState(this.name, this.author, this.price, this.im, this.note);

  @override
  Widget build(BuildContext context) {
    return Text('book');
  }

}

class BooksRead extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Прочитанные книги'),
            backgroundColor: Colors.amber),
        body: Center(child: Text('Раздел пока недоступен', style: TextStyle(fontSize: 25)))
    );
  }
}

class BookPage extends StatelessWidget {
  final Book book;
  BookPage(this.book);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('${book.name}'),
            backgroundColor: Colors.amber),
        body: Column(
          children: <Widget>[
            Expanded(child: Container(child: book.im, margin: EdgeInsets.fromLTRB(0,30,0,0), alignment: Alignment.center), flex: 5),
            Expanded(child: Column(children: <Widget>[
              Text("${book.author}", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25)),
              Text(book.name,  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25), textAlign: TextAlign.center),
              Text("Цена: ${book.price}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25)),
              Text("${book.note}", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),textAlign: TextAlign.center),
            ]), flex: 3),
            Expanded(child: Container(child: ElevatedButton(
                child: Text("Заказать", style: TextStyle(fontSize: 22)),
                style: ElevatedButton.styleFrom(primary: Colors.deepOrangeAccent),
                onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage(book: this.book)));})), flex: 1)],
        )
    );
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
        onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => BookPage(book)));}),
        padding: EdgeInsets.fromLTRB(30, 0, 0, 0)));
  }
}

class CourierPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Доступные заказы'),
            backgroundColor: Colors.amber),
        body: Column(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: orders.length,
                    separatorBuilder: (BuildContext context, int index) => Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      if(orders.length != 0) {
                        return ListTile(
                            onTap: () {
                              orders.remove(orders[index]);
                            },
                            title: Text("${orders[index].fullName}, ${orders[index].book.name}, ${orders[index].book.price}", style:TextStyle(fontSize: 22)),
                            leading: Icon(Icons.face),
                            trailing: Icon(Icons.phone),
                            subtitle: Text("Адрес: ${orders[index].adress}, ${orders[index].number}")
                        );
                      }
                      else{
                        return AlertDialog(
                          title: Text('К сожалению, доступных заказов пока нет'),
                          content: const Text(''),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(user: users[index])));
                              },
                            ),
                          ],
                        );
                      }
                    }
                ),
              ),
            ]
        )
    );
  }
}

class Fantastics extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Фантастика'),
            backgroundColor: Colors.amber),
        body:  Container(child:InkWell(child: Row(children: <Widget>[
                    Expanded(child: Text(books[3].name)),
                    Expanded(child: Container(
                        child: books[3].im, width: 70, height: 140))
                  ]
                  ),
          onTap:() {Navigator.push(context, MaterialPageRoute(builder: (context) => BookPage(books[3])));}
        ),padding: const EdgeInsets.fromLTRB(50, 10, 0, 10)),);
  }
}

class ForeignLit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Зарубежная литература'),
            backgroundColor: Colors.amber),
        body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: 3,
            separatorBuilder: (BuildContext context, int index1) => Divider(),
            itemBuilder: (BuildContext context, int index1) {
              return ListTile(title: new Container(
                  child: InkWell(child: Row(children: <Widget>[
                    Expanded(child: Text(books[index1].name)),
                    Expanded(child: Container(
                        child: books[index1].im, width: 70, height: 140))
                  ]
                  ), onTap:() {Navigator.push(context, MaterialPageRoute(builder: (context) => BookPage(books[index1])));}),
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 0)));
            }));
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Подборки",
              style: TextStyle(color: Colors.black54,
                  fontSize: 17, fontWeight: FontWeight.w700 )
          ),
          backgroundColor: Colors.white,
        ),
      body: Container(child:Column(children: <Widget>[
        Expanded(child: InkWell(child: Text("Зарубежная литература",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
            onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context) => ForeignLit()));})),
        Expanded(child: InkWell(child: Text("Отечественная литература",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
            onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context) => NativeLit()));})),
        Expanded(child: InkWell(child: Text("Фантастика",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300), textAlign: TextAlign.center),
            onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context) => Fantastics()));}))]),
          margin: EdgeInsets.fromLTRB(0, 60, 0, 0)));
  }
}

class MyHomePage extends StatefulWidget {
  LocalUser user = LocalUser("");
  MyHomePage({Key? key, required this.user}) : super(key: key);

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

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return myUser(email: users[index].email);
  }
}

class myUser extends StatefulWidget {

  String email = "";

  myUser({ Key? key, required this.email}) : super(key: key);

  @override
  _myUserState createState() => _myUserState(this.email);
}

class _myUserState extends State<myUser> {

  String email = "";

  _myUserState(this.email);

  @override
  Widget build(BuildContext context) {

    return Column(
        children: [
          Expanded(child:Column(
              children: [
                Container(child: im, width: 320, height: 320, margin: EdgeInsets.fromLTRB(50, 30, 50, 0), alignment: Alignment.center),
                Text("$email", style: TextStyle(fontSize: 27), textAlign: TextAlign.center, softWrap: true)
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
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                          onTap: () {
                            AuthService auth = AuthService();
                            auth.logOut();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AuthorisationPage()));
                          },
                          child: Container(child: Text('Выйти', style: TextStyle(fontSize: 25), textAlign: TextAlign.left),
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38)
                            ),
                          )
                      )
                  ),
                ]
                ),
              ]
          )
          )
        ]
    );
  }

}

class NativeLit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Отечественная литература'),
          backgroundColor: Colors.amber),
      body:  Container(child:InkWell(child: Row(children: <Widget>[
        Expanded(child: Text(books[4].name)),
        Expanded(child: Container(
            child: books[4].im, width: 70, height: 140))
      ]
      ), onTap:() {Navigator.push(context, MaterialPageRoute(builder: (context) => BookPage(books[4])));}),
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0))
        );
  }
}

class OrderPage extends StatefulWidget {

  final Book book;

  OrderPage({ Key? key, required this.book}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  String fullName = "";
  String adress = "";
  String number = "";

  _fullName(String text){
    setState(() =>fullName = text);
  }

  _adress(String text){
    setState(() =>adress = text);
  }

  _number(String text){
    setState(() =>number = text);
  }

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
          ),
              onChanged: _fullName),
          TextField(decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Номер телефона",
            helperText: "+7 (XXX) XXX-XX-XX",
          ),
              onChanged: _number),
          TextField(decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Адрес",
          ),
              onChanged: _adress),
          Center(child: InkWell(child:Text("Публичная оферта"), onTap:() => launch('https://docs.google.com/document/d/1i1yBR-_F4PKGKxFbn52C76XlInhnD7e5LHUKGY8Hiio/edit#heading=h.gjdgxs'))),
          Container(child: Row(children: <Widget>[
            Expanded(child: Column(children: <Widget>[Text(widget.book.name),
              Text("Цена: ${widget.book.price}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))])),
            Expanded(child: Container(child: widget.book.im, width: 70, height: 140))
          ]
          ),
              margin: EdgeInsets.fromLTRB(20,100,0,0)),
          Container(child: ElevatedButton(
              child: Text("Заказать", style: TextStyle(fontSize: 22)),
              style: ElevatedButton.styleFrom(primary: Colors.deepOrangeAccent),
              onPressed:(){
                Order order = new Order(fullName, adress, number, widget.book);
                orders.add(order);
                showDialog<void>(context: context, builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Ваш заказ успешно принят в работу, ожидайте звонка от курьера. '
                        'Оплата доступна картой или наличными при получении'),
                    content: const Text(''),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(user: users[index])));
                        },
                      ),
                    ],
                  );
                },
                );
              }
          ),
              margin: EdgeInsets.fromLTRB(0,70,0,0))
        ],
        ),
            margin: EdgeInsets.fromLTRB(10,30,10,0)));
  }
}

class ReadGoals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Цели'),
            backgroundColor: Colors.amber),
        body: Center(child: Text('Раздел пока недоступен', style: TextStyle(fontSize: 25)))
    );
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
      new Text("Поиск", style: new TextStyle(color: Colors.white),);
      _IsSearching = false;
      _searchQuery.clear();
    });
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
        ),
      body: Center(child: Text("Раздел пока недоступен", style: TextStyle(fontSize: 25))));
  }
}

class User {
  String id = "";

  User.fromFirebase(FirebaseUser user){
    id = user.uid;
  }
}

class LocalUser {
  String email;

  LocalUser(this.email);
}

class Order {
  String fullName;
  String adress;
  String number;
  Book book;

  Order(this.fullName, this.adress, this.number, this.book);
}

final List<Order> orders = <Order>[];

final List<LocalUser> users = <LocalUser>[];

final Image im = Image.asset("assets/images/photo.jpg");

int index = 0;

final List<Book> books = <Book>[Book(name: "Поправка-22", author: "Джозеф Хеллер", price: 406, im: Image.asset("assets/images/heller.jpg"), note:"Эта оригинальная история о службе летчиков ВВС США в период Второй мировой войны полна несуразных ситуаций, не менее несуразных смешных диалогов, безумных персонажей и абсурдных бюрократических коллизий, связанных с некой не существующей на бумаге, но от этого не менее действенной «поправкой-22» в законе."),
  Book(name: "Над пропастью во ржи", author: "Дж. Д. Сэлинджер", price: 350, im: Image.asset("assets/images/rye.jpg"), note: "Единственный роман Сэлинджера, «Над пропастью во ржи» стал переломной вехой в истории мировой литературы. И название романа, и имя его главного героя Холдена Колфилда сделались кодовыми для многих поколений молодых бунтарей – от битников и хиппи до современных радикальных молодежных движений."),
  Book(name: "Пролетая над гнездом кукушки",author: "Кен Кизи",price: 327, im: Image.asset("assets/images/kizy.jpg"), note:"«Пролетая над гнездом кукушки» – это грубое и опустошительно честное изображение границ между здравомыслием и безумием. Книга продолжает жить и не утратила прежней сумасшедшей популярности в наши дни."),
  Book(name: "Зов Ктулху", author: "Говард Лавкрафт",price: 310, im: Image.asset("assets/images/cthulhu.jpg"), note: "Ктулху, Дагон, Йог-Сотот и многие другие божества, придуманные Говардом Лавкрафтом в 1920-е годы, приобрели впоследствии такую популярность, что сотни творцов фантастики, включая Нила Геймана и Стивена Кинга, до сих пор продолжают расширять его мифологию. Каждый монстр же в лавкрафтовском мире олицетворяет собой одну из бесчисленных граней хаоса. "),
  Book(name: "Вишневый сад", author: "Антон Чехов", price: 253, im: Image.asset("assets/images/chehov.jpg"), note: "«Вишнёвый сад» – комедия в четырёх действиях Антона Павловича Чехова. Пьеса написана в 1903 году, впервые поставлена 17 января 1904 года в Московском художественном театре. Уникальная радиопостановка, записанная в 1949 году, с участием актрисы Ольги Книппер-Чеховой, жены писателя.")];



