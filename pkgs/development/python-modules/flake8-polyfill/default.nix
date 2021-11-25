{ lib, fetchFromGitHub, buildPythonPackage
, flake8
, mock, pep8, pytest }:

buildPythonPackage rec {
  pname = "flake8-polyfill";
  version = "2021-11-23";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "c938da9174c57ea39681523fae0b150aba77da76";
    sha256 = "0afpyhid69w0wscbz6qwcqwlyl3f73grfvapksp7w9ri1sb6ynng";
  };

  postPatch = ''
    # Failed: [pytest] section in setup.cfg files is no longer supported, change to [tool:pytest] instead.
    substituteInPlace setup.cfg \
      --replace pytest 'tool:pytest'
  '';

  propagatedBuildInputs = [
    flake8
  ];

  checkInputs = [
    mock
    pep8
    pytest
  ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    homepage = "https://github.com/PyCQA/flake8-polyfill";
    description = "Polyfill package for Flake8 plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
