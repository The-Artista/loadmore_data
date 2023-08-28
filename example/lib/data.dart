
import 'package:dio/dio.dart';
import 'package:example/model.dart';

final dio = Dio();

Future<CharactersRes> initCharacters() async {
  final response = await dio.get('https://rickandmortyapi.com/api/character/?page=1');
  return CharactersRes.fromJson(response.data);
}

Future<CharactersRes> nextCharacters(int index) async {
  final response = await dio.get('https://rickandmortyapi.com/api/character/?page=$index');
  return CharactersRes.fromJson(response.data);
}
