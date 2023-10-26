package com.tarantini.pantry.authentication

import com.tarantini.pantry.domain.User
import com.tarantini.pantry.user.UserService
import com.tarantini.pantry.utils.Constants.GOOGLE
import com.tarantini.pantry.utils.getEmail
import com.tarantini.pantry.utils.getImageUrl
import com.tarantini.pantry.utils.getUserName
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.authenticationRoutes(userService: UserService) {
   route("users/authenticate") {
      authenticate(GOOGLE) {
         get {
            val principal = call.principal<JWTPrincipal>()!!
            val user = User(principal.getUserName(), principal.getImageUrl(), principal.getEmail())
            userService.exists(user.email).fold(
               { userId ->
                  if (userId == null) {
                     userService.create(user).fold(
                        { call.respond(HttpStatusCode.Created, user.apply { id = it }) },
                        { call.respond(HttpStatusCode.InternalServerError, it) }
                     )
                  } else {
                     call.respond(HttpStatusCode.OK, user.apply { id = userId })
                  }
               },
               { call.respond(HttpStatusCode.InternalServerError, it) }
            )
         }
      }
   }
}
