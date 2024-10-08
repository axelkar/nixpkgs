{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "leveldb";
  version = "0.201";

  pyproject = true;

  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cffe776842917e09f073bd6ea5856c64136aebddbe51bd17ea29913472fecbf";
  };

  nativeBuildInputs = [ setuptools ];

  meta = with lib; {
    homepage = "https://code.google.com/archive/p/py-leveldb/";
    description = "Thread-safe Python bindings for LevelDB";
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    license = licenses.bsd3;
    maintainers = [ maintainers.aanderse ];
  };
}
