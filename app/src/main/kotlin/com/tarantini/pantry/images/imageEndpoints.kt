package com.tarantini.pantry.images

import com.tarantini.pantry.domain.Image
import com.tarantini.pantry.endpoints.withQueryParam
import com.tarantini.pantry.utils.Constants.GOOGLE
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.imageEndpoints(service: ImageService) {
   authenticate(GOOGLE) {
      post("/images") {
         withQueryParam<String>("url") { param ->
            service.downloadAndMoveToS3(param).fold(
               { result -> call.respond(HttpStatusCode.Created, Image(result)) },
               { call.respond(HttpStatusCode.InternalServerError, it) }
            )
         }
      }

      post("/images") { _ ->
         service.uploadToS3(call.receiveChannel()).fold(
            { result -> call.respond(HttpStatusCode.Created, Image(result)) },
            { call.respond(HttpStatusCode.InternalServerError, it) }
         )
      }
   }
}
