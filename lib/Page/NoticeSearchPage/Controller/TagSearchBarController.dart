import 'package:homerun/Feature/Notice/Value/HouseType.dart';
import 'package:homerun/Feature/Notice/Value/Region.dart';
import 'package:homerun/Page/NoticeSearchPage/View/TagSearchBar.dart';

class TagSearchBarController{

  late TagSearchBarState state;
  late TagSearchBarPreviewState previewState;

  setWidget(TagSearchBarState widget){
    state = widget;
  }

  setPreviewWidget(TagSearchBarPreviewState widget){
    previewState = widget;
  }

  final List<HouseType> houseTypeTags = [];
  final List<Region> regionTags = [];

  void addHouseTypeTag(HouseType houseType){
    houseTypeTags.add(houseType);
    if(state.mounted){
      state.refresh();
    }
  }

  void removeHouseTypeTag(HouseType houseType){
    houseTypeTags.remove(houseType);
    if(state.mounted){
      state.refresh();
    }
  }

  void addRegionTag(Region region){
    regionTags.add(region);
    if(state.mounted){
      state.refresh();
    }
  }

  void removeRegionTag(Region region){
    regionTags.remove(region);
    if(state.mounted){
      state.refresh();
    }
  }

  void reset(){
    houseTypeTags.clear();
    regionTags.clear();
    if(state.mounted){
      state.refresh();
    }

    if(previewState.mounted){
      previewState.refresh();
    }
  }
}