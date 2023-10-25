package com.tarantini.pantry.utils

import io.ktor.server.auth.jwt.*

object Constants {
   const val NONCE = "nonce"
   const val GOOGLE = "google"
}

object CustomHeaders {
   const val Nonce = "X-Nonce"
}

fun JWTPrincipal.getUserName(): String {
   return getClaim("name", String::class).orEmpty()
}

fun JWTPrincipal.getEmail(): String {
   return getClaim("email", String::class).orEmpty()
}

fun JWTPrincipal.getImageUrl(): String {
   return getClaim("picture", String::class).orEmpty()
}
