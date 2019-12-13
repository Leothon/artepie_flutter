class Api{
  static const String Base_URL = 'https://www.artepie.com/artepie/';


  //获取OSS Token
  static final String URL_TOKEN= "http://www.artepie.com:7080";

  //获取OS上传图片服务器地址
  static final String URL_UPLOAD_IMAGE_OSS= "http://artepie.oss-cn-zhangjiakou.aliyuncs.com";



  //使用账号密码登录
  static const String usePasswordLogin = Base_URL + 'usepasswordlogin';


  static const String getUserInfo = Base_URL + 'getuserinfo';


  static const String getHomeData = Base_URL + 'gethomedata';

  static const String getHomeMoreData = Base_URL + 'getmoredata';

  static const String getArticleData = Base_URL + 'getarticledata';

  static const String getArticleMoreData = Base_URL + 'getmorearticledata';

  static const String getVideoData = Base_URL + 'getquestion';

  static const String getVideoMoreData = Base_URL + 'getmorequestion';

  static const String getInform = Base_URL + 'getinform';

  static const String getTeacherData = Base_URL + 'getteaclass';
  static const String getTeacherMoreData = Base_URL + 'getmoreteaclass';


  static const String getTypeData = Base_URL + 'getclassbytype';
  static const String getTypeMoreData = Base_URL + 'getmoreclassbytype';



  static const String getClassDetail = Base_URL + 'getclassdetail';
  static const String getMoreClassDetail = Base_URL + 'getmoreclassdetail';


  static const String getArticleDetail = Base_URL + 'getarticledetail';


  static const String getVideoDetail = Base_URL + 'getqadetail';

  static const String getVideoMoreComment = Base_URL + 'getmoreqadetail';


  static const String getPersonalVideo = Base_URL + 'getmorequestionbyid';

  static const String getPersonalArticle = Base_URL + 'getmorearticledatabyid';


  static const String getCommentInfo = Base_URL + 'getcommentdetail';

  static const String getCommentReply = Base_URL + 'getmorecommentdetail';

  static const String getNotice = Base_URL + 'getmorenoticeinfo';

  static const String getFav = Base_URL + 'getmorefavclassbyuid';

  static const String unFav = Base_URL + 'unfavclass';
  static const String favClass = Base_URL + 'favclass';

  static const String getBuyClass = Base_URL + 'getmorebuyclass';

  static const String getOrder = Base_URL + 'getmoreorderhis';

  static const String sendFeedback = Base_URL + 'sendfeedback';

  static const String updateUserInfo = Base_URL + 'updateuserinfo';
}