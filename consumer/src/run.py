from consumer import ProductConsumer
consumer = ProductConsumer("http://0.0.0.0:8001")
products = consumer.get_products()

for product in products:
    print(product.id)
    print(product.type)
    print(product.name)
