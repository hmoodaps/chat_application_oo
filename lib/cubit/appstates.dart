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
class LoadingPosts extends AppState{}
class GettingPostsDone extends AppState{}
class GettingPostsError extends AppState{}
class CreatingPostLoading extends AppState{}
class CreatingPostLoadingDone extends AppState{}
class CreatingPostWithPhoto extends AppState{}
class PostWithPhotoCreatedSuccessfully extends AppState{}
class PhotoUploaded extends AppState{}
class LikeSuccess extends AppState{}
class SuccessGettingAllUser extends AppState{}
class ErrorGettingAllUser extends AppState{}
class CreateUserError extends AppState{
  String error;
  CreateUserError(this.error);
}class AddUserError extends AppState{
  String error;
  AddUserError(this.error);
}
class SendMessageSuccess extends AppState{}
class SendMessageError extends AppState{}




