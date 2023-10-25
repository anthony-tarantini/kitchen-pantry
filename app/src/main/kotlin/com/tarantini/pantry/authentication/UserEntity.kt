package com.tarantini.pantry.authentication

data class UserEntity(
   var id: Int? = null,
   var username: String?,
   var userImageUrl: String?,
   var email: String?
)
