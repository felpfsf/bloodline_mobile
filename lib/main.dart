import 'package:bloodline_mobile/app/app.dart';
import 'package:bloodline_mobile/app/enviroment/app_enviroment.dart';
import 'package:bloodline_mobile/app/features/identity/data/datasources/login_remote_datasource.dart';
import 'package:bloodline_mobile/app/features/identity/data/repositories/login_repository_impl.dart';
import 'package:bloodline_mobile/core/networking/dio_factory.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = DioFactory.create(baseUrl: AppEnviroment.apiBaseUrl);

  final loginRepository = LoginRepositoryImpl(
    LoginRemoteDatasource(dio: dio),
  );

  runApp(
    BloodlineApp(
      loginRepository: loginRepository,
    ),
  );
}
