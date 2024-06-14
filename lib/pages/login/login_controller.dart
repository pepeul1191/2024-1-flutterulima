import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:ulimagym/pages/home/home_page.dart';
import '../../models/entities/Usuario.dart';
import '../../models/responses/user_member.dart';
import '../../services/user_service.dart';
import '../recover/recover_page.dart';
import '../signin/signin_page.dart';

class LoginController extends GetxController {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  RxString message = 'primer mensaje'.obs;
  var messageColor = Colors.white.obs;
  UserService userService = UserService();

  void login(BuildContext context) async {
    print('hola desde el controlador');
    print(userController.text);
    print(passController.text);
    String user = userController.text;
    String password = passController.text;
    Usuario userLogged = Usuario.empty();

    UserMember? userMember = await userService.validate(user, password);
    if (userMember == null) {
      message.value = 'Ocurrio un error en el servidor';
      messageColor.value = Colors.red;
    } else if (userMember.memberId == 0 && userMember.userId == 0) {
      message.value = 'Usuario incorrecto';
      messageColor.value = Colors.red;
    } else {
      print('usuario correcto');
      message.value = 'Usuario correcto';
      messageColor.value = Colors.green;
      print('usuario correcto');
      message.value = 'Usuario correcto';
      messageColor.value = Colors.green;
      Future.delayed(Duration(seconds: 5), () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    usuarioLogged: userLogged,
                  )),
        );
      });
    }
  }

  void goToSignIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  void goToRecover(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecoverPage()),
    );
  }
}
