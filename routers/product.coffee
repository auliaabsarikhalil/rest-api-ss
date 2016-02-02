module.exports = (params) ->

	{ app, service, helper, controller, async } = params

	###
	========================================
	|	@BASE_URL 
	========================================	
	|
	|	Author		: Aulia
	|	Last update	: 02 Feb 2016 by Aulia
	###

	BASE_URL = "products"

	###
	========================================
	|	[GET] /products
	========================================	
	|	get list all product 
	|	
	|	@params
	|	-
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	app.get "/#{BASE_URL}", (req, res, next) ->


		async.waterfall [

			(cb) ->

				query =
					deletedAt : null

				service.product.find query, (err, result) ->
					return cb err if err
					cb null, result
		
		,
			
			(products, cb) ->

				service.product.appendCategoriesToManyProducts products, (err, result) ->
					return cb err if err
					cb null, result

		], (err, result) ->
			return res.status(400).json { status:"error", message: err } if err
			return res.json { status:"success", data: result }
				

	###
	========================================
	|	[GET] /products/:id
	========================================	
	|	get product detail 
	|	
	|	@params
	|	id 	String
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	app.get "/#{BASE_URL}/:id", (req, res, next) ->

		async.waterfall [

			(cb) ->
				
				query = 
					_id : helper.toObjectId req.params.id
					deletedAt : null

				service.product.findOne query, (err, result) ->
					return cb err if err
					cb null, result
		,

			(product, cb) ->

				service.product.appendCategoriesToOneProduct product, (err, result) ->
					return cb err if err
					cb null, result

		], (err, result) ->
			return res.status(400).json { status:"error", message: err } if err
			return res.json { status:"success", data: result }

	###
	========================================
	|	[POST] /products
	========================================	
	|	create new product 
	|	
	|	@params
	|	-
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	app.post "/#{BASE_URL}", (req, res, next) ->
		
		data = req.body

		async.waterfall [

			(cb) ->
				
				service.product.create data, (err, result) ->
					return cb err if err
					cb null, result

		,
			
			(product, cb) ->

				return cb null, product if not data.categories
				return cb "Categories must be an array" if not Array.isArray data.categories

				service.product.createCategories product._id, data.categories, (err, result) ->
					return cb err if err
					cb null, { product: product, categories:result }

		], (err, result) ->
			return res.status(400).json { status:"error", message: helper.mongooseErrorParser err.errors } if err
			return res.json { status:"success", data: result }
		

	###
	========================================
	|	[PUT] /products/:id
	========================================	
	|	update existing product 
	|	
	|	@params
	|	id 	String
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	app.put "/#{BASE_URL}/:id", (req, res, next) ->

		id 	 = helper.toObjectId req.params.id
		data = req.body

		async.waterfall [

			(cb) ->

				keys = ["name", "description", "price", "quantity"]
				paramsUpdate = service.product.generateParamsUpdate keys, data

				query = 
					_id : id		
					deletedAt : null

				service.product.update query, paramsUpdate, (err, result) -> 
					return cb err if err
					cb null, result
		,

			(updated, cb) ->

				return cb null, updated if not data.categories
				return cb "Categories must be an array" if not Array.isArray data.categories

				service.product.updateCategories id, data.categories, (err, result) ->
					return cb err if err
					cb null, { product: updated, categories: result }

		], (err, result) ->
			return res.status(400).json { status:"error", message: helper.mongooseErrorParser err.errors } if err
			return res.json { status:"success", data: result }


	###
	========================================
	|	[DELETE] /products/:id
	========================================	
	|	delete existing product data 
	|	
	|	@params
	|	-
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	app.delete "/#{BASE_URL}/:id", (req, res, next) ->
		
		query =
			_id: helper.toObjectId req.params.id

		service.product.delete query, (err, result) -> 
			return res.status(400).json { status:"error", message: helper.mongooseErrorParser err.errors } if err
			return res.json { status:"success", data: result }