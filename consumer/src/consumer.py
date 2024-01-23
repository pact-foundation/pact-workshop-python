import requests

class ProductConsumer(object):
    def __init__(self, base_uri):
        self.base_uri = base_uri

    def get_product(self, id):
        """Get product by ID"""
        uri = self.base_uri + '/product/' + id
        response = requests.get(uri)
        if response.status_code == 404:
            return None

        json = response.json()
        return Product(json['id'], json['type'], json['name'])

    def get_products(self):
        """Get products"""
        uri = self.base_uri + '/products'
        response = requests.get(uri)
        if response.status_code == 404:
            return None

        json_list = response.json()
        products = []
        for json in json_list:
            product = Product(json['id'], json['type'], json['name'])
            products.append(product)
        return products


class Product(object):
    def __init__(self, id, type, name ):
        self.id = id
        self.type = type
        self.name = name
