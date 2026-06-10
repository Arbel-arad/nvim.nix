{
  lib,
  stdenv,
  python3Packages,
  fetchPypi,
  scons,
  libusb1,
  tinyprog,
  versionCheckHook,
  callPackage,
  writableTmpDirAsHomeHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "apio";
  version = "1.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-73m4MRzwXVnqwVDbrOy6I5gRjTWMDruAGGoARMGWRk4=";
  };

  postPatch = ''
    sed -i -E "/'(blackiceprog|tinyfpgab|icefunprog)==/d" pyproject.toml

    sed -i -E "s/==[0-9][^']*//g" pyproject.toml

    substituteInPlace apio/managers/scons_manager.py \
      --replace-fail '[sys.executable, "-m", "apio", "--scons"]' \
        "[\"$out/bin/apio\", \"--scons\"]"

    libusb=${lib.getLib libusb1}/lib/libusb-1.0${stdenv.hostPlatform.extensions.sharedLibrary}
    substituteInPlace apio/utils/usb_util.py \
      --replace-fail 'files = glob(str(pattern))' \
        "files = [\"$libusb\"]"
  '';

  build-system = with python3Packages; [
    flit-core
  ];

  dependencies = with python3Packages;
    [
      apollo-fpga
      click
      colorama
      configobj
      debugpy
      invoke
      jsonschema
      packaging
      protobuf
      pyserial
      pyusb
      requests
      rich
      semantic-version
      wheel
    ]
    ++ [
      (callPackage ./vcdvcd.nix {})
      scons
      tinyprog
    ];

  nativeCheckInputs = with python3Packages; [
    writableTmpDirAsHomeHook
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/unit_tests/commands/test_apio.py"
    "tests/unit_tests/commands/test_apio_drivers.py"
    "tests/unit_tests/common/test_apio_console.py"
    "tests/unit_tests/common/test_apio_themes.py"
    "tests/unit_tests/common/test_common_utils.py"
    "tests/unit_tests/managers/test_scons_filters.py"
    "tests/unit_tests/scons/test_apio_env.py"
    "tests/unit_tests/scons/test_plugin_util.py"
    "tests/unit_tests/utils/test_cmd_util.py"
    "tests/unit_tests/utils/test_jsonc.py"
    "tests/unit_tests/utils/test_serial_util.py"
    "tests/unit_tests/utils/test_usb_util.py"
    "tests/unit_tests/utils/test_util.py"
  ];

  disabledTests = [
    "test_style_unstyle"
    "test_release_info"
  ];

  pythonImportsCheck = ["apio"];

  nativeInstallCheckInputs = [versionCheckHook];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  strictDeps = true;
})
