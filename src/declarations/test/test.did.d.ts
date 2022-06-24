import type { Principal } from '@dfinity/principal';
export interface _SERVICE {
  'blob_test' : (arg_0: string) => Promise<[Array<number>, string]>,
  'decode' : (arg_0: Array<number>) => Promise<
      [
        number,
        Array<number>,
        Array<number>,
        number,
        [] | [string],
        [] | [string],
        Array<number>,
        Array<number>,
        [] | [string],
        number,
      ]
    >,
  'management_test' : () => Promise<[Array<number>, string, Array<number>]>,
}
