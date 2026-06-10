{
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonPackage (finalAttrs: {
  pname = "vcdvcd";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cirosantilli";
    repo = "vcdvcd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o2QqTwAjbPb4sj2YI2RKTfvEflITusSzkjbbPMoUBGE=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "test.py"
  ];

  pythonImportsCheck = ["vcdvcd"];
})
