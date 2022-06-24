import Utils "./Utils";
import Text "mo:base/Text";
import Array "mo:base/Array";
import SHA256 "mo:sha256/SHA256";
module{
  public func private_key_to_WIF(private_key:[Nat8]):Text{
    var concat_array=Array.append<Nat8>([0x80],private_key);
    var first_hash=SHA256.sha256(concat_array);
    var second_hash=SHA256.sha256(first_hash);
    var index=0;
    var first_four_bytes=Array.filter<Nat8>(second_hash,func(x){if(index < 4){index:=index+1;return true;}else{return false;}});
    var concat_array2=Array.append<Nat8>(concat_array,first_four_bytes);
    var decimals_from_concat2=Utils.bytes_to_decimal(concat_array2);
    var base58_array=Utils.decimal_to_base58(decimals_from_concat2);
    var base58_as_text=Utils.encodeBase58(base58_array);
    label l for (i in Text.toIter(Utils.encode(concat_array2))){
    if (i == '0'){
      base58_as_text:="1"#base58_as_text;}
    else{
     break l;
    }
    }; 
    return base58_as_text;
  };
}
