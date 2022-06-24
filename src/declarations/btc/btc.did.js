export const idlFactory = ({ IDL }) => {
  const GetBalanceRequest = IDL.Record({
    'address' : IDL.Text,
    'min_confirmations' : IDL.Opt(IDL.Nat32),
  });
  const Satoshi = IDL.Nat64;
  const GetBalanceError = IDL.Variant({ 'MalformedAddress' : IDL.Null });
  const GetUtxosRequest = IDL.Record({
    'offset' : IDL.Opt(IDL.Nat32),
    'address' : IDL.Text,
    'min_confirmations' : IDL.Opt(IDL.Nat32),
  });
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
  const GetUtxosError = IDL.Variant({ 'MalformedAddress' : IDL.Null });
  const SendTransactionRequest = IDL.Record({
    'transaction' : IDL.Vec(IDL.Nat8),
  });
  const SendTransactionError = IDL.Variant({
    'MalformedTransaction' : IDL.Null,
  });
  return IDL.Service({
    'get_balance' : IDL.Func(
        [GetBalanceRequest],
        [IDL.Variant({ 'Ok' : Satoshi, 'Err' : IDL.Opt(GetBalanceError) })],
        [],
      ),
    'get_utxos' : IDL.Func(
        [GetUtxosRequest],
        [
          IDL.Variant({
            'Ok' : IDL.Record({
              'utxos' : IDL.Vec(Utxo),
              'total_count' : IDL.Nat32,
            }),
            'Err' : IDL.Opt(GetUtxosError),
          }),
        ],
        [],
      ),
    'send_transaction' : IDL.Func(
        [SendTransactionRequest],
        [
          IDL.Variant({
            'Ok' : IDL.Null,
            'Err' : IDL.Opt(SendTransactionError),
          }),
        ],
        [],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
