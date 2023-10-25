package com.tarantini.pantry.user

import com.tarantini.pantry.domain.CreateUserItemRequest
import com.tarantini.pantry.endpoints.withJWTToken
import com.tarantini.pantry.endpoints.withPathParam
import com.tarantini.pantry.endpoints.withRequest
import com.tarantini.pantry.utils.Constants.GOOGLE
import com.tarantini.pantry.utils.getEmail
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.userEndpoints(userService: UserService) {
   get("/users") {
      userService.all().fold(
         { call.respond(HttpStatusCode.OK, it) },
         { call.respond(HttpStatusCode.InternalServerError, it) }
      )
   }

   get("/users/{userId}/items") {
      withPathParam<Int>("userId") { userId ->
         userService.findAllByUser(userId).fold(
            { call.respond(HttpStatusCode.OK, it) },
            { call.respond(HttpStatusCode.InternalServerError, it) }
         )
      }
   }

   authenticate(GOOGLE) {
      post("/users/items") {
         withRequest<CreateUserItemRequest> { request ->
            userService.addItemToUser(1, request.itemId, request.weight).fold(
               { call.respond(HttpStatusCode.OK, it) },
               { call.respond(HttpStatusCode.InternalServerError, it) }
            )
         }
      }
   }
}
