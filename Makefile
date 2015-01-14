SHELL := /bin/bash --init-file ./make-scripts/makefile-functions.sh

sources    = $(wildcard src/*.purs)
objects    = $(patsubst src/%.purs, build/scripts/%.js, $(sources))

.PHONY: all clean build build/scripts run

.SUFFIXES: .js .purs

all: clean $(objects)

clean:
	@rm -rf build

build:
	cp -r static build

build/scripts: build
	@mkdir -p build/scripts

build/scripts/%.js: module = $(notdir $(basename $<))
build/scripts/%.js: src/%.purs build/scripts
	psc $< --module=$(module) --main=$(module) --output=$@

run: all
	@cd build && python -m SimpleHTTPServer
