class Api{
  static const String Base_URL = 'https://www.artepie.com/artepie/';

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
}