SHELL := /bin/bash

all: build lint unit-tests deploy get-environment-url

clean: undeploy
	rm -rf node_modules

build: prereqs
	npm ci

lint: prereqs
	npm run lint

unit-tests: prereqs
	npm run test

deploy: prereqs
	npm run sls:deploy -- --stage ${STAGE}

get-environment-url: prereqs
	PRINT_OUT=$$(npm run sls:print -- --stage ${STAGE}); \
	OUT_URL=$$(echo $${PRINT_OUT} | { grep -Eo "environment-url: (http|https)://[a-zA-Z0-9./?=_%:-]*" || true; } | head -1); \
	if [ "$${OUT_URL}" != "" ]; then \
		echo "Found environment-url from 'sls print' results"; \
		echo $${OUT_URL}; \
		exit 0; \
	fi

undeploy: prereqs
	npm run sls:remove -- --stage ${STAGE}

prereqs:
	@if [ "${STAGE}" == "" ]; then \
		echo "ENV STAGE is required"; \
		exit 1; \
	fi
