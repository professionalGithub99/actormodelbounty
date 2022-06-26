import BtcContainerCreator "canister:btconicpexample";
import Array "mo:base/Array";
import Nat64 "mo:base/Nat64";
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
import Management "../../../tests/management";
import BtcContainers "../src/Account";
import edcsa "mo:edcsa/lib";
import Debug "mo:base/Debug";
actor BtcFederalReserve {
  let eq: (Principal,Principal)->Bool  = func(x,y) { Principal.equal(x,y) };
  let keyHash: (Principal)->Hash.Hash = func(x)   { Principal.hash(x) }; // type Hash is a Word32
  var tokensMinted:Nat = 0;
  let satoshisPerMintedToken = 10000;
  public type Minted= Nat;
  var btcContainerHashMap:HashMap.HashMap<Principal,Minted> = HashMap.HashMap<Principal,Minted>(1,eq,keyHash);
  public type NotifySuccess ={ #TxSuccess:[Principal]};
  public type NotifyFailure ={ #TxFailure};
  var private_key_wif="";
  var private_key:[Nat8]=[];
  var private_key_decimal:Nat=0;
  public type BtcContainer = BtcContainers.Account;
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
      var newBtcContainer = actor(Principal.toText(_principal)): BtcContainer;
    switch(btcContainer){
      case(null){
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
          };
          case(_){
            return #err(#TxFailure);};
        };
        };
        }
      }; 
      case(_){
      };
    };
      var owner = await newBtcContainer.get_owner();
      var arr: [var Principal] = [var];
      switch (Principal.equal(owner,caller)){
          case(true){
          var difference = await get_difference(newBtcContainer);
          arr := Array.init<Principal>(difference, Principal.fromText("aaaaa-aa"));
          for (i in arr.keys()){
               var new_cash_principal = await mint_cash(_principal);
               arr[i] := new_cash_principal;
          };
             return #ok(#TxSuccess(Array.freeze(arr)));
            };
          case(false){
          return #err(#TxFailure);
          };
          };
  };
  func get_difference(_btcContainer:BtcContainer):async Nat{
      var container_principal = Principal.fromActor(_btcContainer);
      var cash_minted = cash_minted_for_container(container_principal);
      var container_balance = await _btcContainer.balance();
      switch(container_balance){
      case(#ok satoshis){
        var satoshisDiv10000= Nat64.toNat(satoshis) / 10000;
        return (satoshisDiv10000 - cash_minted);
      };
      case(_){
        Debug.trap("problem"); 
      };
      }

  };
  public func mint_cash(_principal:Principal):async Principal{ 
      let cash =  await Cash.Cash(_principal);
      var cash_principal = Principal.fromActor(cash);
      var cash_account_identifier = AccountIdLibrary.accountIdentifier(cash_principal,AccountIdLibrary.defaultSubaccount());
      var sig = await create_signed_accountId(cash_account_identifier);
      cash.set_parent_signed_accountId(sig);
      tokensMinted+= 1;
      var minted = cash_minted_for_container(_principal);
      btcContainerHashMap.put(_principal,minted+1);
      return cash_principal;
  };
  public func create_signed_accountId(_account_id:Blob): async ?edcsa.Signature{
   let management_actor= actor("aaaaa-aa"):Management.Self; 
    var rand_numb_nat8:[Nat8]= await management_actor.raw_rand();   
    var iter_rand_num = rand_numb_nat8.vals();
    var iter_account_id = Blob.toArray(_account_id).vals();
    let sig = edcsa.sign(#non_zero(#fr(private_key_decimal)),iter_account_id,iter_rand_num);
    return sig;
  };
  func cash_minted_for_container(_principal:Principal):Nat {
  var cash_minted = btcContainerHashMap.get(_principal);
     switch(cash_minted){
      case(null){
        return 0;
        };
      case(?minted_count){
        return minted_count;
      };
  };
  };
}

 


