import BtcContainerCreator "canister:btconicpexample";
import HashMap "mo:base/HashMap";
import Blob "mo:base/Blob";
import Result "mo:base/Result";
import Hash "mo:base/Hash";
import Principal "mo:base/Principal";
import Cash "./cash";
import AccountIdLibrary "mo:invoice/invoice/Account";
import AccountIdLibraryUtils "mo:invoice/invoice/Utils";
import AccountIdLibraryTypes "mo:invoice/invoice/Types";
import AccountIdLibraryHex "mo:invoice/invoice/Hex";
import KeyUtils "../../../tests/KeyUtils";
import edcsa "mo:edcsa/lib";
actor BtcFederalReserve {
  let eq: (Principal,Principal)->Bool  = func(x,y) { Principal.equal(x,y) };
  let keyHash: (Principal)->Hash.Hash = func(x)   { Principal.hash(x) }; // type Hash is a Word32
  var tokensMinted:Nat = 0;
  public type Balance = Nat64;
  var btcContainerHashMap:HashMap.HashMap<Principal,Balance> = HashMap.HashMap<Principal,Balance>(1,eq,keyHash);
  public type NotifySuccess ={ #TxSuccess};
  public type NotifyFailure ={ #TxFailure};
  var private_key_wif="";
  var private_key:[Nat8]=[];
  var private_key_decimal:Nat=0;

  public func generate_private_key():async (Text,[Nat8],Nat)
  {
    var priv_key_tuple =await KeyUtils.generate_private_key();
private_key_wif:=priv_key_tuple.0;
private_key:=priv_key_tuple.1;
private_key_decimal:=priv_key_tuple.2;
                    return (private_key_wif,private_key,private_key_decimal);
  };

  public shared({caller}) func notifyBitcoinContainerDeposit(_principal:Principal):async Result.Result<NotifySuccess,NotifyFailure>{
    var btcContainer = btcContainerHashMap.get(_principal);
    switch(btcContainer){
      case(null){
        var newBtcContainer = actor(Principal.toText(_principal)): actor {get_parent_signed_accountId:() -> async ?edcsa.Signature; get_owner:()->async Principal};
        var accountIdSignedMessage = await newBtcContainer.get_parent_signed_accountId();
        switch(accountIdSignedMessage){
        case(null){
        return #err(#TxFailure);
        };
        case(?accountIdSignedMessage){
        var accountIdentifierAsBlob = AccountIdLibrary.accountIdentifier(_principal,AccountIdLibrary.defaultSubaccount()); 
        var accountIdentifierAsNat8 = Blob.toArray(accountIdentifierAsBlob);
        var message_verified = await BtcContainerCreator.verify_message(accountIdentifierAsNat8,accountIdSignedMessage);
        switch(message_verified){
        case(true){
          var owner = await newBtcContainer.get_owner();
          switch (Principal.equal(owner,caller)){
          case(true){
             return #ok(#TxSuccess);
            };
          case(false){
          return #err(#TxFailure);
          };
          }
          };
          case(_){
            return #err(#TxFailure);};
        };
        };
        }
      }; 
      case(_){
        return #err(#TxFailure);
      };
    };
  };
}

 


