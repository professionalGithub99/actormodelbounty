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
  const GetUtxosData = IDL.Record({
    'utxos' : IDL.Vec(Utxo),
    'total_count' : IDL.Nat32,
  });
  const GetUtxosError = IDL.Variant({ 'MalformedAddress' : IDL.Null });
  const Result_1 = IDL.Variant({
    'ok' : GetUtxosData,
    'err' : IDL.Opt(GetUtxosError),
  });
  const GetBalanceError = IDL.Variant({ 'MalformedAddress' : IDL.Null });
  const Result_2 = IDL.Variant({
    'ok' : Satoshi,
    'err' : IDL.Opt(GetBalanceError),
  });
  const SendError = IDL.Variant({
    'MalformedDestinationAddress' : IDL.Null,
    'InsufficientBalance' : IDL.Null,
    'MalformedTransaction' : IDL.Null,
    'Unknown' : IDL.Null,
    'MalformedSourceAddress' : IDL.Null,
    'InvalidPrivateKeyWif' : IDL.Null,
  });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : SendError });
  const Account = IDL.Service({
    'balance' : IDL.Func([], [Result_2], []),
    'btc_address' : IDL.Func([], [IDL.Text], []),
    'get_utxos' : IDL.Func([], [Result_1], []),
    'send' : IDL.Func([Satoshi, IDL.Text], [Result], []),
  });
  const TxReceipt = IDL.Variant({
    'Ok' : IDL.Nat,
    'Err' : IDL.Variant({
      'InsufficientAllowance' : IDL.Null,
      'InsufficientBalance' : IDL.Null,
      'ErrorOperationStyle' : IDL.Null,
      'Unauthorized' : IDL.Null,
      'LedgerTrap' : IDL.Null,
      'ErrorTo' : IDL.Null,
      'Other' : IDL.Text,
      'BlockUsed' : IDL.Null,
      'AmountTooSmall' : IDL.Null,
    }),
  });
  return IDL.Service({
    'close_invoice' : IDL.Func([], [IDL.Text, IDL.Nat64], []),
    'create_or_view_current_deposit_invoice' : IDL.Func(
        [],
        [IDL.Text, IDL.Text, IDL.Nat64],
        [],
      ),
    'generate_private_key' : IDL.Func([], [IDL.Text], []),
    'get_account_balance' : IDL.Func([], [IDL.Text, IDL.Nat64], []),
    'get_address_balance' : IDL.Func([IDL.Text], [IDL.Text, IDL.Nat64], []),
    'get_balance' : IDL.Func([IDL.Principal], [IDL.Nat64], []),
    'get_utxos' : IDL.Func([], [Result_1], []),
    'invoice_to_used_accounts' : IDL.Func([Account, IDL.Nat64], [], ['oneway']),
    'mint' : IDL.Func([IDL.Principal, IDL.Nat64], [IDL.Nat64], []),
    'print_used_accounts' : IDL.Func([], [IDL.Vec(IDL.Nat64)], []),
    'send' : IDL.Func([IDL.Principal, IDL.Nat64], [TxReceipt], []),
    'send_btc' : IDL.Func(
        [IDL.Text, IDL.Nat64, IDL.Text],
        [IDL.Text, IDL.Nat64],
        [],
      ),
    'send_from_invoice' : IDL.Func([IDL.Nat64, IDL.Text], [], ['oneway']),
    'sort_used_accounts' : IDL.Func([], [], ['oneway']),
    'totalSupply' : IDL.Func([], [IDL.Nat64], []),
    'unwrap_btc' : IDL.Func([IDL.Nat64, IDL.Text], [IDL.Vec(IDL.Nat64)], []),
  });
};
export const init = ({ IDL }) => { return []; };
