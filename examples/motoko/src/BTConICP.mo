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
import Common "canister:btc-example-common";
import edcsa "mo:edcsa/lib";
actor WrappedBitcoin{
  type Account=Accounts.Account;
  let canister_private_key="L5EZftvrYaSudiozVRzTqLcHLNDoVn7H5HSfM9BAN6tMJX8oTWz6";
  public shared({caller}) func createAccount(): async Result.Result<Types.TxSuccess,?Types.TxError>
  {
    let a = await Accounts.Account({bitcoin_canister_id= Principal.fromActor(btc)},caller);
        let management_actor= actor("aaaaa-aa"):Management.Self; 
    await management_actor.update_settings({canister_id = Principal.fromActor(a);settings={freezing_threshold = null; controllers=?[ Principal.fromActor(a)];memory_allocation = null;compute_allocation = null} });
    return #ok(#TxSuccess(Principal.fromActor(a)));
  };
  public func get_public_key():async Text 
  {
    return await Common.get_p2pkh_address(canister_private_key, #Regtest)
  };

}
