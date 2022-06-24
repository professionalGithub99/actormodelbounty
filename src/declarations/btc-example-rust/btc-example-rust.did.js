export const idlFactory = ({ IDL }) => {
  const InitPayload = IDL.Record({ 'bitcoin_canister_id' : IDL.Principal });
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
  return IDL.Service({
    'balance' : IDL.Func([], [IDL.Nat64], []),
    'btc_address' : IDL.Func([], [IDL.Text], ['query']),
    'get_utxos' : IDL.Func([], [IDL.Vec(Utxo)], []),
    'send' : IDL.Func([IDL.Nat64, IDL.Text], [], []),
  });
};
export const init = ({ IDL }) => {
  const InitPayload = IDL.Record({ 'bitcoin_canister_id' : IDL.Principal });
  return [InitPayload];
};
