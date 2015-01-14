SHELL := /bin/bash --init-file ./make-scripts/makefile-functions.sh

sources    = $(wildcard src/*.purs)
objects    = $(patsubst src/%.purs, build/scripts/%.js, $(sources))
components = $(shell find bower_components -type f \( -name '*.purs' -and \! -path '*example*' \))

.PHONY: all clean build build/scripts run bower_components

.SUFFIXES: .js .purs

all: clean $(objects)

clean:
	@rm -rf build

bower_components:
	@bower install

build:
	cp -r static build

build/scripts: build bower_components
	@mkdir -p build/scripts

build/scripts/%.js: module = $(notdir $(basename $<))
build/scripts/%.js: src/%.purs build/scripts
	@psc --module=$(module) --main=$(module) --output=$@ $(components) $<

run: all
	@cd build && python -m SimpleHTTPServer
