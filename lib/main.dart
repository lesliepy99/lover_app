import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef void ItemAddCallback(WishItem i);

class WishItem {
  const WishItem({this.title,this.content});
  final String title;
  final String content;
}
class Arguments {
  final List<WishItem> item;
  final ItemAddCallback itemAdder;
  Arguments(this.item, this.itemAdder);
}
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => Menu(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/wishlist': (context) => WishList(),
          '/inputtext': (context) => InputText(),
        },

    );
  }
}
class Menu extends StatefulWidget {
  Menu({Key key, this.items}) : super(key: key);
  final List<WishItem> items;
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<WishItem> items = List<WishItem>();
  void itemAdder(WishItem i){
    setState(() {
      items.add(i);
    });
  }
  @override
  Widget build(BuildContext context) {
    int i = items.length;

    debugPrint("Menu:$i");
    return Scaffold(
        appBar: AppBar(
          title: Text("Lover Space"),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              child: ListTile(title: Text('我们的愿望清单'),
                onTap: (){
                  Navigator.pushNamed(context,
                      '/wishlist',
                  arguments: Arguments(items,itemAdder) );
                },
              ),
            ),
          ],
        )
    );
  }
}




class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    debugPrint("Inside wishlist");
    final Arguments args = ModalRoute.of(context).settings.arguments;
    final List<WishItem> items = args.item;
    final ItemAddCallback itemAdder = args.itemAdder;
    int i = items.length;
    debugPrint("$i");
    return Scaffold(
      appBar: AppBar(
        title: Text("我们的愿望清单"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: items.map((WishItem i) {
          return ItemLists(
            wishitem: i,
            itemAdder:itemAdder,
          );
        }).toList(),

      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: ()async{
            await Navigator.pushNamed(context,
                '/inputtext',
                arguments: itemAdder);
            setState(() {

            });
          },
          label: Text("新加愿望"),
          icon: Icon(Icons.add),
          backgroundColor: Colors.pink

      ),
    );
  }
}




class ItemLists extends StatelessWidget{
  ItemLists({this.wishitem,this.itemAdder})
      : super(key: ObjectKey(wishitem));

  final WishItem wishitem;
  final ItemAddCallback itemAdder;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {

      },
      title: Text(wishitem.title),

    );
  }
}

class InputText extends StatelessWidget{

  final title_controller = TextEditingController();
  final content_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ItemAddCallback itemAdder = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("请输入你的愿望")
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(children: <Widget>[
          TextField(
            controller: title_controller,
            decoration: InputDecoration(
              labelText: "愿望标题",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: content_controller,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: "愿望内容",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(2)
                )
              ),
            )
          )

        ],
        ),
      ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            final string1 = title_controller.text;
            debugPrint("title:$string1");
            WishItem i = WishItem(title: title_controller.text,content: content_controller.text);
            itemAdder(i);
            Navigator.pop(context);
          },
          label: Text("提交"),
          icon: Icon(Icons.send),
          backgroundColor: Colors.pink,
        )
    );
  }
}