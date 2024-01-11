import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/login/login_bloc.dart';
import 'package:flutter_app/bloc/logout/logout_bloc.dart';
import 'package:flutter_app/bloc/register/register_bloc.dart';
import 'package:flutter_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_app/pages/auth/auth_page.dart';
import 'package:flutter_app/pages/dashboard/dashboard_page.dart';
import 'package:flutter_app/pages/splash/splash_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/utils/light_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: light,
        home: FutureBuilder(
          future: AuthLocalDatasource().isLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData && snapshot.data!) {
              return const DashboardPage();
            } else {
              return const AuthPage();
            }
          },
        ),
      ),
    );
  }
}
