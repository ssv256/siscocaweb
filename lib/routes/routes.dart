class AppRoutes{

  static const home                         = "/";

  static const auth                         = "/auth";
  static const authLostAccount              = "/auth/lost-account";
  
  static const patients                     = "/patients";
  static const patientsCreate               = "/patients/create";
  static const patientsDetail               = "/patients/detail";

  static const studies                      = "/studies";
  static const studiesCreate                = "/studies/create";
  static const studiesDetail                = "/studies/:id";

  static const survey                       = "/survey";
  static const surveyCreate                 = "/survey/create";

  static const news                         = "/news";
  static const newsCreate                   = "/news/create";
  static const newsCategories               = "/news/categories";

  static const doctors                      = "/doctors";
  static const doctorsCreate                = "/doctors/create";
  static const doctorsDetail                = "/doctors/detail";

  static const hospitals                    = "/hospitals";
  static const hospitalsCreate              = "/hospitals/create";
  static const hospitalsDetail              = "/hospitals/detail";

  static const studiesAdmin                 = "/studies-admin";
  static const studiesAdminCreate           = "/studies-admin/create";
  
  static const categories                   = "/categories";
  static const categoriesCreate             = "/categories/create";

}