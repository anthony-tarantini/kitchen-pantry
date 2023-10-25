package com.tarantini.pantry.images

import com.tarantini.pantry.app.Assets
import io.ktor.client.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.util.cio.*
import io.ktor.utils.io.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import software.amazon.awssdk.auth.credentials.EnvironmentVariableCredentialsProvider
import software.amazon.awssdk.core.sync.RequestBody
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.s3.S3Client
import software.amazon.awssdk.services.s3.model.PutObjectRequest
import java.io.File
import java.util.*

class ImageService(
   private val httpClient: HttpClient,
   private val assets: Assets
) {

   suspend fun downloadAndMoveToS3(url: String): Result<String> {
      return uploadToS3(httpClient.get {
         url(url)
         method = HttpMethod.Get
      }.bodyAsChannel())
   }

   suspend fun uploadToS3(bodyAsChannel: ByteReadChannel): Result<String> {
      val file = withContext(Dispatchers.IO) {
         File.createTempFile("img", ".png", null)
      }

      bodyAsChannel.copyAndClose(file.writeChannel())

      val imageId = UUID.randomUUID().toString()
      val client = S3Client.builder()
         .credentialsProvider(EnvironmentVariableCredentialsProvider.create())
         .region(Region.US_EAST_2)
         .build()

      val request = PutObjectRequest.builder()
         .bucket(assets.bucketName)
         .key("${assets.imagePrefix}$imageId.png")
         .metadata(mutableMapOf(Pair("Content-Type", "image/png")))
         .build()

      client.putObject(request, RequestBody.fromFile(file))
      return Result.success("${assets.imagesUrl}/$imageId.png")
   }
}
