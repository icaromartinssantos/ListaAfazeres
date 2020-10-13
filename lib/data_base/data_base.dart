import 'package:moor_flutter/moor_flutter.dart';
import 'package:moor/moor_web.dart';
part 'data_base.g.dart';

@UseMoor(tables: [Tarefas])
class DataBase extends _$DataBase {
  DataBase() : super(WebDatabase('db'));
  int get schemaVersion => 1;
  Future<List<Tarefa>> obtemTodasTarefas() => select(tarefas).get();
  Stream<List<Tarefa>> observaTarefas() => select(tarefas).watch();
  Future insereTarefa(Tarefa tarefa) => into(tarefas).insert(tarefa);
  Future deletaTarefa(Tarefa tarefa) => delete(tarefas).delete(tarefa);
}

class Tarefas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
}
