ifeq '$(findstring ;,$(PATH))' ';'
	detected_OS := Windows
else
	detected_OS := $(shell uname 2>/dev/null || echo Unknown)
	detected_OS := $(patsubst CYGWIN%,Cygwin,$(detected_OS))
	detected_OS := $(patsubst MSYS%,MSYS,$(detected_OS))
	detected_OS := $(patsubst MINGW%,MSYS,$(detected_OS))
endif
.EXPORT_ALL_VARIABLES:
CONSUMER := "example-consumer-python"
PROVIDER := "example-provider-python"
PACT_CLI="docker run --rm -v ${PWD}:${PWD} -e PACT_BROKER_BASE_URL -e PACT_BROKER_TOKEN -e PACT_BROKER_USERNAME -e PACT_BROKER_PASSWORD pactfoundation/pact-cli:latest"
PACT_BROKER_BASE_URL?=http://localhost:8000
PACT_BROKER_USERNAME=pact_workshop
PACT_BROKER_PASSWORD=pact_workshop
PACT_CLI_DOCKER="docker run --rm -v ${PWD}:${PWD} --network host -e PACT_BROKER_BASE_URL -e PACT_BROKER_USERNAME -e PACT_BROKER_PASSWORD -e PACT_BROKER_TOKEN pactfoundation/pact-cli"
GIT_COMMIT?=$(shell git rev-parse HEAD)
GIT_BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)

all: test_consumer test_provider
install_consumer:
	cd consumer &&\
	python -m venv .venv &&\
	source .venv/bin/activate &&\
	pip install -r requirements.txt
test_consumer: install_consumer
	cd consumer &&\
	python -m venv .venv &&\
	source .venv/bin/activate &&\
	pytest -vvvvs
install_provider:
	cd provider &&\
	python -m venv .venv &&\
	source .venv/bin/activate &&\
	pip install -r requirements.txt
test_provider:
	cd provider &&\
	python -m venv .venv &&\
	source .venv/bin/activate &&\
	pytest -vvvvs
broker:
	docker-compose up -d
publish_pacts:
	cd consumer &&\
	case "${detected_OS}" in \
		Windows|MSYS|Darwin) PACT_BROKER_BASE_URL=http://host.docker.internal:8000 "${PACT_CLI}" pact-broker publish ${PWD}/consumer/pacts --consumer-app-version ${GIT_COMMIT} --branch ${GIT_BRANCH} ;; \
		*) 	"${PACT_CLI}" pact-broker publish ${PWD}/consumer/pacts --consumer-app-version ${GIT_COMMIT} --branch ${GIT_BRANCH} ;; \
	esac

deploy-consumer: install
	@echo "--- ✅ Checking if we can deploy consumer"
	@pact-broker can-i-deploy \
		--pacticipant $(CONSUMER) \
		--broker-base-url ${PACT_BROKER_PROTO}://$(PACT_BROKER_URL) \
		--broker-username $(PACT_BROKER_USERNAME) \
		--broker-password $(PACT_BROKER_PASSWORD) \
		--version ${GIT_COMMIT} \
		--to-environment production

deploy-provider: install
	@echo "--- ✅ Checking if we can deploy provider"
	@pact-broker can-i-deploy \
		--pacticipant $(PROVIDER) \
		--broker-base-url ${PACT_BROKER_PROTO}://$(PACT_BROKER_URL) \
		--broker-username $(PACT_BROKER_USERNAME) \
		--broker-password $(PACT_BROKER_PASSWORD) \
		--version ${GIT_COMMIT} \
		--to-environment production
record-deploy-consumer: install
	@echo "--- ✅ Recording deployment of consumer"
	pact-broker record-deployment \
		--pacticipant $(CONSUMER) \
		--broker-base-url ${PACT_BROKER_PROTO}://$(PACT_BROKER_URL) \
		--broker-username $(PACT_BROKER_USERNAME) \
		--broker-password $(PACT_BROKER_PASSWORD) \
		--version ${GIT_COMMIT} \
		--environment production
record-deploy-provider: install
	@echo "--- ✅ Recording deployment of provider"
	pact-broker record-deployment \
		--pacticipant $(PROVIDER) \
		--broker-base-url ${PACT_BROKER_PROTO}://$(PACT_BROKER_URL) \
		--broker-username $(PACT_BROKER_USERNAME) \
		--broker-password $(PACT_BROKER_PASSWORD) \
		--version ${GIT_COMMIT} \
		--environment production