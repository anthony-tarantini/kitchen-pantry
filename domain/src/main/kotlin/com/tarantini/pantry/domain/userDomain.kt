package com.tarantini.pantry.domain

data class User(
   val username: String,
   val userImageUrl: String,
   val email: String,
   var id: Int? = null
)

data class AuthenticationResponse(
   val user: User,
   val expiry: Long
)
