# Restful API using Express


## HOW TO SETUP

Before you run this application, there are several things need to be setup :

1. clone this this repo `git clone https://github.com/auliaabsarikhalil/rest-api-ss.git`
2. [install and setup Mongo](https://docs.mongodb.org/manual)
3. [install node and npm](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-an-ubuntu-14-04-server)
4. run `npm-install`
5. define your environtment at `.env` file (Simply just rename `.env.example` file)
6. setup config at `config.coffee`

```coffee
module.exports =
  common:
    port: 1990
    host:"localhost"
    database: "sale_stock"

  development:
    mongo:
      host : "localhost"
      port : 27017
```

## HOW TO RUN

To run this application you just need to run a command `node app` and begin to access it at `http://HOST:PORT`


## API DOCUMENTATION

Below is the API Documentation for REST API SS


## Categories

### List All Categories

End Point: `/categories`

Method: GET | application/json

Response `200`

```json
{
  "status": "success",
  "data": [
    {
      "_id": "56a3970082e358115260fcb5",
      "createdAt": "2016-01-23T15:06:40.963Z",
      "name": "Baju",
      "alias": "baju",
      "description": "Category Baju",
      "deletedAt": null,
      "isParent": true,
      "__v": 0
    },
    {
      "_id": "56a3973382e358115260fcb6",
      "createdAt": "2016-01-23T15:07:31.010Z",
      "name": "Baju Pria",
      "alias": "baju-pria",
      "description": "Category Baju Pria",
      "deletedAt": null,
      "isParent": false,
      "__v": 0
    }
  ]
}
```

### Create Category

End Point: `/categories`

Method: POST | application/json

Request `application/json`


```json
{
    "name":"Baju Pria",
    "alias" : "baju-pria",
    "description" : "Category Baju Pria",
    "parent": ["56a3970082e358115260fcb5"]
}
```

Response `200`

```json
{
  "status": "success",
  "data": {
    "category": {
      "__v": 0,
      "createdAt": "2016-01-23T15:07:31.010Z",
      "name": "Baju Pria",
      "alias": "baju-pria",
      "description": "Category Baju Pria",
      "_id": "56a3973382e358115260fcb6",
      "deletedAt": null,
      "isParent": false
    },
    "hierarchy": [
      {
        "__v": 0,
        "createdAt": "2016-01-23T15:07:31.014Z",
        "categoryId": "56a3973382e358115260fcb6",
        "parentId": "56a3970082e358115260fcb5",
        "_id": "56a3973382e358115260fcb7",
        "deletedAt": null
      }
    ]
  }
}
```

### Category Detail

End Poit: `/categories/{id}`

Method: GET | application/json

Parameters :
* id (String) - Category ID

Response `200`

```json
{
  "status": "success",
  "data": {
    "_id": "56a3970082e358115260fcb5",
    "createdAt": "2016-01-23T15:06:40.963Z",
    "name": "Baju",
    "alias": "baju",
    "description": "Category Baju",
    "deletedAt": null,
    "isParent": true,
    "__v": 0,
    "children": [
      {
        "_id": "56a3973382e358115260fcb6",
        "name": "Baju Pria"
      }
    ]
  }
}
```

### Update Category

End Point: `/categories/{id}`

Method: PUT | application/json

Parameters :
* id (String) - Category ID

Request `application/json`

```json
{
    "name": "Baju Wanita",
    "alias":"baju-wanita",
    "description": "Category Baju Wanita",
    "parent" : ["56a3970082e358115260fcb5"]
}   
```

Response `200`

```json
{
  "status": "success",
  "data": {
    "category": {
      "ok": 1,
      "nModified": 1,
      "n": 1
    },
    "hierarchy": [
      {
        "__v": 0,
        "createdAt": "2016-01-23T15:23:24.459Z",
        "categoryId": "56a3973382e358115260fcb6",
        "parentId": "56a3970082e358115260fcb5",
        "_id": "56a39aec02b18ab0552b5096",
        "deletedAt": null
      }
    ]
  }
}
```

### Delete Category

End Point: `/categories/{id}`

Method: DELETE | application/json

Parameters :
* id (String) - Category ID

Response `200`

```json
{
  "status": "success",
  "data": {
    "ok": 1,
    "nModified": 1,
    "n": 1
  }
}
```

## PRODUCTS

### List All Products

End Point: `/products`

Method: GET | application/json

Request `application/json`

Response `200`

```json
{
  "status": "success",
  "data": [
    {
      "_id": "56a39c1f02b18ab0552b509a",
      "createdAt": "2016-01-23T15:28:31.631Z",
      "name": "Product One",
      "description": "This is a great product",
      "quantity": 10,
      "price": 900000,
      "deletedAt": null,
      "__v": 0,
      "categories": [
        {
          "_id": "56a3970082e358115260fcb5",
          "createdAt": "2016-01-23T15:06:40.963Z",
          "name": "Baju",
          "alias": "baju",
          "description": "Category Baju",
          "deletedAt": null,
          "isParent": true,
          "__v": 0
        },
        {
          "_id": "56a3973382e358115260fcb6",
          "createdAt": "2016-01-23T15:07:31.010Z",
          "name": "Baju Wanita",
          "alias": "baju-wanita",
          "description": "Category Baju Wanita",
          "deletedAt": null,
          "isParent": false,
          "__v": 0
        }
      ]
    }
  ]
}
```

### Product Detail

End Poit: `/products/{id}`

Method: GET | application/json

Parameters :
* id (String) - Product ID

Response `200`

```json
{
  "status": "success",
  "data": {
    "_id": "56a39c1f02b18ab0552b509a",
    "createdAt": "2016-01-23T15:28:31.631Z",
    "name": "Product One",
    "description": "This is a great product",
    "quantity": 10,
    "price": 900000,
    "deletedAt": null,
    "__v": 0,
    "categories": [
      {
        "_id": "56a3970082e358115260fcb5",
        "createdAt": "2016-01-23T15:06:40.963Z",
        "name": "Baju",
        "alias": "baju",
        "description": "Category Baju",
        "deletedAt": null,
        "isParent": true,
        "__v": 0
      },
      {
        "_id": "56a3973382e358115260fcb6",
        "createdAt": "2016-01-23T15:07:31.010Z",
        "name": "Baju Wanita",
        "alias": "baju-wanita",
        "description": "Category Baju Wanita",
        "deletedAt": null,
        "isParent": false,
        "__v": 0
      }
    ]
  }
}
```

### Create Product

End Point: `/products`

Method: POST | application/json

Request `application/json`


```json
{
    "name" : "Product One",
    "description" : "This is a great product",
    "quantity" :10,
    "price": 900000,
    "categories" : ["56a3970082e358115260fcb5","56a3973382e358115260fcb6"]
}
```

Response `200`

```json
{
  "status": "success",
  "data": {
    "product": {
      "__v": 0,
      "createdAt": "2016-01-23T15:28:31.631Z",
      "name": "Product One",
      "description": "This is a great product",
      "quantity": 10,
      "price": 900000,
      "_id": "56a39c1f02b18ab0552b509a",
      "deletedAt": null
    },
    "categories": [
      {
        "__v": 0,
        "createdAt": "2016-01-23T15:28:31.635Z",
        "productId": "56a39c1f02b18ab0552b509a",
        "categoryId": "56a3970082e358115260fcb5",
        "_id": "56a39c1f02b18ab0552b509b",
        "deletedAt": null
      },
      {
        "__v": 0,
        "createdAt": "2016-01-23T15:28:31.637Z",
        "productId": "56a39c1f02b18ab0552b509a",
        "categoryId": "56a3973382e358115260fcb6",
        "_id": "56a39c1f02b18ab0552b509c",
        "deletedAt": null
      }
    ]
  }
}
```

### Edit Product

End Poit: `/products/{id}`

Method: PUT | application/json

Parameters :
* id (String) - Product ID

Request `application/json`

```json
{
    "name": "Product Two",
    "description": "This is a very great product",
    "quantity": 20,
    "price": 100000,
    "categories" : ["56a3970082e358115260fcb5", "56a3973382e358115260fcb6"]
}
```

Response `200`

```json
{
  "status": "success",
  "data": {
    "product": {
      "ok": 1,
      "nModified": 1,
      "n": 1
    },
    "categories": [
      {
        "__v": 0,
        "createdAt": "2016-01-23T15:36:21.730Z",
        "productId": "56a39c1f02b18ab0552b509a",
        "categoryId": "56a3970082e358115260fcb5",
        "_id": "56a39df502b18ab0552b509d",
        "deletedAt": null
      },
      {
        "__v": 0,
        "createdAt": "2016-01-23T15:36:21.731Z",
        "productId": "56a39c1f02b18ab0552b509a",
        "categoryId": "56a3973382e358115260fcb6",
        "_id": "56a39df502b18ab0552b509e",
        "deletedAt": null
      }
    ]
  }
}
```

### Delete Product

End Poit: `/products/{id}`

Method: DELETE | application/json

Parameters :
* id (String) - Product ID

Response `200`

```json
{
  "status": "success",
  "data": {
    "ok": 1,
    "nModified": 1,
    "n": 1
  }
}
```