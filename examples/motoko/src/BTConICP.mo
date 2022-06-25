import HashMap "mo:base/HashMap";
import Nat64 "mo:base/Nat64";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Types "./Types";
import Debug "mo:base/Debug";
import Hash "mo:base/Hash";
import Accounts "./Account";
import Principal "mo:base/Principal";
import List "mo:base/List";
import btc "canister:btc";
import Account "./Account";
import BtcEncryption "../../../tests/BitcoinEncryption";
import Management "../../../tests/management";
import AssocList "mo:base/AssocList";
import edcsa "mo:edcsa/lib";
import Common "canister:btc-example-common";
import Utils "../../../tests/Utils";

actor WrappedBitcoin{
  type Account=Accounts.Account;
  var private_key_wif="";
  var private_key:[Nat8]=[];
  var private_key_decimal:Nat=0;
  public shared({caller}) func createAccount(): async Result.Result<Types.TxSuccess,?Types.TxError>
  {
    let a = await Accounts.Account({bitcoin_canister_id= Principal.fromActor(btc)},caller);
        let management_actor= actor("aaaaa-aa"):Management.Self; 
    await management_actor.update_settings({canister_id = Principal.fromActor(a);settings={freezing_threshold = null; controllers=?[ Principal.fromActor(a)];memory_allocation = null;compute_allocation = null} });
    return #ok(#TxSuccess(Principal.fromActor(a)));
  };
  
    public func generate_private_key():async (Text,[Nat8],Nat)
    {
    let management_actor= actor("aaaaa-aa"):Management.Self; 
    var rand_priv_key_nat8:[Nat8]= await management_actor.raw_rand();
    private_key := rand_priv_key_nat8;
    private_key_wif:=BtcEncryption.private_key_to_WIF(rand_priv_key_nat8);
    private_key_decimal := Utils.bytes_to_decimal(rand_priv_key_nat8);
    return (private_key_wif,private_key,private_key_decimal);
  };
  public func sign_message(_msg:[Nat8],_rand_numb:[Nat8]):async ?edcsa.Signature{
    var iter_msg=_msg.vals();
    var iter_rand_numb=_rand_numb.vals();
    let sig= edcsa.sign(#non_zero(#fr(private_key_decimal)),iter_msg,iter_rand_numb);
    return sig;
  };
  public func generate_random():async ([Nat8],[Nat8])
  {
    let management_actor= actor("aaaaa-aa"):Management.Self; 
    var rand_numb_nat8:[Nat8]= await management_actor.raw_rand();
    var rand_numb_nat8_2:[Nat8]= await management_actor.raw_rand();
    return (rand_numb_nat8,rand_numb_nat8_2);
  };
  public func verify_message(_msg:[Nat8],_sig:edcsa.Signature,):async Bool{
    var pub_key= edcsa.getPublicKey(#non_zero(#fr(private_key_decimal)));
    var iter_msg=_msg.vals();
    let res= edcsa.verify(pub_key,iter_msg,_sig);
    return res;
  };

}
