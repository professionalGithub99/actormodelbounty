export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'blob_test' : IDL.Func([IDL.Text], [IDL.Vec(IDL.Nat8), IDL.Text], []),
    'decode' : IDL.Func(
        [IDL.Vec(IDL.Nat8)],
        [
          IDL.Nat8,
          IDL.Vec(IDL.Nat8),
          IDL.Vec(IDL.Nat8),
          IDL.Nat8,
          IDL.Opt(IDL.Text),
          IDL.Opt(IDL.Text),
          IDL.Vec(IDL.Nat8),
          IDL.Vec(IDL.Nat8),
          IDL.Opt(IDL.Text),
          IDL.Nat32,
        ],
        [],
      ),
    'management_test' : IDL.Func(
        [],
        [IDL.Vec(IDL.Nat8), IDL.Text, IDL.Vec(IDL.Nat8)],
        [],
      ),
  });
};
export const init = ({ IDL }) => { return []; };
