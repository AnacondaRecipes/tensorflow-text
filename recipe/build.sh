# adding host environment bin to the path because on some platforms it uses _build_env/bin/python
# instead of the host environment python
export PATH=$PREFIX/bin:$PATH

./oss_scripts/run_build.sh

$PYTHON -m pip install tensorflow_text-*.whl -vv --no-deps --no-build-isolation

# tensorflow-datasets not available on py311
if [[ $PY_VER ~= "3.11" ]]
then
    # run the tests here since the build and host requirements are necessary for building
    source ./oss_scripts/run_tests.sh
fi
