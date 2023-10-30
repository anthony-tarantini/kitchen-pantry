package com.tarantini.pantry.utils

import io.ktor.server.auth.jwt.*

object Constants {
   const val GOOGLE = "google"
}

fun <T> orDefault(main: T?, default: T): T {
   return main ?: default
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

fun JWTPrincipal.getExpiry(): Long {
   return orDefault(this.expiresAt?.time, -1)
}
