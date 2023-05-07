{ mkShell
, python3Full
, python310Packages.pip
}:

mkShell {
  packages = [
    python3Full
    python310Packages.pip
  ];

  inputsFrom = [ go ];
}