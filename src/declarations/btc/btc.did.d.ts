import type { Principal } from '@dfinity/principal';
export type GetBalanceError = { 'MalformedAddress' : null };
export interface GetBalanceRequest {
  'address' : string,
  'min_confirmations' : [] | [number],
}
export type GetUtxosError = { 'MalformedAddress' : null };
export interface GetUtxosRequest {
  'offset' : [] | [number],
  'address' : string,
  'min_confirmations' : [] | [number],
}
export interface OutPoint { 'txid' : Array<number>, 'vout' : number }
export type Satoshi = bigint;
export type SendTransactionError = { 'MalformedTransaction' : null };
export interface SendTransactionRequest { 'transaction' : Array<number> }
export interface Utxo {
  'height' : number,
  'confirmations' : number,
  'value' : Satoshi,
  'outpoint' : OutPoint,
}
export interface _SERVICE {
  'get_balance' : (arg_0: GetBalanceRequest) => Promise<
      { 'Ok' : Satoshi } |
        { 'Err' : [] | [GetBalanceError] }
    >,
  'get_utxos' : (arg_0: GetUtxosRequest) => Promise<
      { 'Ok' : { 'utxos' : Array<Utxo>, 'total_count' : number } } |
        { 'Err' : [] | [GetUtxosError] }
    >,
  'send_transaction' : (arg_0: SendTransactionRequest) => Promise<
      { 'Ok' : null } |
        { 'Err' : [] | [SendTransactionError] }
    >,
}
