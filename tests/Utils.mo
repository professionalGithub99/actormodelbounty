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
module {
  private let symbols = [
    '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'a', 'b', 'c', 'd', 'e', 'f',
  ];

  private let upper_symbols =['0', '1', '2', '3', '4', '5', '6', '7',
          '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];

  private let base58_symbols=[
    '1', '2', '3', '4', '5', '6', '7', '8',
    '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
    'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q',
    'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y',
    'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g',
    'h', 'i', 'j', 'k', 'm', 'n', 'o', 'p',
    'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
    'y', 'z'
  ];
  private let base : Nat8 = 0x10;
  

  /// Account Identitier type.
  public type AccountIdentifier = {
hash: Blob;
  };

  /// Convert bytes array to hex string.
  /// E.g `[255,255]` to "ffff"
  public func encodeBase58(array : [Nat8]) : Text {
    Array.foldLeft<Nat8, Text>(array, "", func (accum, u8) {
        accum # nat8ToBase58Text(u8);
        });
  };

  /// Convert a byte to hex string.
  /// E.g `255` to "ff"
  func nat8ToBase58Text(u8: Nat8) : Text {
    let c = base58_symbols[Nat8.toNat(u8)];
    return Char.toText(c);
  };

  /// Convert bytes array to hex string.
  /// E.g `[255,255]` to "ffff"
  public func encode(array : [Nat8]) : Text {
    Array.foldLeft<Nat8, Text>(array, "", func (accum, u8) {
        Debug.print(Nat8.toText(u8));
        accum # nat8ToText(u8);
        });
  };

  /// Convert a byte to hex string.
  /// E.g `255` to "ff"
  func nat8ToText(u8: Nat8) : Text {
    let c1 = upper_symbols[Nat8.toNat((u8/base))];
    let c2 = upper_symbols[Nat8.toNat((u8%base))];
    return Char.toText(c1) # Char.toText(c2);
  };


  public func symbol_values(): HashMap.HashMap<Char,Nat8> {
    let Store = HashMap.HashMap<Char,Nat8>(22,func(x,y){x==y},func(x){Hash.hash(Nat32.toNat(Char.toNat32(x)))});
    for(i in Iter.range(0,upper_symbols.size()-1)) {
      Store.put(upper_symbols[i],Nat8.fromNat(i));
    };
    for(j in Iter.range(0,symbols.size()-1)) {
      Store.put(symbols[j],Nat8.fromNat(j));
    };
    return Store;
  };

  //convert a hex string to bytes array
  public func hex_string_to_nat8_array(text: Text) : [Nat8] {
    var symbols_hashmap:HashMap.HashMap<Char,Nat8> = symbol_values();
    var nat8_array:[var Nat8] = Array.init<Nat8>(text.size()/2,0);
    var index =0;
    var total_sum:Nat8=0;
    for(i in Text.toIter(text)){
      var current_symbol = symbols_hashmap.get(i);
      switch(current_symbol){
        case(null){
          Debug.trap("invalid symbol in ur hex string");
        };
        case(?current_symbol){
          if(index%2==0){
            total_sum += current_symbol*16;
          }
          else{
            total_sum+=current_symbol;
            nat8_array[index/2]:=total_sum;
            total_sum:=0;
          };
        };
      };
      index+=1;
    };
    return Array.freeze(nat8_array);
  };

  public func nat8_array_to_text(array : [Nat8]) : Text {
    return Array.foldLeft<Nat8, Text>(array, "", func (accum, u8) {
        accum#","# Nat8.toText(u8);
        });
  };
  public func bytes_to_decimal(array : [Nat8]) : Nat{
    var total_sum=0;
    for (i in Iter.range(0,array.size()-1)) {
       total_sum+= Nat8.toNat(array[i])*Nat.pow(256,array.size()-i-1);
    };
    return total_sum;
  };
  public func decimal_to_base58(decimal:Nat):[Nat8]{
    var base58_buffer:Buffer.Buffer<Nat8> = Buffer.Buffer<Nat8>(100);
    var mutable_decimal:Nat = decimal;
    while(mutable_decimal > 0){
      var remainder_base58:Nat8 = Nat8.fromNat(mutable_decimal%58);
      base58_buffer.add(remainder_base58);
      mutable_decimal := Nat.div(mutable_decimal,58);
    };
    var base58_array:[Nat8]=base58_buffer.toArray();
    var base58_array_reverse:[Nat8] = Array.mapEntries<Nat8,Nat8>(base58_array,func(x,index){return base58_array[base58_array.size()-index-1]});
    return base58_array_reverse;
  };
};
