import 'package:flutter/material.dart';
import 'package:lico/database/db.dart';
import 'package:lico/models/lista_compras.dart';
import 'package:lico/models/produto.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

class ProdutoRepositories extends ChangeNotifier {
  late Database db;

  List<ProdutoResource> _produtos = [];

  List<ProdutoResource> get listarProdutos => _produtos;

  cadastrar(ProdutoResource novoProduto) async {
    int id = await db.insert('produto', {
      'pr_nome': novoProduto.nome,
      'pr_quantidade': novoProduto.quantidade,
      'pr_valor': novoProduto.valor,
    });
    novoProduto.codigoProduto = id;
    this._produtos.add(novoProduto);

    notifyListeners();
  }

  // ListaRepository() {
  //   _initRepository();
  // }

  // _initRepository() async {
  //   await _getListaCompras();
  // }
}
