#!/bin/sh

function push {
  git pull --rebase && \
  build && \
  git push
}

function build {
  RAILS_ENV=test bundle exec rake app:db:migrate spec && \
  RAILS_ENV=test bundle exec rake app:coffee:compile_spec app:coffee:compile app:jasmine:ci
}

function guard {
	RAILS_ENV=test bundle exec rake app:db:migrate app:coffee:compile_spec app:coffee:compile && \
  RAILS_ENV=test bundle exec guard
}

function jasmine {
	RAILS_ENV=test bundle exec rake app:jasmine:ci
}

function main {
	case $1 in
		push) push;;
		g) guard;;
		j) jasmine;;
		*) build;;
	esac
}

main $@
