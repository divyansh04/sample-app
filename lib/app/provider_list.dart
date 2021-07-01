import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sample_app/UI/views/home/home_model.dart';


  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<HomeModel>(create: (context) => HomeModel()),
  ];

