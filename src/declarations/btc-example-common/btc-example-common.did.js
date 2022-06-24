export const idlFactory = ({ IDL }) => {
  const Satoshi = IDL.Nat64;
  const OutPoint = IDL.Record({
    'txid' : IDL.Vec(IDL.Nat8),
    'vout' : IDL.Nat32,
  });
  const Utxo = IDL.Record({
    'height' : IDL.Nat32,
    'confirmations' : IDL.Nat32,
    'value' : Satoshi,
    'outpoint' : OutPoint,
  });
  const BuildTransactionError = IDL.Variant({
    'MalformedDestinationAddress' : IDL.Null,
    'InsufficientBalance' : IDL.Null,
    'MalformedSourceAddress' : IDL.Null,
  });
  const Network = IDL.Variant({
    'Regtest' : IDL.Null,
    'Testnet' : IDL.Null,
    'Bitcoin' : IDL.Null,
    'Signet' : IDL.Null,
  });
  const SignTransactionError = IDL.Variant({
    'MalformedTransaction' : IDL.Null,
    'MalformedSourceAddress' : IDL.Null,
    'InvalidPrivateKeyWif' : IDL.Null,
  });
  return IDL.Service({
    'build_transaction' : IDL.Func(
        [IDL.Vec(Utxo), IDL.Text, IDL.Text, Satoshi, Satoshi],
        [
          IDL.Variant({
            'Ok' : IDL.Tuple(IDL.Vec(IDL.Nat8), IDL.Vec(IDL.Nat64)),
            'Err' : BuildTransactionError,
          }),
        ],
        ['query'],
      ),
    'get_p2pkh_address' : IDL.Func([IDL.Text, Network], [IDL.Text], ['query']),
    'sign_transaction' : IDL.Func(
        [IDL.Text, IDL.Vec(IDL.Nat8), IDL.Text],
        [
          IDL.Variant({
            'Ok' : IDL.Vec(IDL.Nat8),
            'Err' : SignTransactionError,
          }),
        ],
        ['query'],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
