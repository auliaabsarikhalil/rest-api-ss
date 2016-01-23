class Product

	###
	========================================
	|	@constructor
	========================================	
	|	constructor 
	|	
	|	@params
	|	:params 	object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	constructor: (params) ->
		@db 	= params.db
		@dboose = params.dboose
		@helper = params.helper
		@async  = params.async
		@service  = params.service

	###
	========================================
	|	@find
	========================================	
	|	find product data 
	|	
	|	@params
	|	:query 		object
	|	:fields 	object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###
	
	find: (query, fields, cb) ->

		if not cb
			cb = fields
			fields = {}

		@db.product.find query, fields, cb

	###
	========================================
	|	@findOne
	========================================	
	|	find one data product 
	|	
	|	@params
	|	:query 		object
	|	:fields 	object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	findOne: (query, fields, cb) ->
		
		if not cb
			cb = fields
			fields = {}

		@db.product.findOne query, fields, cb

	###
	========================================
	|	@create
	========================================	
	|	create new data 
	|	
	|	@params
	|	:data 	object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	create:(data, cb) ->
		@dboose.product.create data, cb

	###
	========================================
	|	@update
	========================================	
	|	update existing data 
	|	
	|	@params
	|	:query 			object
	| 	:paramsUpdate 	Object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	update:(query, paramsUpdate, cb) ->
		@dboose.product.update query, { $set: paramsUpdate }, cb

	###
	========================================
	|	@delete
	========================================	
	|	soft delete product data 
	|	
	|	@params
	|	:query 	object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	delete: (query, cb) ->
		@dboose.product.update query, { $set: { deletedAt: new Date() } }, cb

	###
	========================================
	|	@generateParamsUpdate
	========================================	
	|	generate params update 
	|	
	|	@params
	|	:keys 	Array
	|	:data	object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	generateParamsUpdate: (keys, data) ->
		paramsUpdate = {}
		keys.forEach (key) ->
			paramsUpdate[key] = data[key] if data[key]
		return paramsUpdate 

	###
	========================================
	|	@createCategories
	========================================	
	|	create product categories 
	|	
	|	@params
	|	:productId 		string
	|	:categories 	array
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	createCategories: (productId, categories, cb) ->

		data = []
		categories.forEach (category) =>
			obj = 
				productId : @helper.toObjectId productId 
				categoryId : @helper.toObjectId category
			data.push obj

		@dboose.productCategory.create data, cb

	###
	========================================
	|	@appendCategoriesToManyProducts
	========================================	
	|	append categories data into each
	|	product
	|	
	|	@params
	|	:products 	array
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	appendCategoriesToManyProducts: (products, cb) ->

		@async.waterfall [

			(cb) =>

				idList = []
				
				products.forEach (product) =>
					idList.push @helper.toObjectId product._id

				@findProductCategory { productId: { $in: idList } }, (err, result) ->
					return cb err if err
					cb null, result
		
		,

			(productCategories, cb) =>

				idList = []

				productCategories.forEach (category) =>
					idList.push @helper.toObjectId category.categoryId

				console.dir @service

				@db.category.find { _id: { $in: idList } }, (err, result) =>
					return cb err if err
					cb null, productCategories, result

		,

			(productCategories, categories, cb) =>

				tempCategories = {}

				categories.forEach (category) ->
					tempCategories["#{category._id}"] = category

				productCategories.forEach (product, index) ->
					categoryId = "#{product.categoryId}"
					productCategories[index].categories = {} 
					if tempCategories["#{categoryId}"]
						productCategories[index].categories = tempCategories["#{categoryId}"]

				cb null, productCategories

		, 

			(productCategories, cb) =>

				tempCategories = {}

				productCategories.forEach (product) ->
					productId = "#{product.productId}"
					
					if not tempCategories[productId ]
						tempCategories[productId] = []

					tempCategories[productId].push product.categories

				products.forEach (product, index) ->
					
					productId = "#{product._id}"	
					products[index].categories = []

					if tempCategories[productId]
						products[index].categories = tempCategories[productId]

				cb null, products

		], cb

	###
	========================================
	|	@appendCategoriesToOneProduct
	========================================	
	|	append categories to one product 
	|	
	|	@params
	|	:product 	array
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	appendCategoriesToOneProduct: (product,cb) ->
		
		@async.waterfall [

			(cb) =>
				
				query = 
					productId: @helper.toObjectId product._id

				@findProductCategory query, (err, result) ->
					return cb err if err
					cb null, result

		,

			(categories, cb) =>

				idList = []
				categories.forEach (category) =>
					idList.push @helper.toObjectId category.categoryId

				@db.category.find { _id: { $in : idList } }, (err, result) ->
					return cb err if err
					product.categories = result
					cb null, product
		
		], cb


	###
	========================================
	|	@updateCategories
	========================================	
	|	update product categories 
	|	
	|	@params
	|	:productId 		string
	|	:categories 	array
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	updateCategories: (productId, categories, cb) ->

		id = @helper.toObjectId productId

		@async.waterfall [

			(cb) =>

				@forceDeleteCategory { productId: id }, (err, result) ->
					return cb err if err
					cb null, result

		,

			(deleted, cb) =>

				@createCategories productId, categories, (err, result) ->
					return cb err if err
					cb null, result	 

		], cb

	###
	========================================
	|	@forceDeleteCategory
	========================================	
	|	force delete product category 
	|	
	|	@params
	|	:query 	object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	forceDeleteCategory: (query, cb) ->
		@dboose.productCategory.remove query, cb

	###
	========================================
	|	@findProductCategory
	========================================	
	|	find product category 
	|	
	|	@params
	|	:query 		object
	|	:fields		object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	findProductCategory: (query, fields, cb) ->
		
		if not cb
			cb = fields
			fields = {}
		
		@db.productCategory.find query, fields, cb

module.exports = Product