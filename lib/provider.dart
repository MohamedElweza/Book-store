import 'package:book_store/books.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String columnId = 'id';
final String columnName = 'name';
final String columnAuthor = 'author';
final String columnImage = 'image';
final String bookTable = 'book_table';

class BooksProvider {
  late Database db;

  static final BooksProvider instance = BooksProvider._internal();

  factory BooksProvider() {
    return instance;
  }

  BooksProvider._internal();

  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'books.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
          create table $bookTable (
          $columnId integer primary key autoincrement,
          $columnName text not null,$columnAuthor text not null,
          $columnImage text not null
          )
          ''');
    });
  }

  Future<Books> insertBook(Books book) async {
    book.id = await db.insert(bookTable, book.toMap());
    return book;
  }

  Future<int> deleteBook(int id) async {
    return await db.delete(bookTable, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Books>> getAllBooks() async {
    List<Map<String, dynamic>> bookMaps = await db.query(bookTable);
    if (bookMaps.isEmpty) {
      return [];
    } else {
      List<Books> books = [];
      for (var element in bookMaps) {
        books.add(Books.fromMap(element));
      }
      return books;
    }
  }

  Future close() async => db.close();
}
