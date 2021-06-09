import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter_movie_showcase/models/movie.dart';

part 'serializers.g.dart';

@SerializersFor(<Type>[Movie])
Serializers serializers = (_$serializers.toBuilder() //
  ..addPlugin(StandardJsonPlugin()))
    .build();