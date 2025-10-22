final: prev: {
  fw-ectool = prev.fw-ectool.overrideAttrs (oldAttrs: {
    env.CMAKE_POLICY_VERSION_MINIMUM = "3.5";
  });

  libvdpau-va-gl = prev.libvdpau-va-gl.overrideAttrs (oldAttrs: {
    env.CMAKE_POLICY_VERSION_MINIMUM = "3.5";
  });
}
