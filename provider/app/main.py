from fastapi import FastAPI, Response

app = FastAPI()

catalog = [
    {"id": "09", "type": "CREDIT_CARD", "name": "Gem Visa", "version": "v1"},
    {"id": "10", "type": "CREDIT_CARD", "name": "28 Degrees", "version": "v1"},
    {"id": "11", "type": "PERSONAL_LOAN", "name": "MyFlexiPay", "version": "v2"}
]


@app.get("/products")
async def products():
    return catalog


@app.get("/products/{id}")
@app.get("/product/{id}")
async def product(id: str, response: Response):
    for product in catalog:
        if product["id"] == id:
            return product

    response.status_code = 404
    return {}
