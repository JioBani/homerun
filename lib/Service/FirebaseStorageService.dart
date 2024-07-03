class FirebaseStorageService{
  static String getSiteImagePath(String noticeId , String docId){
    return "site_review/$noticeId/$docId/";
  }
}