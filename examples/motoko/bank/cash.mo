actor class Cash(_owner:Principal):{
    var owner:Principal = _owner;
    public shared({caller}) func transfer(_to:Principal):Principal= {
      assert(owner==caller);
      owner=_to;
    };
};
