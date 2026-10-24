
plugins {
    id("com.android.application")

    // Flutter Gradle Plugin
    id("dev.flutter.flutter-gradle-plugin")

    // Firebase
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "com.example.petcare"

    // Local Notifications yêu cầu compileSdk >= 35.
    // Giữ phiên bản do Flutter cung cấp nếu >= 35.
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    buildFeatures {
        resValues = true
    }

    // Java 17 + Core Library Desugaring
    compileOptions {
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.tickly.app"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    // ==================== FLAVORS ====================

    flavorDimensions += "environment"

    productFlavors {
        create("development") {
            dimension = "environment"

            applicationIdSuffix = ".dev"

            resValue(
                "string",
                "app_name",
                "Tickly Dev"
            )
        }

        create("production") {
            dimension = "environment"

            resValue(
                "string",
                "app_name",
                "Tickly"
            )
        }
    }

    // ==================== BUILD TYPES ====================

    buildTypes {
        release {
            // Chỉ dùng debug signing để kiểm thử.
            // Cần release keystore trước khi phát hành.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// ==================== KOTLIN ====================

kotlin {
    compilerOptions {
        jvmTarget =
            org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

// ==================== DEPENDENCIES ====================

dependencies {
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.4"
    )
}

// ==================== FLUTTER ====================

flutter {
    source = "../.."
}
