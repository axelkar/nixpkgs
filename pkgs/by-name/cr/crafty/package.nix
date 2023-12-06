{ lib
, python3
, python3Packages
, fetchFromGitLab
}:
let
  version = "4.2.1";
in python3Packages.buildPythonApplication {
  pname = "crafty";
  inherit version;

  src = fetchFromGitLab {
    owner = "crafty-controller";
    repo = "crafty-4";
    rev = "v${version}";
    hash = "sha256-k+pDxhCqOrLn05VoWaAQS27qQkUOacdpli5cEkU4A7k=";
  };

  patches = [
    ./add-main-fn.patch
    ./use-embedded-data.patch
    ./use-embedded-dynamic-code.patch
    ./legacy-drop-migrator.patch
    ./large-refactor.patch
  ];

  propagatedBuildInputs = with python3Packages; [
    apscheduler
    argon2-cffi
    cached-property
    colorama
    croniter
    cryptography
    libgravatar
    nh3
    packaging # does this come in by default
    peewee
    psutil
    pyopenssl
    pyjwt
    pyyaml
    requests
    termcolor
    tornado
    tzlocal
    jsonschema
    orjson
    prometheus-client
  ];

  doCheck = false; # python complains about the pip module missing

  preBuild = ''
    mkdir src
    mv main.py app src
    cat > MANIFEST.in << EOF
    recursive-include src/app/config *
    recursive-include src/app/frontend *
    recursive-include src/app/translations *
    EOF
    cat > setup.py << EOF
    from setuptools import setup

    with open('requirements.txt') as f:
        install_requires = f.read().splitlines()

    setup(
      name='crafty',
      version='${version}',
      author='Arcadia Technology, LLC.',
      description='A Game Server Control Panel / Launcher',
      python_requires='>=3.8',
      install_requires=install_requires,
      classifiers = [
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)"
        "Operating System :: OS Independent",
      ],
      include_package_data=True, # This enables MANIFEST.in
      entry_points={
        'console_scripts': [
          'crafty=main:main'
        ]
      },
    )
    EOF
  '';

  meta = with lib; {
    description = "A Game Server Control Panel / Launcher";
    longDescription = ''
      Crafty 4 is the next iteration of our Minecraft Server Wrapper / Controller / Launcher.
      Boasting a clean new look, rebuilt from the ground up. Crafty 4 brings a whole host of
      new features such as Bedrock support. With SteamCMD support on the way!
    '';
    homepage = "https://craftycontrol.com";
    changelog = "https://gitlab.com/crafty-controller/crafty-4/-/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ axelkar ];
  };
}
