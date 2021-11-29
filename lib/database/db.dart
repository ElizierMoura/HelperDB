import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

// Class DB
// * para conectar no banco
// * para atualizar o banco
// * para inserir e manipular o banco
class DB {
  // Construtor privado
  DB._();

  // Instancia de DB
  static final DB instance = DB._();
  // Instancia do SQLite
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(
        await getDatabasesPath(),
        'lico.db',
      ),
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Quando a db for criada
  _onCreate(db, versao) async {
    // Tudo que vai ser criado no banco
    // Vamos detalhar aqui

    // !Criar uma table para as listas de compras que precisa ter
    // * Código da lista
    // * Nome da lista
    // * Finalizada ou não
    await db.execute(_lista_compra);

    // !Criar uma table de produtos e a mesma precisa conter
    // * Código do produto
    // * Nome do produto
    // * Quantidade do produto
    // * Valor do produto - o último valor atualizado do produto
    await db.execute(_produto);

    // !Criar uma table para usar um produto em uma lista
    // * Código da seleção de produto e lista
    // * Código da lista
    // * Código do produto
    // * Se está comprado ou não
    await db.execute(_lista_produto);
    await db.insert('lista_compra', {'lc_nome': "Mercado", "lc_finalizado": 0});
  }

  // * Cria tabela onde ficam as listas das compras
  String get _lista_compra => '''
    CREATE TABLE lista_compra (
      lc_codigo INTEGER PRIMARY KEY AUTOINCREMENT,
      lc_nome TEXT NOT NULL,
      lc_finalizado integer NOT NULL
    )
  ''';

  // * Cria tabela onde ficam os produtos
  String get _produto => '''
    CREATE TABLE produto (
      pr_codigo INTEGER PRIMARY KEY AUTOINCREMENT,
      pr_nome TEXT NOT NULL,
      pr_quantidade REAL NOT NULL,
      pr_valor REAL NOT NULL
    )
  ''';

  // !Criar uma table para usar um produto em uma lista
  // * Código da seleção de produto e lista
  // * Código da lista
  // * Código do produto
  // * Se está comprado ou não
  String get _lista_produto => '''
    CREATE TABLE lista_produto (
      lp_codigo INTEGER PRIMARY KEY AUTOINCREMENT,
      pr_codigo TEXT NOT NULL,
      lc_codigo REAL NOT NULL,
      lp_comprado INTEGER not null,
      FOREIGN KEY(pr_codigo) REFERENCES produto(pr_codigo)
    )
  ''';
}
