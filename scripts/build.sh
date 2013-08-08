#!/usr/bin/env bash

# directories
cwd=$(dirname $0)
root=$cwd/..
build=$root/build
src=$root/src
static=$root/static
tmp=$root/tmp

# binaries
coffee=$root/node_modules/coffee-script/bin/coffee

info () {
  echo "[info] $1"
}

refresh () {
  if [[ -d $1 ]]
  then
    info "removing $1"
    rm -rf $1
  fi

  info "making directory '$1'"
  mkdir $1
}

main () {
  info "copying static files to build directory"
  refresh $build
  cp -r $static $build/static

  info "compiling .coffee to .js"
  refresh $tmp
  $coffee -o $tmp/app -cb $src

  info "copying compiled app .js to build/static"
  cp -r $tmp/app $static/js
}

main
