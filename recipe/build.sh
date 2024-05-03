if [[ ${HOST} =~ .*darwin.* ]]; then
    # set up bazel config file for conda provided clang toolchain
    cp -r ${RECIPE_DIR}/custom_clang_toolchain .
    cd custom_clang_toolchain
    sed -e "s:\${CLANG}:${CLANG}:" \
        -e "s:\${INSTALL_NAME_TOOL}:${INSTALL_NAME_TOOL}:" \
        -e "s:\${CONDA_BUILD_SYSROOT}:${CONDA_BUILD_SYSROOT}:" \
        -e "s:\${MACOSX_DEPLOYMENT_TARGET}:${MACOSX_DEPLOYMENT_TARGET}:" \
        -e "s:\${LDFLAGS}:${LDFLAGS}:" \
        -e "s:\${CXXFLAGS}:${CFLAGS}:" \
        -e "s:\${PREFIX}:${PREFIX}:" \
        -e "s:\${LIBTOOL}:${LIBTOOL}:" \
        -e "s:\${PY_VER}:${PY_VER}:" \
        cc_wrapper.sh.template > cc_wrapper.sh
    chmod +x cc_wrapper.sh
     sed -e "s:\${PREFIX}:${BUILD_PREFIX}:" \
        -e "s:\${LD}:${LD}:" \
        -e "s:\${NM}:${NM}:" \
        -e "s:\${STRIP}:${STRIP}:" \
        -e "s:\${LIBTOOL}:${LIBTOOL}:" \
        -e "s:\${CONDA_BUILD_SYSROOT}:${CONDA_BUILD_SYSROOT}:" \
        CROSSTOOL.template > CROSSTOOL
    sed -i "" "s:\${PREFIX}:${PREFIX}:" cc_toolchain_config.bzl
    sed -i "" "s:\${BUILD_PREFIX}:${BUILD_PREFIX}:" cc_toolchain_config.bzl
    sed -i "" "s:\${CONDA_BUILD_SYSROOT}:${CONDA_BUILD_SYSROOT}:" cc_toolchain_config.bzl
    sed -i "" "s:\${LD}:${LD}:" cc_toolchain_config.bzl
    sed -i "" "s:\${NM}:${NM}:" cc_toolchain_config.bzl
    sed -i "" "s:\${STRIP}:${STRIP}:" cc_toolchain_config.bzl
    sed -i "" "s:\${LIBTOOL}:${LIBTOOL}:" cc_toolchain_config.bzl
    cd ..
    set
    # set build arguments
    export  BAZEL_USE_CPP_ONLY_TOOLCHAIN=1
    BUILD_OPTS="
        --crosstool_top=//custom_clang_toolchain:toolchain
        --verbose_failures
        --config=opt"
    export TF_ENABLE_XLA=1
fi

export PATH=$PREFIX/bin:$PATH

./oss_scripts/run_build.sh

$PYTHON -m pip install tensorflow_text-*.whl -vv --no-deps --no-build-isolation