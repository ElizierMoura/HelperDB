import 'package:flutter/material.dart';
import 'package:lico/database/db.dart';
import 'package:lico/models/lista_compras.dart';
import 'package:lico/models/produto.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

class ListaRepository extends ChangeNotifier {
  late Database db;
  List<ListaComprasResource> _listas_compras = [];

  List<ListaComprasResource> get listasCompras => _listas_compras;

  cadastrar(ListaComprasResource novaLista) async {
    int id = await db.insert(
        'lista_compra', {'lc_nome': novaLista.nome, "lc_finalizado": 0});
    novaLista.codigoLista = id;
    this._listas_compras.add(novaLista);

    notifyListeners();
  }

  List<ProdutoResource> _produtos = [];

  List<ProdutoResource> get listarProdutos => _produtos;

  cadastrarProduto(ProdutoResource novoProduto) async {
    int id = await db.insert('produto', {
      'pr_nome': novoProduto.nome,
      'pr_quantidade': novoProduto.quantidade,
      'pr_valor': novoProduto.valor,
    });
    novoProduto.codigoProduto = id;
    this._produtos.add(novoProduto);

    notifyListeners();
  }

  deletar(String codigoLista) async {
    await db.rawDelete(
        'DELETE FROM lista_compra WHERE lc_codigo = ?', [codigoLista]);

    for (var i = 0; i < _listas_compras.length; i++) {
      if (this._listas_compras[i].codigoLista.toString() == codigoLista) {
        this._listas_compras.removeAt(i);
      }
    }

    notifyListeners();
  }

  ListaRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getListaCompras();
    await _getListaProdutos();
  }

  _getListaCompras() async {
    debugPrint("aaaa");
    db = await DB.instance.database;
    List<Map<String, Object?>> listaCompras = await db.query('lista_compra');

    // ! Adicionar if para listaCompras.length e evitar problemas.
    for (var i = 0; i < listaCompras.length; i++) {
      ListaComprasResource lista = ListaComprasResource(
          codigoLista: int.parse(listaCompras[i]['lc_codigo'].toString()),
          nome: listaCompras[i]['lc_nome'].toString(),
          finalizado: 0);
      this._listas_compras.add(lista);
    }

    notifyListeners();
    debugPrint(listaCompras.toString());
  }

  _getListaProdutos() async {
    db = await DB.instance.database;
    List<Map<String, Object?>> _produtos = await db.rawQuery(
        'SELECT * FROM produto p INNER JOIN lista_produto lp on lp.lp_codigo = p.pr_codigo');

    debugPrint("lista completa");
    debugPrint(_produtos.toString());
    // ! Adicionar if para listaCompras.length e evitar problemas.
    for (var i = 0; i < _produtos.length; i++) {
      ProdutoResource produto = ProdutoResource(
        codigoProduto: int.parse(_produtos[i]['pr_codigo'].toString()),
        nome: _produtos[i]['pr_nome'].toString(),
        quantidade: double.parse(_produtos[i]['pr_quantidade'].toString()),
        valor: double.parse(_produtos[i]['pr_valor'].toString()),
      );
      this._produtos.add(produto);
      // await db.rawDelete('DELETE FROM produto where pr_codigo = ?',
      //     [_produtos[i]["pr_codigo"]]);
    }

    debugPrint(_produtos.toString());

    notifyListeners();
  }

  // Atualiza preço do produto
  atualizarPrecoProduto(int prCodigo, String valorNovo) async {
    db = await DB.instance.database;
    int rowsAffecteds = await db.rawUpdate(
      'UPDATE produto SET pr_valor = ? WHERE pr_codigo = ?',
      [valorNovo, prCodigo],
    );

    // Atauliza o valor no estado atual do app
    for (var i = 0; i < _produtos.length; i++) {
      if (_produtos[i].codigoProduto == prCodigo) {
        this._produtos[i].valor = double.parse(valorNovo);
      }
    }

    notifyListeners();
  }
}
