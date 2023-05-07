{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let 
in mkShell {
  buildInputs = [
    age
    sops
    nixfmt
    go
    gitleaks
    pre-commit
  ];
}