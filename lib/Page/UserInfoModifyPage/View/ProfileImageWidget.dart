import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Service/Auth/UserDto.dart';

import '../Controller/ProfileImageController.dart';

class ProfileImageWidget extends StatelessWidget {
  ProfileImageWidget({super.key , required UserDto userDto}){
    var controller = Get.put(ProfileImageController(userDto: userDto));
    controller.profileImageLoader.load();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 100.w,
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(100.w),
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(100.w)
                ),
                child: GetBuilder<ProfileImageController>(
                  builder: (controller) {
                    if(controller.profileImageLoader.loadingState == LoadingState.success){
                      return Image.memory(
                        controller.modifiedProfileImage.value == null ?
                          controller.lastProfileImage! :
                          controller.modifiedProfileImage.value!,
                        width: 100.w,
                        height: 100.w,
                        fit: BoxFit.cover,
                      );
                    }
                    else if (controller.profileImageLoader.loadingState == LoadingState.loading){
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    else{
                      if(controller.modifiedProfileImage.value != null){
                        return Image.memory(
                          controller.lastProfileImage!,
                          width: 100.w,
                          height: 100.w,
                          fit: BoxFit.cover,
                        );
                      }
                      else{
                        return Center(
                          child: Icon(Icons.error_outline),
                        );
                      }
                    }
                  }
                ),
              )
          ),
          GetX<ProfileImageController>(
            builder: (controller){
              if(controller.modifiedProfileImage.value == null){
                return Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: (){
                      controller.pickProfileImage();
                    },
                    child: Container(
                      width: 25.w,
                      height: 25.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white , width: 1.w),
                          borderRadius: BorderRadius.circular(25.w),
                          color: Colors.black
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }
              else{
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: (){
                          controller.updateProfile(context);
                        },
                        child: Container(
                          width: 25.w,
                          height: 25.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white , width: 1.w),
                            borderRadius: BorderRadius.circular(25.w),
                            color: Colors.greenAccent
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: (){
                          controller.resetModify();
                        },
                        child: Container(
                          width: 25.w,
                          height: 25.w,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white , width: 1.w),
                            borderRadius: BorderRadius.circular(25.w),
                            color: Colors.redAccent
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
          )
        ],
      ),
    );

    return GetBuilder<ProfileImageController>(
        builder: (controller){
          if(controller.profileImageLoader.loadingState == LoadingState.success){

          }
        }
    );
  }
}