{ channels, ... }: final: prev: {
  sunshine = channels.unstable.sunshine.override { cudaSupport = true; };
}