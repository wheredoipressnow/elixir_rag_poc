{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  languages.elixir.enable = true;
  languages.elixir.package = pkgs.beam27Packages.elixir_1_19;

  git-hooks.hooks.mix-format.enable = true;
}
