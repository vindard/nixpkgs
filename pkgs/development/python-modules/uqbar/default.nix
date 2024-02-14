{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, setuptools
, sphinx
, unidecode
}:

buildPythonPackage rec {
  pname = "uqbar";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cEhWXGtMSXVjT5QigDedjT/lwYQnVqPCE5vbctXWznk=";
  };

  postPatch = ''
    sed -i  pyproject.toml \
    -e '/"black"/d' \
    -e "/--cov/d"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    unidecode
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # UnboundLocalError: local variable 'output_path' referenced before assignment
    "test_01"
    # AssertionError: assert False
    "test_sphinx_book_html_cached"
    # FileNotFoundError: [Errno 2] No such file or directory: 'unflatten'
    "test_sphinx_style_html"
    # assert not ["\x1b[91mWARNING: dot command 'dot' cannot be run (needed for
    # graphviz output), check the graphviz_dot setting\x1b[39;49;00m"]
    "test_sphinx_style_latex"
  ]
  # assert not '\x1b[91m/build/uqbar-0.7.0/tests/fake_package/enums.py:docstring
  ++ lib.optional (pythonAtLeast "3.11") [
    "test_sphinx_style"
  ];

  pythonImportsCheck = [
    "uqbar"
  ];

  meta = with lib; {
    description = "Tools for creating Sphinx and Graphviz documentation";
    homepage = "https://github.com/josiah-wolf-oberholtzer/uqbar";
    changelog = "https://github.com/josiah-wolf-oberholtzer/uqbar/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ davisrichard437 ];
  };
}
