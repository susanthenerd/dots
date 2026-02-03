{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.llama-server = {
    enable = true;
    package = pkgs.llama-cpp.override {
      rocmGpuTargets = [ "gfx1150" ];
    };
    modelsMax = 4;

    settings = {
      "*" = {
        n-gpu-layers = 99;
        flash-attn = "on";
        sleep-idle-seconds = 300;
      };

      gemma = {
        hf-repo = "ggml-org/gemma-3-4b-it-GGUF:Q4_K_M";
      };

      "glm-4.7-flash" = {
        hf-repo = "unsloth/GLM-4.7-Flash-GGUF:Q4_K_XL";
        temp = "1.0";
        top-p = "0.95";
        min-p = "0.01";
        ctx-size = "16384";
        fit = "on";
        jinja = "on";
      };

      "minimax-m2.1-139b" = {
        hf-repo = "mradermacher/MiniMax-M2.1-REAP-139B-A10B-i1-GGUF:i1-Q4_K_M";
        temp = "1.0";
        top-p = "0.95";
        min-p = "0.01";
        ctx-size = "8192";
        fit = "on";
        jinja = "on";
      };

      # "minimax-m2.1-172b" = {
      #   hf-repo = "mradermacher/MiniMax-M2.1-REAP-172B-A10B-i1-GGUF:Q4_K_S";
      #   temp = "1.0";
      #   top-p = "0.95";
      #   min-p = "0.01";
      #   ctx-size = "196608";
      #   fit = "on";
      #   jinja = "on";
      # };

    };
  };
}
