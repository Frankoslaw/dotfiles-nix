{pkgs, ...}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    age
    sops
    git
    treefmt
    alejandra
    python313Packages.mdformat
    shfmt
    go
    gitleaks
    pre-commit
    python313
    python313Packages.pre-commit-hooks
    deploy-rs
    nixos-anywhere
    ssh-to-age
  ];
}
