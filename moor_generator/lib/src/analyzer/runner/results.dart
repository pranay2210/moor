import 'package:meta/meta.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:moor_generator/moor_generator.dart';
import 'package:moor_generator/src/analyzer/runner/file_graph.dart';
import 'package:moor_generator/src/model/sql_query.dart';
import 'package:sqlparser/sqlparser.dart';

abstract class FileResult {
  final List<MoorTable> declaredTables;

  FileResult(this.declaredTables);
}

class ParsedDartFile extends FileResult {
  final LibraryElement library;

  final List<Dao> declaredDaos;
  final List<Database> declaredDatabases;

  Iterable<BaseMoorAccessor> get dbAccessors =>
      declaredDatabases.cast<BaseMoorAccessor>().followedBy(declaredDaos);

  ParsedDartFile(
      {@required this.library,
      List<MoorTable> declaredTables = const [],
      this.declaredDaos = const [],
      this.declaredDatabases = const []})
      : super(declaredTables);
}

class ParsedMoorFile extends FileResult {
  final ParseResult parseResult;
  MoorFile get parsedFile => parseResult.rootNode as MoorFile;

  final List<ImportStatement> imports;
  final List<DeclaredQuery> queries;

  List<SqlQuery> resolvedQueries;
  Map<TableInducingStatement, MoorTable> tableDeclarations;
  Map<ImportStatement, FoundFile> resolvedImports;

  ParsedMoorFile(this.parseResult,
      {List<MoorTable> declaredTables = const [],
      this.queries = const [],
      this.imports = const [],
      this.tableDeclarations = const {}})
      : super(declaredTables);
}
