import {
  GOOGLE_ANDROID_CLIENT_ID,
  GOOGLE_IOS_CLIENT_ID,
  GOOGLE_WEB_CLIENT_ID,
} from "./constants";
import {
  GoogleSignin,
} from "@react-native-google-signin/google-signin";


function configureGoogle() {
  GoogleSignin.configure({
    scopes: [
      "https://www.googleapis.com/auth/calendar",
      "https://www.googleapis.com/auth/calendar.events"
    ],
    androidClientId: GOOGLE_ANDROID_CLIENT_ID,
    iosClientId: GOOGLE_IOS_CLIENT_ID,
    webClientId: GOOGLE_WEB_CLIENT_ID,
    offlineAccess: true,
    forceCodeForRefreshToken: true,
  });
}

async function googleAuthLogin() {
  return GoogleSignin.hasPlayServices()
    .then((hasPlayService) => {
      if (hasPlayService) {
        return GoogleSignin.signIn()
          .then(async (google_auth) => ({ id_token: google_auth.idToken, code: google_auth.serverAuthCode }))
          .catch((e) => console.log("ERRO AO LOGAR", e));
      }
    })
    .catch((e) => console.log("ERROR: " + JSON.stringify(e)));
}

async function googleIsSignedIn(){
  return await GoogleSignin.isSignedIn();
}

async function googleSignOut(){
  await GoogleSignin.signOut()
}

export { googleAuthLogin, configureGoogle, googleIsSignedIn, googleSignOut };