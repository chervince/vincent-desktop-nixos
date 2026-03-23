# Audio PipeWire — remplace PulseAudio
{ ... }:
{
  # Désactive PulseAudio au profit de PipeWire
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Nécessaire pour PipeWire en session utilisateur
  security.rtkit.enable = true;
}
