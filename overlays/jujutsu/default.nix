{
  jujutsu,
  jujutsu-version,
  ...
}: final: prev: {
  jujutsu = prev.jujutsu.override {
    rustPlatform.buildRustPackage = args: let
      overridenArgs =
        args
        // {
          version = jujutsu-version;
          src = jujutsu.outPath;
          cargoHash = "sha256-qaLvbcqGGueu1HBDNDTMnjNAwBJTxH2opGnbyS6s2Gc=";
        };
    in
      final.rustPlatform.buildRustPackage overridenArgs;
  };
}
