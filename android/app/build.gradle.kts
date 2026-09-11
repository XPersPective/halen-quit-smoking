import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Upload-key credentials, read from android/key.properties, which is
// gitignored and never committed. The file is absent on a fresh clone and on
// CI, and the build below falls back to debug signing so `flutter build apk`
// keeps working for anyone who just wants to run the thing.
//
// To produce a store-signable build, create the keystore once:
//
//   keytool -genkey -v -keystore ~/halen-upload.jks -keyalg RSA //           -keysize 2048 -validity 10000 -alias halen
//
// then write android/key.properties:
//
//   storeFile=/absolute/path/to/halen-upload.jks
//   storePassword=...
//   keyAlias=halen
//   keyPassword=...
//
// Losing that keystore means losing the ability to update the app on Play,
// so it belongs in a password manager, not in this repository.
val keystoreProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) {
        file.inputStream().use { load(it) }
    }
}
val hasUploadKey = keystoreProperties.getProperty("storeFile") != null

android {
    namespace = "com.halenquitsmoking.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Required by flutter_local_notifications (report §20 notifications).
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.halenquitsmoking.app"
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasUploadKey) {
            create("upload") {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // The upload key when it is configured; debug keys otherwise, so
            // `flutter build apk --release` still works on a fresh clone. A
            // debug-signed APK installs fine for testing and is refused by
            // Play, which is the correct failure: it cannot be published by
            // accident.
            signingConfig = if (hasUploadKey) {
                signingConfigs.getByName("upload")
            } else {
                signingConfigs.getByName("debug")
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
