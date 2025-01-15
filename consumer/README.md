# Example Python Consumer

![Build](https://github.com/pactflow/example-consumer-python/workflows/Build/badge.svg)

[![Can I deploy Status](https://test.pactflow.io/pacticipants/pactflow-example-consumer-python/branches/master/latest-version/can-i-deploy/to-environment/production/badge.svg)](https://test.pactflow.io/overview/provider/pactflow-example-consumer-python/consumer/pactflow-example-consumer-python)

[![Pact Status](https://test.pactflow.io/pacts/provider/pactflow-example-provider-python/consumer/pactflow-example-consumer-python/latest/badge.svg)](https://test.pactflow.io/pacts/provider/pactflow-example-provider-python/consumer/pactflow-example-consumer-python/latest) (latest pact)

[![Pact Status](https://test.pactflow.io/pacts/provider/pactflow-example-provider-python/consumer/pactflow-example-consumer-python/latest/master/badge.svg)](https://test.pactflow.io/pacts/provider/pactflow-example-provider-python/consumer/pactflow-example-consumer-python/latest/master) (master/master pact) 

This is an example of a Python consumer using Pact to create a consumer driven contract, and sharing it via [PactFlow](https://pactflow.io).

It is using a public tenant on PactFlow, which you can access [here](https://test.pactflow.io). Login using this [special link](https://test.pactflow.io/login?code=98f7810e-c7dc-493b-9c3d-7849952f1d9a&utm_medium=web&utm_source=pact-workshop-python-consumer). The latest version of the Example Consumer/Example Provider pact is published [here](https://test.pactflow.io/pacts/provider/pactflow-example-provider-python/consumer/pactflow-example-consumer-python/latest).

The project uses a Makefile to simulate a very simple build pipeline with two stages - test and deploy.

* Test
  * Run tests (including the pact tests that generate the contract)
  * Publish pacts, tagging the consumer version with the name of the current branch
  * Check if we are safe to deploy to prod (ie. has the pact content been successfully verified)
* Deploy (only from master)
  * Deploy app (just pretend for the purposes of this example!)
  * Tag the deployed consumer version as 'prod'

## Usage

See the [PactFlow CI/CD Workshop](https://github.com/pactflow/ci-cd-workshop).

To run the tests locally, run:

```
make test
```

To run the "fake ci" task:
```
export PACT_BROKER_BASE_URL=https://test.pactflow.io
export PACT_BROKER_TOKEN=129cCdfCWhMzcC9pFwb4bw
make fake_ci
```
