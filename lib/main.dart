import 'package:book_store/provider.dart';
import 'package:flutter/material.dart';

import 'books.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BooksProvider.instance.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    List<Books> books =[];
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            TextEditingController authorinput = TextEditingController();
            TextEditingController nameinput = TextEditingController();
            TextEditingController urlinput = TextEditingController();
            await showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15.0),
                  ),
                ),
                context: context, builder: (context){
                  return SizedBox(
                    height: 270,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              TextField(
                                controller: nameinput,
                                decoration:
                                const InputDecoration(label: Text('Book Title')),
                              ),
                              TextField(
                                controller: authorinput,
                                decoration:
                                const InputDecoration(label: Text('Book Author')),
                              ),
                              TextField(
                                controller: urlinput,
                                decoration:
                                const InputDecoration(label: Text('Book Cover URL')),
                              ),
                            ],
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize:const Size (500,50),
                                  backgroundColor: Colors.blue,
                                  ),
                              onPressed: (){
                                BooksProvider.instance.insertBook(Books(
                                    name: nameinput.text,
                                    author: authorinput.text,
                                    image: urlinput.text,
                                    ));
                                print(books);
                                Navigator.pop(context);
                              }, child: const Text('ADD', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),)
                        ],
                      ),
                    ),
                  );
            });
          },child: const Icon(Icons.add, size: 50,),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Available Books'),
        ),
        body: FutureBuilder<List<Books>>(
          future: BooksProvider.instance.getAllBooks(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {
              books = snapshot.data!;
            }
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                Books book = books[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Container(height:50, width:50,child: Image.network(book.image, fit: BoxFit.cover)),
                    trailing: IconButton(onPressed: () {
                      if (book.id != null) {
                         BooksProvider.instance.deleteBook(book.id!);
                      }
                      print(books);
                      setState(() {});
                    }, icon: const Icon(Icons.delete_forever),),
                    title: Text(
                      book.name, style: const TextStyle(fontWeight: FontWeight
                        .bold),),
                    subtitle: Text(book.author),
                  ),
                );
              },
            );
          }),
    ));
  }
}
