class LikeState{
  final int likeState;
  final int likeChange;
  final int dislikeChange;

  LikeState({
    required this.likeState,
    required this.likeChange,
    required this.dislikeChange,
  });

  factory LikeState.fromMap(Map<String, dynamic> map) {
    return LikeState(
      likeState: map['likeState'],
      likeChange: map['likeChange'],
      dislikeChange: map['dislikeChange']
    );
  }
}