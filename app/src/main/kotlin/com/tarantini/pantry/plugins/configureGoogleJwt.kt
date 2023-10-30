package com.tarantini.pantry.plugins

import com.auth0.jwk.JwkProviderBuilder
import com.tarantini.pantry.app.GoogleAuth
import com.tarantini.pantry.utils.Constants.GOOGLE
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import java.net.URL
import java.util.concurrent.TimeUnit

fun AuthenticationConfig.configureGoogleJwt(googleAuth: GoogleAuth) {
   val jwkProvider = JwkProviderBuilder(URL(googleAuth.certificateUrl))
      .cached(10, 24, TimeUnit.HOURS)
      .rateLimited(10, 1, TimeUnit.MINUTES)
      .build()

   jwt(GOOGLE) {
      verifier(jwkProvider) {
         withIssuer(googleAuth.issuer)
         withAudience(googleAuth.audience)
      }
      validate { jwtCredential ->
         JWTPrincipal(jwtCredential.payload)
      }
   }
}
