# login

A new Flutter project.

## Getting Started

User authentication using firebase , tools used: google signIn and phone signIn

## Steps(For android):

1. Add dependencies in .yaml

2. AppName > andriod > app > build.gradle

plugins {

    id 'com.google.gms.google-services'
}


defaultConfig {

        applicationId "rohan.app.login"
        minSdkVersion 21
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }


dependencies {

    implementation platform('com.google.firebase:firebase-bom:32.7.1')
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    implementation 'com.facebook.android:facebook-android-sdk:latest.release'
}

* paste google-services.json from firestore in directory
(AppName > andriod > app)

3. appName > android > build.gradle

dependencies {

        classpath 'com.google.gms:google-services:4.3.15'
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }

## Steps(For Ios):

1. Paste GoogleService-Info.plistinfo from firestore in directory
(appName > ios > Runner)

## Firebase
## In rule part

1. Firestore Database:


   rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth!=null;
    }
  }
}

2. Storage:
   

   rules_version = '2';

// Craft rules based on data in your Firestore database
// allow write: if firestore.get(
//    /databases/(default)/documents/users/$(request.auth.uid)).data.isAdmin;
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth!=null;
    }
  }
}
