source gen-bazel-toolchain

export BAZEL_CXXOPTS="-isysroot:${CONDA_BUILD_SYSROOT}"
export BAZEL_COPTS="-isysroot:${CONDA_BUILD_SYSROOT}"

cat >> .bazelrc <<EOF
build --crosstool_top=//bazel_toolchain:toolchain
build --logging=6
build --verbose_failures
build --toolchain_resolution_debug
build --define=PREFIX=${PREFIX}
build --define=PROTOBUF_INCLUDE_PATH=${PREFIX}/include
build --local_cpu_resources=${CPU_COUNT}"
EOF

./oss_scripts/run_build.sh

$PYTHON -m pip install . -vv --no-deps --no-build-isolation