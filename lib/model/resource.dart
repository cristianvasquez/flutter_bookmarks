class Resource {
  final String uid;
  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is Resource && other.uid == this.uid;
  }

  Resource(this.uid) {
    assert(this.uid != null, "Resource:uid:null");
  }
}
