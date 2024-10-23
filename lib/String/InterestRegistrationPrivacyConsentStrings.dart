class InterestRegistrationPrivacyConsentStrings{
  final String houseName;

  InterestRegistrationPrivacyConsentStrings({required this.houseName});

  //#. 기본
  final String receiver = "· 개인정보를 제공받는 자: ";
  final String purpose = "· 목적: ";
  final String collection = "· 수집항목: ";
  final String collectionContent = "이름, 전화번호";
  final String saveAndUsagePeriod = "· 보유 및 이용기간: ";

  String get basicDescription => "청약홈런은 $houseName의 상담 및 모델하우스 방문 예약을 위해 아래와 같이 개인정보를 수집·이용합니다.";

  String get purposeContent => "$houseName 상담 및 방문 예약처리";

  final String saveAndUsagePeriodContent = "상담 및 예약 처리 목적 달성 시까지 보유, 사용자 요청 시 즉시 폐기 됩니다.";

  
  //#. 3자제공 이용동의
  final String thirdPartContent = "다음과 같이 개인정보를 제 3자에게 제공합니다.";

  
  //#. 개인정보 보호법
  final String rightInRowTitle = "개인정보 보호법에 따른 권리";
  final String rightInRow = "사용자는 언제든지 개인정보 수집 및 이용에 대한 동의를 철회하거나 개인정보의 열람, 수정, 삭제를 요청할 수 있습니다. 이 경우, 즉시 처리됩니다.";

  final String rejectionRightTitle = "개인정보 제공의 거부 권리";
  final String rejectionRight = "사용자는 개인정보 제공을 거부할 권리가 있으며, 이를 거부할 경우 서비스 제공이 제한될 수 있습니다.";

  final String etcSaveAndUsagePeriodTitle = "개인정보 보유 및 이용기간";
  final String etcSaveAndUsagePeriodContent = "수집된 개인정보는 서비스 제공을 위해 필요한 기간 동안 보유 · 이용됩니다. 사용자가 게정을 삭제하거나 개인정보 삭제를 요청할 경우 즉시 폐기됩니다.";

  final String deleteMethodTitle = "개인정보 폐기 절차 및 방법";
  final String deleteMethod = "사용자가 원할 경우 언제든지 개인정보 삭제를 요청할 수 있습니다. 요청 후 개인정보는 즉시 안전하게 삭제되며, 복구할 수 없도록 처리됩니다.";

  final String shareTitle = "개인정보 제공 및 공유";
  final String share = "[청약홈런]은 사용자의 동의 없이 제3자에게 개인정보를 제공하지 않습니다. 다만, 법령에 의해 요구되는 경우에는 예외가 적용됩니다. ";

  final String rightToRejectAgreeTitle = "동의를 거부할 권리";
  final String rightToRejectAgree = "사용자는 개인정보 제공 동의를 거부할 수 있으며, 이 경우 알림 서비스 제공이 제한될 수 있습니다.";

  final String optionalNotificationTitle = "선택적 알림 수신";
  final String optionalNotification = "사용자는 청약 관련 중요한 공지사항, 이벤트, 업데이트 알림 등을 선택적으로 수신할 수 있으며, 이 항목에 대한 동의를 거부해도 기본 알림 서비스 제공에는 영향이 없습니다. ";
}