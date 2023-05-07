{ mkShell
, nodejs-19_x
}:

mkShell {
  packages = [
    nodejs-19_x
  ];

  inputsFrom = [ go ];
}