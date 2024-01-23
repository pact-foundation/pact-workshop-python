"""pact test for product service client"""

import json
import logging
import os
import requests
from requests.auth import HTTPBasicAuth

import pytest
from pact import Consumer, Like, EachLike, Provider, Term, Format

from src.consumer import ProductConsumer

log = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)
print(Format().__dict__)

PACT_MOCK_HOST = 'localhost'
PACT_MOCK_PORT = 1234
PACT_DIR = os.path.dirname(os.path.realpath(__file__))


@pytest.fixture
def consumer():
    return ProductConsumer(
        'http://{host}:{port}'
        .format(host=PACT_MOCK_HOST, port=PACT_MOCK_PORT)
    )


@pytest.fixture(scope='session')
def pact(request):
    pact = Consumer('example-consumer-python').has_pact_with(
        Provider('example-provider-python'), host_name=PACT_MOCK_HOST, port=PACT_MOCK_PORT,
        pact_dir='./pacts', log_dir='./logs')
    try:
        print('start service')
        pact.start_service()
        yield pact
    finally:
        print('stop service')
        pact.stop_service()


def test_get_product(pact, consumer):
    expected = {
        'id': '10',
        'type': 'CREDIT_CARD',
        'name': '28 Degrees',
    }

    (pact
     .given('product with ID 10 exists')
     .upon_receiving('a request to get a product')
     .with_request('GET', '/product/10')
     .will_respond_with(200, body=Like(expected)))

    with pact:
        product = consumer.get_product('10')
        assert product.name == '28 Degrees'


def test_get_products(pact, consumer):
    expected = {
        'id': '10',
        'type': 'CREDIT_CARD',
        'name': '28 Degrees',
    }

    (pact
     .given('products exist')
     .upon_receiving('get all products')
     .with_request('GET', '/products')
     .will_respond_with(200, body=EachLike(expected)))

    with pact:
        products = consumer.get_products()
        assert products[0].name == '28 Degrees'
        assert products[0].type == 'CREDIT_CARD'
        assert products[0].name == '28 Degrees'
