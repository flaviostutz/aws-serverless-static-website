build:
	npm ci

lint:
	npm run lint

unit-tests:
	npm run test

deploy:
	npm run sls:deploy -- --stage ${STAGE}

