class Post {
  final String postId;
  final String authorId;
  final String authorName;
  final bool isGlobal;
  final String collegeId;
  final DateTime createdAt;
  final Map<String, dynamic> metaData;

  Post({ required this.postId ,required this.authorId , required this.authorName , required this.collegeId , required this.createdAt , required this.isGlobal , required this.metaData });

}
