let upstream = https://github.com/dfinity/vessel-package-set/releases/download/mo-0.6.21-20220215/package-set.dhall sha256:b46f30e811fe5085741be01e126629c2a55d4c3d6ebf49408fb3b4a98e37589b
let Package =
    { name : Text, version : Text, repo : Text, dependencies : List Text }

let
  -- This is where you can add your own packages to the package-set
  additions =
    [
{ name = "sha256"
   , repo = "https://github.com/enzoh/motoko-sha.git"
   ,version = "master"
   , dependencies = ["base"]
   },
   {name = "edcsa",
   repo = "https://github.com/herumi/ecdsa-motoko.git",
   version ="master", 
   dependencies = ["base","sha2"]},
   {name = "invoice",
   repo = "https://github.com/professionalGithub99/auto-top-up-cycles-invoice-canister.git",
   version ="master", 
   dependencies = ["base"]}
    ] : List Package

let
  {- This is where you can override existing packages in the package-set

     For example, if you wanted to use version `v2.0.0` of the foo library:
     let overrides = [
         { name = "foo"
         , version = "v2.0.0"
         , repo = "https://github.com/bar/foo"
         , dependencies = [] : List Text
         }
     ]
  -}
  overrides =
    [] : List Package

in  upstream # additions # overrides
