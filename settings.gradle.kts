rootProject.name = "kitchen-pantry"

include(
   ":app",
   ":client",
   ":domain",
   ":pantry_ui",
   ":infrastructure"
)

pluginManagement {
   plugins {
      id("io.ktor.plugin") version "2.3.4"
   }
}

dependencyResolutionManagement {
   versionCatalogs {
      create("deps") {
         from(files("deps.versions.toml"))
      }
   }
}

enableFeaturePreview("STABLE_CONFIGURATION_CACHE")
enableFeaturePreview("TYPESAFE_PROJECT_ACCESSORS")
