import 'dart:convert';
import 'package:desafio/models/to_do.dart';
import 'package:desafio/models/user.dart';
import 'package:dio/dio.dart';

class HttpClient {
  static const String _appToken = 'd31ed7c9-ce82-4f74-903a-7500993e8859';
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://mobile-test.redepos.com.br',
  ));

  // durante o signin também é realizado um login para obtermos o token JWT e
  // assim conseguir salvar os dados referente ao usuário (nome e id), pois o
  // login normal só retorna o token JWT e o email, deixando de fora estes
  // outros dados
  static Future<Map<String, dynamic>> signIn(User user) async {
    Response response = await _dio.post(
      '/signup',
      data: {
        'apptoken': _appToken,
        'name': user.name,
        'email': user.email,
        'password': user.password,
      },
    );
    if (Map.of(response.data).keys.toList().contains('error')) {
      return {'success': false, 'error': response.data['error']};
    } else {
      Response loginResponse = await _dio.post('/login', data: {
        'apptoken': _appToken,
        'email': user.email,
        'password': user.password,
      });
      await _dio.post(
        '/setvalue',
        data: {
          'key': user.email,
          'value': json.encode({
            'type': 'user',
            'name': user.name,
            'id': response.data['userid']
          }),
        },
        options: Options(headers: {'token': loginResponse.data['jwttoken']}),
      );
      return {'success': true, 'data': response.data};
    }
  }

  // no método login além de logar é feita a consulta dos dados do usuário que
  // foram armazenadas com o método sign in
  static Future<Map<String, dynamic>> login(User user) async {
    Response response = await _dio.post(
      '/login',
      data: {
        'apptoken': _appToken,
        'email': user.email,
        'password': user.password,
      },
    );
    if (Map.of(response.data).keys.toList().contains('error')) {
      return {'success': false, 'error': response.data['error']};
    } else {
      Response userDataResponse = await _dio.post(
        '/getvalue',
        data: {'key': user.email},
        options: Options(headers: {'token': response.data['jwttoken']}),
      );
      Map<String, dynamic> result = json.decode(userDataResponse.data['value']);
      return {
        'success': true,
        'data': {
          'id': result['id'],
          'tokenJWT': response.data['jwttoken'],
          'name': result['name'],
          'email': user.email,
        }
      };
    }
  }

  static Future<Map<String, dynamic>> createToDo(
      String tokenJWT, ToDo toDo) async {
    Response response = await _dio.post(
      '/setvalue',
      data: {
        'key': toDo.id,
        'value': json.encode({
          'type': toDo.type,
          'title': toDo.title,
          'text': toDo.text,
          'done': toDo.done,
        }),
      },
      options: Options(headers: {'token': tokenJWT}),
    );
    if (Map.of(response.data).keys.toList().contains('error')) {
      return {'success': false, 'error': response.data['error']};
    } else {
      return {'success': true, 'data': response.data};
    }
  }

  static Future<Map<String, dynamic>> listToDos(String tokenJWT) async {
    Response response = await _dio.post(
      '/getalldata',
      options: Options(headers: {'token': tokenJWT}),
    );
    if (Map.of(response.data).keys.toList().contains('error')) {
      return {'success': false, 'error': response.data['error']};
    } else {
      List<Map<String, dynamic>> result = [];
      for (String key in Map.of(response.data['data']).keys.toList()) {
        Map<String, dynamic> item = json.decode(response.data['data'][key]);
        if (item['type'] == 'user') continue;
        item['id'] = key;
        result.add(item);
      }
      return {'success': true, 'data': result};
    }
  }

  static Future<Map<String, dynamic>> getToDo(
      String tokenJWT, String id) async {
    Response response = await _dio.post(
      '/getvalue',
      data: {'key': id},
      options: Options(headers: {'token': tokenJWT}),
    );
    if (Map.of(response.data).isNotEmpty &&
        !Map.of(response.data).keys.toList().contains('error')) {
      Map<String, dynamic> result = json.decode(response.data['value']);
      result['id'] = id;
      return {'success': true, 'data': result};
    } else if (Map.of(response.data).keys.toList().contains('error')) {
      return {'success': false, 'error': response.data['error']};
    } else {
      return {'success': true, 'data': {}};
    }
  }

  static Future<Map<String, dynamic>> deleteToDo(
      String tokenJWT, String id) async {
    Response response = await _dio.post(
      '/remvalue',
      data: {
        'key': id,
      },
      options: Options(headers: {'token': tokenJWT}),
    );
    if (Map.of(response.data).keys.toList().contains('error')) {
      return {'success': false, 'error': response.data['error']};
    } else {
      return {'success': true, 'data': response.data};
    }
  }
}
