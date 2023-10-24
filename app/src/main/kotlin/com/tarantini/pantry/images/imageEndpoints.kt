package com.tarantini.pantry.images

import com.tarantini.pantry.endpoints.withQueryParam
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Route.imageEndpoints(service: ImageService) {

   post("/images") {
      withQueryParam<String>("url") { param ->
         service.downloadAndMoveToS3(param).fold(
            { result -> call.respond(HttpStatusCode.Created, result) },
            { call.respond(HttpStatusCode.InternalServerError, it) }
         )
      }
   }
}
