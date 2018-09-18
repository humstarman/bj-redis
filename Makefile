SHELL=/bin/bash
MANIFEST=./manifest
IMAGE=10.254.0.50:5000/redis:3.2

all: build push deploy

build:
	@docker build -t ${IMAGE} .

push:
	@docker push ${IMAGE}

deploy: OP=create
deploy:
	@kubectl ${OP} -f ${MANIFEST}/.

clean: OP=delete
clean:
	@kubectl ${OP} -f ${MANIFEST}/.
