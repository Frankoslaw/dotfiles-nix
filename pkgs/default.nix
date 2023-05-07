
{ pkgs ? import <nixpkgs> { }, overrides ? (self: super: { }) }:

with pkgs;

let
  packages = self:
    let callPackage = newScope self;
    in rec {
      velaD = callPackage ./velad.nix { };
    };
in
lib.fix' (lib.extends overrides packages)