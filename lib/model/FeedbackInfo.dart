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
}
