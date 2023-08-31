
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:homerun/Service/LoginService.dart';

enum LoginProcessState {none , inLoginProcess}

class LoginController extends GetxController{

  Rx<LoginProcessState> loginProcessState = LoginProcessState.none.obs;
  Rx<LoginState> loginState = LoginState.logout.obs;


  @override
  onInit(){
    super.onInit();
    loginProcessState = LoginProcessState.none.obs;
  }

  Future<LoginResult> login() async {
    loginProcessState.value = LoginProcessState.inLoginProcess;
    LoginResult loginResult = await LoginService.instance.loginProcess();
    loginProcessState.value = LoginProcessState.none;

    await checkLogin();

    return loginResult;
  }

  Future<LoginState> checkLogin()async{
    loginState.value = await LoginService.instance.checkLogin();
    return loginState.value;
  }

  Future<void> logout()async{
    await LoginService.instance.logout();
    await checkLogin();
  }
}