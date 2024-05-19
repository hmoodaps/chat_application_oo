import 'package:chat_application/model/model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AppState {}
class InitCubit extends AppState{}
class ToggleLightAndDark extends AppState{}
class ToggleBetweenLoginAndRegister extends AppState{}
class ChangBottomNavBarIndex extends AppState{}
class ChangFavIcon extends AppState{}
class ChangFavIconPressing extends AppState{}
class ChangeTextPressed extends AppState{}
class SignInWithEmailAndPass extends AppState{
  UserCredential value ;
  SignInWithEmailAndPass({required this.value});
}
class LoggedOut extends AppState{}
class CreateUser extends AppState{}
class SignInWithEmailAndPassFailed extends AppState{}
class FetchUserDataError extends AppState{}
class UserDataLoaded extends AppState{
  String userName ; String email ;
  UserDataLoaded(this.userName , this.email);
}
class ErrorOccurred extends AppState{}
class FetchUserData extends AppState{
  Model model ;
  FetchUserData({required this.model});
}
class TogglePages extends AppState{}
class TogglePagesState extends AppState{}
class HomeState extends AppState{}
class LoggedInByGoogle extends AppState{
  UserCredential value ;
  LoggedInByGoogle({required this.value});
}
class GetFirstPage extends AppState{}
class IsTheFirstTime extends AppState{}
class CheckUserDataExistence extends AppState{}
class GetDataState extends AppState{}
class DataLoadedState extends AppState{}
class GetBackGroundPhotoSuccess extends AppState{}
class GetBackGroundPhotoFailed extends AppState{}
class GetProfileImageSuccess extends AppState{}
class GetProfileImageFailed extends AppState{}
class UpdatingProfileData extends AppState{}
class ErrorState extends AppState{
  String error ;
  ErrorState(this.error);
}
class GetPostPhotoSuccess extends AppState{}
class GetPostPhotoFailed extends AppState{}
class CreatingPost extends AppState{}
class DeletePhotoFromThePost extends AppState{}
class UploadPostPhoto extends AppState{}
class PostCreatedSuccessfully extends AppState{}
class PostCreatedFailed extends AppState{}





