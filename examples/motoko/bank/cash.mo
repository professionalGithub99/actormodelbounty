import edcsa "mo:edcsa/lib";

actor class Cash(_owner:Principal){

 private stable var owner = _owner;
  private var parent_signed_accountId:?edcsa.Signature = null;
  private var parent_principal: ?Principal = null;
 
 
  public func set_parent_signed_accountId(_signed_accountId:?edcsa.Signature){
    parent_signed_accountId := _signed_accountId;
  };
  public func get_parent_signed_accountId():async ?edcsa.Signature{
    return parent_signed_accountId;
  };
  public func get_parent_principal(): async ?Principal{
    return parent_principal;
  };
  public func set_parent_principal(_principal:?Principal){
    parent_principal := _principal;
  };

    public shared({caller}) func transfer(_to:Principal):async (){
      assert(owner == caller);
      owner := _to;
    };
};
