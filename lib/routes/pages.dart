import 'package:get/get.dart';
import 'package:siscoca/app/modules/doctors/binding/doctor_binding.dart';
import 'package:siscoca/app/modules/home/binding/home_binding.dart';
import 'package:siscoca/app/modules/hospitals/binding/hospital_binding.dart';
import 'package:siscoca/app/modules/news/binding/article_binding.dart';
import 'package:siscoca/app/modules/news/categories/bindings/news_categories_binding.dart';
import 'package:siscoca/app/modules/news/categories/news_categories_view.dart';
import 'package:siscoca/app/modules/patients/patients_create/binding/binding.dart';
import 'package:siscoca/app/modules/patients/patients_list/bindings/patients_binding.dart';
import 'package:siscoca/app/modules/studies/index.dart';
import 'package:siscoca/app/modules/studies_admin/index.dart';
import 'package:siscoca/app/modules/surveys/index.dart';
import 'package:siscoca/core/middlewares/middleware_auth.dart';
import '../app/modules/auth/auth_login/auth_view.dart';
import '../app/modules/auth/auth_login/controllers/auth_binding.dart';
import '../app/modules/auth/auth_login/lost_account.dart';
import '../app/modules/categories/categories_create/categories_create_view.dart';
import '../app/modules/categories/bindings/categories_binding.dart';
import '../app/modules/categories/categories_view/categories_view.dart';
import '../app/modules/doctors/doctors_create/doctors_create_view.dart';
import '../app/modules/doctors/doctors_view/doctors_view.dart';
import '../app/modules/home/views/home_view.dart';
import '../app/modules/hospitals/hospitals_create/hospitals_create_view.dart';
import '../app/modules/hospitals/hospitals_view/hospitals_view.dart';
import '../app/modules/news/news_create/news_create_view.dart';
import '../app/modules/news/news_view/news_view.dart';
import '../app/modules/patients/patients_create/patients_create_view.dart';
import '../app/modules/patients/patients_detail/binding/binding_details.dart';
import '../app/modules/patients/patients_detail/patients_detail_view.dart';
import '../app/modules/patients/patients_list/patients_list.dart';
import 'routes.dart';

class AppPages{

  static final List<GetPage> pages = [
    
    GetPage(
      title       : 'Home',
      name        : AppRoutes.home, 
      page        : () => const HomeView(),
      bindings     : [ HomeBinding(), SurveyBinding() ]
      // middlewares : [AuthMiddleware()]
    ),
    
    GetPage(
      title       : 'Inicio de sesión',
      name        : AppRoutes.auth, 
      page        : () =>  AuthView(),
      binding     : AuthBinding()
    ),
    GetPage(
      title       : 'Recuperar cuenta',
      name        : AppRoutes.authLostAccount, 
      page        : () => const LostAccountView(),
      binding     : AuthBinding()
    ),

    GetPage(
      title       : 'Pacientes',
      name        : AppRoutes.patients, 
      page        : () => const PatientsList(),
      bindings     : [ PatientListBinding(), SurveyBinding() ]
    ),
    
    GetPage(
      title       : 'Crear paciente',
      name        : AppRoutes.patientsCreate, 
      page        : () => const PatientsCreateView(),
      binding     : PatientCreateBinding()
    ),
    GetPage(
      title       : 'Detalle de paciente',
      name        : AppRoutes.patientsDetail, 
      page        : () => const PatientsDetailView(),
      binding     : PatientDetailsBinding()
    ),
    GetPage(
      title       : 'Estudios',
      name        : AppRoutes.studies, 
      page        : () => const StudiesView(),
      binding     : StudyBinding(),
    ),
    GetPage(
      title       : 'Cuestionarios',
      name        : AppRoutes.survey, 
      page        : () => const SurveyView(),
      binding     : SurveyBinding(),
    ),
    GetPage(
      title       : 'Crear cuestionario',
      name        : AppRoutes.surveyCreate, 
      page        : () => const SurveysCreateView(),
      binding     : SurveyBinding(),
    ),
    GetPage(
      title       : 'Noticias',
      name        : AppRoutes.news, 
      page        : () => const NewsView(),
      binding     : ArticlesBinding(),
    ),
    GetPage(
      title       : 'Crear noticia',
      name        : AppRoutes.newsCreate, 
      page        : () => const ArticlesCreateView(),
      binding     : ArticlesBinding(),
    ),
    GetPage(
      title       : 'Categorías de Noticias',
      name        : AppRoutes.newsCategories, 
      page        : () => const NewsCategoriesView(),
      binding     : NewsCategoriesBinding(),
    ),
    GetPage(
      title       : 'Categorias',
      name        : AppRoutes.categories, 
      page        : () => const CategoriesView(),
      binding     : CategoriesBinding(),
    ),
    GetPage(
      title       : 'Crear categoriaaaa',
      name        : AppRoutes.categoriesCreate, 
      page        : () => const CategoriesCreateView(),
      binding     : CategoriesBinding(),
    ),    
    
    GetPage(
      title       : 'Doctores',
      name        : AppRoutes.doctors, 
      page        : () => const DoctorsView(),
      binding     : DoctorBinding(),
    ),
    GetPage(
      title       : 'Crear doctor',
      name        : AppRoutes.doctorsCreate, 
      page        : () => const DoctorsCreateView(),
      binding     : DoctorBinding(),
      middlewares: [AdminMiddleware()],
    ),

    GetPage(
      title       : 'Hospitales',
      name        : AppRoutes.hospitals, 
      page        : () => const HospitalsView(),
      binding     : HospitalBinding(),
    ),
    GetPage(
      title       : 'Crear hospital',
      name        : AppRoutes.hospitalsCreate, 
      page        : () => const HospitalsCreateView(),
      binding     : HospitalBinding(),
      middlewares: [AdminMiddleware()],
    ),

    GetPage(
      title       : 'Estudios administrativos',
      name        : AppRoutes.studiesAdmin, 
      page        : () => const StudiesAdminView(),
      binding     : StudyAdminBinding(),
    ),
    GetPage(
      title       : 'Crear estudio administrativo',
      name        : AppRoutes.studiesAdminCreate, 
      page        : () => const StudiesAdminCreateView(),
      binding     : StudyAdminBinding(),
      middlewares: [AdminMiddleware()],
    ),
  ];
}