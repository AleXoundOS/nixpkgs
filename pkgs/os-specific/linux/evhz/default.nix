{ stdenv
, fetchFromSourcehut
, lib
}:

let
  name = "evhz";
  rev = "35b7526e0655522bbdf92f6384f4e9dff74f38a0";
  src = fetchFromSourcehut {
    owner = "~iank";
    repo = name;
    inherit rev;
    sha256 = "1m2m60sh12jzc8f38g7g67b3avx2vg8ff0lai891jmjqvxw04bcl";
  };
  version = builtins.substring 0 7 rev;
in
stdenv.mkDerivation {
  inherit src name version;

  dontPatch = true;
  dontConfigure = true;

  buildPhase = ''
    gcc -Wall -Wextra -Werror evhz.c -o evhz
  '';

  installPhase = ''
    install -m755 evhz -Dt $out/bin
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~iank/evhz";
    description = "Show mouse refresh rate under linux + evdev";
    maintainers = with maintainers; [ mathnerd314 ]; # FIXME
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
