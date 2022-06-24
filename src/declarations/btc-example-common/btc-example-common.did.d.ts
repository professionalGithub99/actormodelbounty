import type { Principal } from '@dfinity/principal';
export type BuildTransactionError = { 'MalformedDestinationAddress' : null } |
  { 'InsufficientBalance' : null } |
  { 'MalformedSourceAddress' : null };
export type Network = { 'Regtest' : null } |
  { 'Testnet' : null } |
  { 'Bitcoin' : null } |
  { 'Signet' : null };
export interface OutPoint { 'txid' : Array<number>, 'vout' : number }
export type Satoshi = bigint;
export type SignTransactionError = { 'MalformedTransaction' : null } |
  { 'MalformedSourceAddress' : null } |
  { 'InvalidPrivateKeyWif' : null };
export interface Utxo {
  'height' : number,
  'confirmations' : number,
  'value' : Satoshi,
  'outpoint' : OutPoint,
}
export interface _SERVICE {
  'build_transaction' : (
      arg_0: Array<Utxo>,
      arg_1: string,
      arg_2: string,
      arg_3: Satoshi,
      arg_4: Satoshi,
    ) => Promise<
      { 'Ok' : [Array<number>, Array<bigint>] } |
        { 'Err' : BuildTransactionError }
    >,
  'get_p2pkh_address' : (arg_0: string, arg_1: Network) => Promise<string>,
  'sign_transaction' : (
      arg_0: string,
      arg_1: Array<number>,
      arg_2: string,
    ) => Promise<{ 'Ok' : Array<number> } | { 'Err' : SignTransactionError }>,
}
