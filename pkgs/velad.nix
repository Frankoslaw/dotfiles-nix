{ lib
, buildGoModule
, fetchFromGitHub
}:

let
in
buildGoModule rec {
  pname = "velaD";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "kubevela";
    repo = " velad";
    # rev = "v${version}";
    rev = "e689ab1e4587b2e43fa9af03f9c040bb5f5cc3a8";
    sha256 = "0fasi2fx69jml1z06g1d2dc8l5x2qrgvwj8cdyjgc3iwpsackn4g";
  };
  vendorHash = null;

  meta = with lib; {
    homepage = "https://github.com/kubevela/velad";
    description = "Lightweight KubeVela that runs as Daemon in single node with high availability.";
    longDescription = ''
      VelaD is lightweight deployment tool to set up KubeVela.
      VelaD make it very easy to set up KubeVela environment, including a cluster with KubeVela installed, VelaUX/Vela CLI prepared.
      VelaD is the fastest way to get started with KubeVela.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ frankoslaw ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "velad";
  };
}