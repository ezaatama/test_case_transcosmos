import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_case_transcosmos/data/audio/audio_player_bloc.dart';
import 'package:test_case_transcosmos/service/api_service.dart';
import 'package:test_case_transcosmos/utils/extension.dart';
import 'package:test_case_transcosmos/utils/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp(appRoute: AppRoute()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRoute});
  final AppRoute appRoute;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const phoneMaxWidth = 480.0;
    final mq = MediaQuery.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AudioPlayerBloc(apiService: ApiService()),
        ),
      ],
      child: MaterialApp(
        scrollBehavior: ClampingScrollBehavior(),
        debugShowCheckedModeBanner: false,
        title: 'Test Case',
        theme: ThemeData(useMaterial3: true),
        onGenerateRoute: appRoute.onGenerateRoute,
        builder: (context, child) {
          final currentScale = mq.textScaler.scale(16.0) / 16.0;
          final clampedScale = currentScale.clamp(1.0, 1.2);
          final clampedTextScaler = TextScaler.linear(clampedScale);

          final phoneWidth = mq.size.width.clamp(0.0, phoneMaxWidth);
          final horizontalLetterbox = (mq.size.width - phoneWidth) / 2.0;

          final phoneMQ = mq.copyWith(
            size: Size(phoneWidth, mq.size.height),
            textScaler: clampedTextScaler,
          );

          final framedChild = MediaQuery(
            data: phoneMQ,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalLetterbox),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: phoneMaxWidth),
                  child: child,
                ),
              ),
            ),
          );
          return framedChild;
        },
      ),
    );
  }
}
