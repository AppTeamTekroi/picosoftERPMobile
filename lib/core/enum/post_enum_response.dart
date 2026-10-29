enum PostResponseEnum {
  failed,
  success,
  alreadyAdded,
  error,
}

class PostResponseType {
  PostResponseType({
    required this.postResponseEnum,
    this.message = "default",
  });

  final PostResponseEnum postResponseEnum;
  final String message;
}
