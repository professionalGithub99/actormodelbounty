import BtcContainer "canister:btconicpexample";
import HashMap "mo:base/HashMap";
import Result "mo:base/Result";
import Hash "mo:base/Hash";
import Principal "mo:base/Principal";
import Cash "./cash";
actor BtcFederalReserve {
  let eq: (Principal,Principal)->Bool  = func(x,y) { Principal.equal(x,y) };
  let keyHash: (Principal)->Hash.Hash = func(x)   { Principal.hash(x) }; // type Hash is a Word32
  var tokensMinted:Nat = 0;
  //note the 18 0s are decimals
  public type Balance = Nat64;
  var btcStoreHashMap:HashMap.HashMap<Principal:Balance> = new HashMap.HashMap<Principal:Balance>(1,eq,keyHash);
  var waitingMint:var [var Nat]=[];
  public type NotifySuccess ={ #TxSuccess};
  public type NotifyFailure ={ #TxFailure};
  public func notifyBitcoinContainerDeposit(_principal:Principal):async Result.Result<NotifySuccess,NotifyFailure>{
    var btcContainerOwner= BtcContainer.get_owner();
    if (btcContainerOwner== Principal.fromActor(BtcFederalReserve)){
      var btcContainer = btcStoreHashMap.get(Principal.fromActor(BtcContainer));
      switch(btcContainer){
       case(null){
         return #ok(#TxSuccess);
       }; 
       case(_){
          return #err(#TxFailure);
      };
    }
  };
};
