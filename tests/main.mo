import Management "./management";
import BitcoinEncryption "./BitcoinEncryption";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Nat8 "mo:base/Nat8";
import Utils "./Utils";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
actor {
public func management_test():async ([Nat8],Text,[Nat8]) {
   let random_address = actor("aaaaa-aa"):Management.Self;
   var rand_arr:[Nat8]= await random_address.raw_rand();
   var hex_string=Utils.encode(rand_arr);
   var decode_hex=Blob.fromArray([0x62]);
   return (rand_arr,hex_string,[0x62]);
};
public func decode(b:Blob):async (Nat8,Blob,[Nat8],Nat8,?Text,?Text,[Nat8],Blob,?Text,Char) {
  var x:[Nat8]=[0x65];
  var char:Char='a';
   return (Blob.toArray(b)[0],Blob.fromArray([101]),Blob.toArray(Text.encodeUtf8("hello world\n")),Blob.toArray(Text.encodeUtf8("\65"))[0],Text.decodeUtf8(b),Text.decodeUtf8(Blob.fromArray([65])),x,Blob.fromArray([65]),Text.decodeUtf8(Text.encodeUtf8("\65")),char);
};

public func blob_test(private_key:Text):async ([Nat8],Text) {
   var test=Utils.hex_string_to_nat8_array(private_key); 
   var private_as_base58=BitcoinEncryption.private_key_to_WIF(test);
   return (test,private_as_base58);
};
}
