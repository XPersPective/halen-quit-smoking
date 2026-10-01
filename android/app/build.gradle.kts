import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Upload-key credentials live outside this (open-source) repository, in the
// publishing root: D:\AppPublishingpps\halen-quit-smoking\credentialsndroid
// (protocol: D:\AppPublishing\README.md). `fastlane build_release` points
// HALEN_SIGNING at that key.properties; its storeFile is relative to it.
// Without it the release build falls back to debug signing, so a fresh clone
// still builds — and Play refuses that APK, so nothing ships by accident.
val keystorePropertiesFile = System.getenv("HALEN_SIGNING")?.let { file(it) }
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile?.exists() == true) {
        keystorePropertiesFile.inputStream().use { load(it) }
    }
}
val hasUploadKey = keystoreProperties.getProperty("storeFile") != null

android {
    namespace = "com.crazypenguin.halenquitsmoking"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Required by flutter_local_notifications (report §20 notifications).
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.crazypenguin.halenquitsmoking"
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Real AdMob app id comes from the publishing root at release time;
        // Google's public test app id otherwise.
        manifestPlaceholders["admobAppId"] =
            System.getenv("ADMOB_APP_ID_ANDROID") ?: "ca-app-pub-3940256099942544~3347511713"
    }

    signingConfigs {
        if (hasUploadKey) {
            create("upload") {
                storeFile = keystorePropertiesFile!!.parentFile.resolve(keystoreProperties.getProperty("storeFile"))
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
