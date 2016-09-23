run_in_java() {
  local java_version=$1
  shift
  env JAVA_HOME=$(java_home $java_version) $@
}

java_home() {
  /usr/libexec/java_home -v ${1}
}

java6() {
  run_in_java 1.6 $@
}

java7() {
  run_in_java 1.7 $@
}

java8() {
  run_in_java 1.8 $@
}
