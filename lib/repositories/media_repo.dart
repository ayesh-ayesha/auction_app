import 'package:cloudinary_sdk/cloudinary_sdk.dart';

class MediaRepository {
  late Cloudinary cloudinary;

  MediaRepository() {
    cloudinary = Cloudinary.full(
      apiKey: '348489458738385',
      apiSecret: 'GjGLvd_UxYCAq1eB5zLIova0ikI',
      cloudName: 'dtescwyqv',
    );
  }

  Future<CloudinaryResponse> uploadImage(String path) {
    return cloudinary.uploadResource(
      CloudinaryUploadResource(
        filePath: path,
        resourceType: CloudinaryResourceType.image,
      ),
    );
  }
}
