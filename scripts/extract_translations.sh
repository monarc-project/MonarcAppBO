#!/bin/bash

pushd node_modules/ng_backoffice

if [ -f node_modules/.bin/grunt ]; then
  node_modules/.bin/grunt extract_translations
else
  grunt extract_translations
fi

