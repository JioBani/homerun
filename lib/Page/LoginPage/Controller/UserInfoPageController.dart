import 'package:get/get.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoPageController extends GetxController{
  XFile? profileImage;

  final ImagePicker picker = ImagePicker();
  final double maxSizeMb = 3;

  /// 프로필 이미지 추가
  Future<void> setProfileImage() async {
    try{
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      //#. 이미지 가져왔는지 확인
      if(pickedFile == null){
        CustomSnackbar.show('오류', '이미지를 가져 올 수 없습니다.');
        return;
      }

      //#. 이미지 크기 제한 확인
      if(await pickedFile.length() / (1024 * 1024) > maxSizeMb){
        CustomSnackbar.show('오류', '프로필 이미지의 크기는 ${maxSizeMb}MB를 넘을 수 없습니다.');
        return;
      }

      profileImage = pickedFile;

      update();
    }catch(e,s){
      CustomSnackbar.show('오류', '이미지를 가져 올 수 없습니다.');
    }
  }
}