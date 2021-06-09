import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_movie_showcase/models/serializers.dart';

part 'movie.g.dart';

abstract class Movie implements Built<Movie, MovieBuilder> {
  factory Movie([void Function(MovieBuilder)? updates]) = _$Movie;

  factory Movie.fromJson(Map<String, dynamic> json) {
    // ignore: cast_nullable_to_non_nullable
    return serializers.deserializeWith(serializer, json) as Movie;
  }

  Movie._();

  @BuiltValueField(wireName: 'id')
  String get id;

  @BuiltValueField(wireName: 'title_english')
  String get titleEnglish;

  @BuiltValueField(wireName: 'medium_cover_image')
  String get coverImage;

  // ignore: cast_nullable_to_non_nullable
  Map<String, dynamic> get json => serializers.serializeWith(serializer, this) as Map<String, dynamic>;

  static Serializer<Movie> get serializer => _$movieSerializer;
}