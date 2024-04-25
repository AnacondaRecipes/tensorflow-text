--- oss_scripts/pip_package/build_pip_package.sh	2024-04-25 11:08:38.358947049 +0200
+++ oss_scripts/pip_package/build_pip_package.sh	2024-04-25 11:09:10.922253580 +0200
@@ -96,7 +96,7 @@
   if is_nightly; then
     $installed_python setup.nightly.py bdist_wheel --universal $plat_name
   else
-    $installed_python setup.py bdist_wheel --universal $plat_name
+    $installed_python setup.py bdist_wheel --universal #$plat_name
   fi
   cp dist/*.whl "${output_dir}"
 }
--- oss_scripts/pip_package/setup.py	2024-04-25 11:07:40.942279825 +0200
+++ oss_scripts/pip_package/setup.py	2024-04-25 11:08:11.231916032 +0200
@@ -73,8 +73,7 @@
     cmdclass={'install': InstallPlatlib},
     distclass=BinaryDistribution,
     install_requires=[
-        'tensorflow>=2.12.0, <2.13; platform_machine != "arm64" or platform_system != "Darwin"',
-        'tensorflow-macos>=2.12.0, <2.13; platform_machine == "arm64" and platform_system == "Darwin"',
+        'tensorflow>=2.12.0, <2.13',
         'tensorflow_hub>=0.8.0',
     ],
     extras_require={
--- oss_scripts/run_build.sh	2024-04-25 11:11:43.961088052 +0200
+++ oss_scripts/run_build.sh	2024-04-25 11:12:14.342522970 +0200
@@ -15,14 +15,14 @@
 source oss_scripts/configure.sh
 
 # Verify correct version of Bazel
-installed_bazel_version=$(bazel version | grep label | sed -e 's/.*: //')
-tf_bazel_version=$(cat .bazelversion)
-if [ "$installed_bazel_version" != "$tf_bazel_version" ]; then
-  echo "Incorrect version of Bazel installed."
-  echo "Version $tf_bazel_version should be installed, but found version ${installed_bazel_version}."
-  echo "Run oss_scripts/install_bazel.sh or manually install the correct version."
-  exit 1
-fi
+# installed_bazel_version=$(bazel version | grep label | sed -e 's/.*: //')
+# tf_bazel_version=$(cat .bazelversion)
+# if [ "$installed_bazel_version" != "$tf_bazel_version" ]; then
+#   echo "Incorrect version of Bazel installed."
+#   echo "Version $tf_bazel_version should be installed, but found version ${installed_bazel_version}."
+#   echo "Run oss_scripts/install_bazel.sh or manually install the correct version."
+#   exit 1
+# fi
 
 # Set tensorflow version
 if [[ $osname != "darwin" ]] || [[ ! $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
--- oss_scripts/run_tests.sh	2024-04-25 11:11:51.311956407 +0200
+++ oss_scripts/run_tests.sh	2024-04-25 11:14:50.211031947 +0200
@@ -6,18 +6,18 @@
 ./oss_scripts/configure.sh
 
 # Verify correct version of Bazel
-installed_bazel_version=$(bazel version | grep label | sed -e 's/.*: //')
-tf_bazel_version=$(cat .bazelversion)
-if [ "$installed_bazel_version" != "$tf_bazel_version" ]; then
-  echo "Incorrect version of Bazel installed."
-  echo "Version $tf_bazel_version should be installed, but found version ${installed_bazel_version}."
-  echo "Run oss_scripts/install_bazel.sh or manually install the correct version."
-  exit 1
-fi
+# installed_bazel_version=$(bazel version | grep label | sed -e 's/.*: //')
+# tf_bazel_version=$(cat .bazelversion)
+# if [ "$installed_bazel_version" != "$tf_bazel_version" ]; then
+#   echo "Incorrect version of Bazel installed."
+#   echo "Version $tf_bazel_version should be installed, but found version ${installed_bazel_version}."
+#   echo "Run oss_scripts/install_bazel.sh or manually install the correct version."
+#   exit 1
+# fi
 
 # Set tensorflow version
-if [[ $osname != "Darwin" ]] || [[ ! $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
-  source oss_scripts/prepare_tf_dep.sh
-fi
+# if [[ $osname != "Darwin" ]] || [[ ! $(sysctl -n machdep.cpu.brand_string) =~ "Apple" ]]; then
+#   source oss_scripts/prepare_tf_dep.sh
+# fi
 
-bazel test --test_output=errors --keep_going --jobs=1 tensorflow_text:all
+bazel test --test_output=errors --keep_going tensorflow_text:all
