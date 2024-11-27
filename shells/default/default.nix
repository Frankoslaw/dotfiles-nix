{pkgs, ...}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    age
    sops
    git
    treefmt
    alejandra
    python310Packages.mdformat
    shfmt
    go
    gitleaks
    pre-commit
    python310
    python310Packages.pre-commit-hooks
    deploy-rs
  ];
}
