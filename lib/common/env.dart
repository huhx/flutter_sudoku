import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'sudokuUrl', obfuscate: true)
  static final sudokuUrl = _Env.sudokuUrl;
}
