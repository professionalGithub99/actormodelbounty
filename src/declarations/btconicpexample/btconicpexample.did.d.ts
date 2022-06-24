import type { Principal } from '@dfinity/principal';
export interface Account {
  'balance' : () => Promise<Result_2>,
  'btc_address' : () => Promise<string>,
  'get_utxos' : () => Promise<Result_1>,
  'send' : (arg_0: Satoshi, arg_1: string) => Promise<Result>,
}
export type GetBalanceError = { 'MalformedAddress' : null };
export interface GetUtxosData { 'utxos' : Array<Utxo>, 'total_count' : number }
export type GetUtxosError = { 'MalformedAddress' : null };
export interface OutPoint { 'txid' : Array<number>, 'vout' : number }
export type Result = { 'ok' : null } |
  { 'err' : SendError };
export type Result_1 = { 'ok' : GetUtxosData } |
  { 'err' : [] | [GetUtxosError] };
export type Result_2 = { 'ok' : Satoshi } |
  { 'err' : [] | [GetBalanceError] };
export type Satoshi = bigint;
export type SendError = { 'MalformedDestinationAddress' : null } |
  { 'InsufficientBalance' : null } |
  { 'MalformedTransaction' : null } |
  { 'Unknown' : null } |
  { 'MalformedSourceAddress' : null } |
  { 'InvalidPrivateKeyWif' : null };
export type TxReceipt = { 'Ok' : bigint } |
  {
    'Err' : { 'InsufficientAllowance' : null } |
      { 'InsufficientBalance' : null } |
      { 'ErrorOperationStyle' : null } |
      { 'Unauthorized' : null } |
      { 'LedgerTrap' : null } |
      { 'ErrorTo' : null } |
      { 'Other' : string } |
      { 'BlockUsed' : null } |
      { 'AmountTooSmall' : null }
  };
export interface Utxo {
  'height' : number,
  'confirmations' : number,
  'value' : Satoshi,
  'outpoint' : OutPoint,
}
export interface _SERVICE {
  'close_invoice' : () => Promise<[string, bigint]>,
  'create_or_view_current_deposit_invoice' : () => Promise<
      [string, string, bigint]
    >,
  'generate_private_key' : () => Promise<string>,
  'get_account_balance' : () => Promise<[string, bigint]>,
  'get_address_balance' : (arg_0: string) => Promise<[string, bigint]>,
  'get_balance' : (arg_0: Principal) => Promise<bigint>,
  'get_utxos' : () => Promise<Result_1>,
  'invoice_to_used_accounts' : (arg_0: Principal, arg_1: bigint) => Promise<
      undefined
    >,
  'mint' : (arg_0: Principal, arg_1: bigint) => Promise<bigint>,
  'print_used_accounts' : () => Promise<Array<bigint>>,
  'send' : (arg_0: Principal, arg_1: bigint) => Promise<TxReceipt>,
  'send_btc' : (arg_0: string, arg_1: bigint, arg_2: string) => Promise<
      [string, bigint]
    >,
  'send_from_invoice' : (arg_0: bigint, arg_1: string) => Promise<undefined>,
  'sort_used_accounts' : () => Promise<undefined>,
  'totalSupply' : () => Promise<bigint>,
  'unwrap_btc' : (arg_0: bigint, arg_1: string) => Promise<Array<bigint>>,
}
