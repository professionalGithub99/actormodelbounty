import Array "mo:base/Array";
import BtcEncryption "../../../tests/BitcoinEncryption";
import Management "../../../tests/management";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Result "mo:base/Result";
import TrieSet "mo:base/TrieSet";

import Common "canister:btc-example-common";
import Types "Types";
import Utils "Utils";


actor class Account(payload : Types.InitPayload, _owner : Principal) = this{

    private stable var owner = _owner;

    public shared({caller}) func transfer_canister(_newOwner:Principal):async Result.Result<Types.TxSuccess,?Types.TxError>{
    assert(caller == owner);
    owner := _newOwner;
    return #ok(#TxSuccess(Principal.fromActor(this)));
    };

    public query func get_owner():async Principal{
    return owner;
    };
    // Actor definition to handle interactions with the BTC canister.
    type BTC = actor {
        // Gets the balance from the BTC canister.
        get_balance : Types.GetBalanceRequest -> async Types.GetBalanceResponse;
        // Retrieves the UTXOs from the BTC canister.
        get_utxos : Types.GetUtxosRequest -> async Types.GetUtxosResponse;
        // Sends a transaction to the BTC canister.
        send_transaction : (Types.SendTransactionRequest) -> async Types.SendTransactionResponse;
    };

    // The canister's private key in "Wallet Import Format".  
    private stable var PRIVATE_KEY_WIF : Text = "";
    // Used to interact with the BTC canister.
    let btc : BTC = actor(Principal.toText(payload.bitcoin_canister_id));
    // Stores outpoints the have been spent.
    let spent_outpoints : Utils.OutPointSet = Utils.OutPointSet();

    // Retrieves the BTC address using the common canister.
    public func btc_address() : async Text {
    if(PRIVATE_KEY_WIF == "") {
        PRIVATE_KEY_WIF := await generate_private_key();
    };
        await Common.get_p2pkh_address(PRIVATE_KEY_WIF, #Regtest)
    };

    // Retrieves the canister's balance from the BTC canister.
    public func balance() : async Result.Result<Types.Satoshi, ?Types.GetBalanceError> {
        let address : Text = await btc_address();
        switch (await btc.get_balance({ address=address; min_confirmations=?6 })) {
            case (#Ok(satoshi)) {
                #ok(satoshi)
            };
            case (#Err(err)) {
                #err(err)
            };
        }
    };
    

  public func generate_private_key():async Text{
    let management_actor= actor("aaaaa-aa"):Management.Self; 
    var rand_priv_key_nat8:[Nat8]= await management_actor.raw_rand();
    var priv_key_wif=BtcEncryption.private_key_to_WIF(rand_priv_key_nat8);
    return priv_key_wif;
  };



    // Used to retrieve the UTXOs and process the response.
    func get_utxos_internal(address : Text) : async Result.Result<Types.GetUtxosData, ?Types.GetUtxosError> {
        let result = await btc.get_utxos({
            address=address;
            min_confirmations=?0
        });
        switch (result) {
            case (#Ok(response)) {
                #ok(response)
            };
            case (#Err(err)) {
                #err(err)
            };
        }
    };

    // Exposes the `get_utxos_internal` as and endpoint.
    public func get_utxos() : async Result.Result<Types.GetUtxosData, ?Types.GetUtxosError> {
        let address : Text = await btc_address();
        await get_utxos_internal(address)
    };

    func is_spent_outpoint(utxo : Types.Utxo) : Bool {
        not spent_outpoints.contains(utxo.outpoint) 
    };

    // Allows Bitcoin to be sent from the canister to a BTC address.
    public func send(amount: Types.Satoshi, destination: Text) : async Result.Result<(), Types.SendError> {
        // Assuming a fixed fee of 10k satoshis.
        let fees : Nat64 = 10_000;
        let source : Text = await btc_address();
        let utxos_response = await get_utxos_internal(source);
        let utxos_data = switch (utxos_response) {
            case (#ok(data)) {
                data 
            };
            case (#err(?error)) {
                switch (error) {
                    case (#MalformedAddress) {
                        return #err(#MalformedSourceAddress);
                    }
                }
            };
            case (#err(null)) {
                return #err(#Unknown);
            };
        };

        let filtered_utxos = Array.filter(utxos_data.utxos, is_spent_outpoint);
        if (filtered_utxos.size() == 0) {
            return #err(#InsufficientBalance);
        };

        let build_transaction_result = await Common.build_transaction(filtered_utxos, source, destination, amount, fees);
        let (tx, used_utxo_indices) = switch (build_transaction_result) {
            case (#Ok(result)) {
                result
            };
            case (#Err(error)) {
                return #err(error);
            };
        };

        for (index in used_utxo_indices.vals()) {
            let i : Nat = Nat64.toNat(index);
            spent_outpoints.add(filtered_utxos[i].outpoint);
        };

        let sign_transaction_result = await Common.sign_transaction(PRIVATE_KEY_WIF, tx, source);
        let signed_tx = switch (sign_transaction_result) {
            case (#Ok(signed_tx)) {
                signed_tx
            };
            case (#Err(error)) {
                return #err(error);
            };
        };

        let send_transaction_response = await btc.send_transaction({ transaction=signed_tx });
        switch (send_transaction_response) {
            case (#Ok) {
                #ok(())
            };
            case (#Err(?error)) {
                #err(error);
            };
            case (#Err(null)) {
                #err(#Unknown);
            };
        }
    };
};
