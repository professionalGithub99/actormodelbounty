import type { Principal } from '@dfinity/principal';
export interface InitPayload { 'bitcoin_canister_id' : Principal }
export interface OutPoint { 'txid' : Array<number>, 'vout' : number }
export type Satoshi = bigint;
export interface Utxo {
  'height' : number,
  'confirmations' : number,
  'value' : Satoshi,
  'outpoint' : OutPoint,
}
export interface _SERVICE {
  'balance' : () => Promise<bigint>,
  'btc_address' : () => Promise<string>,
  'get_utxos' : () => Promise<Array<Utxo>>,
  'send' : (arg_0: bigint, arg_1: string) => Promise<undefined>,
}
