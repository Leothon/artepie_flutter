class FeedbackInfo {
  String userId;

  String versionCode;
  String deviceBrand;
  String deviceModel;
  String buildApi;
  String androidVersion;
  String feedbackContent;

  FeedbackInfo(
      this.userId,
      this.androidVersion,
      this.buildApi,
      this.deviceBrand,
      this.deviceModel,
      this.feedbackContent,
      this.versionCode);

  String toJson(){
    return '{"userId": "$userId","versionCode": "$versionCode","deviceBrand": "$deviceBrand","deviceModel": "$deviceModel","buildApi": "$buildApi","androidVersion": "$androidVersion","feedbackContent": "$feedbackContent"}';
  }
}
