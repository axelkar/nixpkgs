{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, black
}:
let
  pname = "libgravatar";
  version = "1.0.4";
in buildPythonPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "pabluk";
    repo = pname;
    rev = version;
    hash = "sha256-rJv/jfdT+JldxR0kKtXQLOI5wXQYSQRWJnqwExwWjTA=";
  };

  nativeCheckInputs = [
    pytest
    black
  ];
  checkPhase = ''
    runHook preCheck

    pytest --doctest-modules --verbose
    black . --check --diff

    runHook postCheck
  '';

  meta = with lib; {
    description = "A library that provides a Python 3 interface for the Gravatar API";
    homepage = "https://github.com/pabluk/libgravatar";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ axelkar ];
  };
}
