import edcsa "mo:edcsa/lib";
import AccountIdLibrary "mo:invoice/invoice/Account";
import AccountIdLibraryUtils "mo:invoice/invoice/Utils";
import AccountIdLibraryTypes "mo:invoice/invoice/Types";
import AccountIdLibraryHex "mo:invoice/invoice/Hex";
import Blob "mo:base/Blob";
import Principal "mo:base/Principal";

actor class Cash(_owner:Principal) =this {

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
   public func getAccountIdentifierNat8Array() : async [Nat8] {
    var accountIdentifierAsBlob = AccountIdLibrary.accountIdentifier(Principal.fromActor(this),AccountIdLibrary.defaultSubaccount());
    var accountIdentifierAsNat8Array = Blob.toArray(accountIdentifierAsBlob);
    return accountIdentifierAsNat8Array;
  };
  public func getOwner():async Principal{
    return owner;
  };

};
