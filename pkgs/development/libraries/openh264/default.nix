{ lib, stdenv, fetchFromGitHub, nasm }:

stdenv.mkDerivation rec {
  pname = "openh264";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ffav46pz3sbj92nipd62z03fibyqgclfq9w8lgr80s6za6zdk5s";
  };

  nativeBuildInputs = [ nasm ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
    "ARCH=${(
      if stdenv.hostPlatform.gcc ? arch
      then stdenv.hostPlatform.gcc.arch
      else stdenv.hostPlatform.parsed.cpu.name
    )}"
  ;

  meta = with lib; {
    description = "A codec library which supports H.264 encoding and decoding";
    homepage = "https://www.openh264.org";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
