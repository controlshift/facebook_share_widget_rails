#!/bin/sh

function push {
  git pull --rebase && \
  build && \
  git push
}

function build {
  RAILS_ENV=test bundle exec rake app:db:drop app:db:create app:db:migrate spec app:coffee:compile_spec app:jasmine:ci
}

function guard {
  RAILS_ENV=test bundle exec guard
}
function main {
	case $1 in
		push) push;;
		g) guard;;
		*) build;;
	esac
}

main $@