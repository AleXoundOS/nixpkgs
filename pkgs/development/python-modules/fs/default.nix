{ lib
, glibcLocales
, buildPythonPackage
, fetchPypi
, six
, nose
, appdirs
, scandir
, backports_os
, typing
, pytz
, enum34
, pyftpdlib
, psutil
, mock
, pythonAtLeast
, isPy3k
}:

buildPythonPackage rec {
  pname = "fs";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c3f79a16dfcbf8a8f437f81dd8afaa3741285d9369574c48e1d27e40b0c980e";
  };

  buildInputs = [ glibcLocales ];
  checkInputs = [ nose pyftpdlib mock psutil ];
  propagatedBuildInputs = [ six appdirs pytz ]
    ++ lib.optionals (!isPy3k) [ backports_os ]
    ++ lib.optionals (!pythonAtLeast "3.6") [ typing ]
    ++ lib.optionals (!pythonAtLeast "3.5") [ scandir ]
    ++ lib.optionals (!pythonAtLeast "3.5") [ enum34 ];

  LC_ALL="en_US.utf-8";

  checkPhase = ''
    HOME=$(mktemp -d) nosetests tests []
  '';

  meta = with lib; {
    description = "Filesystem abstraction";
    homepage    = https://github.com/PyFilesystem/pyfilesystem2;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}
