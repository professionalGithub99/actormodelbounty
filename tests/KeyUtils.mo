import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Debug "mo:base/Debug";  
import Char "mo:base/Char";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";
import HashMap "mo:base/HashMap";  
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Management "./management";
import BtcEncryption "./BitcoinEncryption";
import Utils "./Utils";
module{
    public func generate_private_key():async (Text,[Nat8],Nat)
    {
    let management_actor= actor("aaaaa-aa"):Management.Self;
    var private_key_nat8:[Nat8]= await management_actor.raw_rand();
    var private_key_wif=BtcEncryption.private_key_to_WIF(private_key_nat8);
    var private_key_decimal= Utils.bytes_to_decimal(private_key_nat8);
    return (private_key_wif,private_key_nat8,private_key_decimal);
    };
}
