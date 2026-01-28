import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties
val keystorePropertiesFile = rootProject.file("keystore.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.dhruvanbhalara.passvault"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    // Signing configurations
    signingConfigs {
        getByName("debug") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties.getProperty("debugKeyAlias")
                keyPassword = keystoreProperties.getProperty("debugKeyPassword")
                storeFile = rootProject.file(keystoreProperties.getProperty("debugKeyStore"))
                storePassword = keystoreProperties.getProperty("debugStorePassword")
            }
        }
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties.getProperty("releaseKeyAlias")
                keyPassword = keystoreProperties.getProperty("releaseKeyPassword")
                storeFile = rootProject.file(keystoreProperties.getProperty("releaseKeyStore"))
                storePassword = keystoreProperties.getProperty("releaseStorePassword")
            }
        }
    }

    defaultConfig {
        applicationId = "com.dhruvanbhalara.passvault"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        ndk {
            abiFilters += listOf("arm64-v8a", "x86_64")
        }
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    flavorDimensions += "env"

    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "PassVault - Dev")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "PassVault")
        }
    }
}

flutter {
    source = "../.."
}
