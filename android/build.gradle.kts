allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// isar_flutter_libs 3.1.0+1 は namespace / compileSdk 未指定のため AGP 8+ で問題が出る
// ※ evaluationDependsOn より前に置くこと
subprojects {
    afterEvaluate {
        if (name == "isar_flutter_libs") {
            extensions.findByType(com.android.build.gradle.LibraryExtension::class.java)?.apply {
                if (namespace.isNullOrEmpty()) {
                    namespace = "dev.isar.isar_flutter_libs"
                }
                compileSdk = 34
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_11
                    targetCompatibility = JavaVersion.VERSION_11
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
