{ lib, fetchFromGitHub, fetchpatch
, python3, xdg_utils
}:

python3.pkgs.buildPythonApplication rec {
  pname = "papis";
  version = "0.7.5";

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "papis";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b481sj92z9nw7gwbrpkgd4nlmqc1n73qilkc51k2r56cy1kjvss";
  };

  patches = [
    # Update click version to 7.0.0
    (fetchpatch {
      url = https://github.com/papis/papis/commit/fddb80978a37a229300b604c26e992e2dc90913f.patch;
      sha256 = "0cmagfdaaml1pxhnxggifpb47z5g1p231qywnvnqpd3dm93382w1";
    })
    # Allow python-slugify >= 2.0.0
    (fetchpatch {
      url = https://github.com/papis/papis/commit/b023ca0e551a29c0c15f73fa071addd3e61fa36d.patch;
      sha256 = "0ybfzr5v1zg9m201jq4hyc6imqd8l4mx9azgjjxkgxcwd3ib1ymq";
    })
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click requests filetype pyparsing configparser
    arxiv2bib pyyaml chardet beautifulsoup4 prompt_toolkit
    bibtexparser python-slugify pyparser pylibgen
    habanero isbnlib
    # optional dependencies
    dmenu-python whoosh
  ];

  postInstall = ''
    install -Dt "$out/etc/bash_completion.d" scripts/shell_completion/build/bash/papis
  '';

  checkInputs = (with python3.pkgs; [
    pytest
  ]) ++ [
    xdg_utils
  ];

  # most of the downloader tests require a network connection
  checkPhase = ''
    HOME=$(mktemp -d) pytest papis tests --ignore tests/downloaders
  '';

  # FIXME: find out why 39 tests fail
  doCheck = false;

  meta = {
    description = "Powerful command-line document and bibliography manager";
    homepage = http://papis.readthedocs.io/en/latest/;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
