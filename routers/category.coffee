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

	BASE_URL = "categories"

	###
	========================================
	|	[GET] /categories
	========================================	
	|	get list all catagories 
	|	
	|	@params
	|	-
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	app.get "/#{BASE_URL}", (req, res, next) ->

		query =
			deletedAt : null

		service.category.find query, (err, result) ->
			return res.status(400).json { status:"error", message: err } if err
			return res.json { status:"success", data: result }

	###
	========================================
	|	[GET] /categories/:id
	========================================	
	|	get category detail
	|	
	|	@params
	|	id 	String
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	app.get "/#{BASE_URL}/:id", (req, res, next) ->

		id = helper.toObjectId req.params.id

		async.waterfall [

			(cb) ->

				query = 
					_id : id
					deletedAt : null

				service.category.findOne query, (err, result) -> 
					return cb err if err
					cb null, result
		,

			(category, cb) ->

				service.category.findChild id, (err, children) -> 
					return cb err if err
					category.children = children
					cb null, category				

		], (err, result) ->
			return res.status(400).json { status:"error", message: err } if err
			return res.json { status:"success", data: result }

	###
	========================================
	|	[POST] /categories
	========================================	
	|	create new categories 
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

			# CREATE CATEGORY

			(cb) ->

				data.isParent = true if not data.parent

				service.category.create data, (err, category) ->
					return cb err if err
					cb null, category
		
		,

			# CREATE CATEGORY HIERARCHY

			(category, cb) ->
				
				return cb null, category if category.isParent
				
				return cb "parent must be an array" if not Array.isArray data.parent
				
				service.category.createHierarchy category._id, data.parent, (err, result) ->
					return cb err if err
					cb null, { category: category, hierarchy: result }
					 

		], (err, result) ->
			return res.status(400).json { status:"error", message: helper.mongooseErrorParser err.errors } if err
			return res.json { status:"success", data: result }

	###
	========================================
	|	[PUT] /categories/:id
	========================================	
	|	update existing category data 
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

			# GET CATEGORY DATA

			(cb) ->
				
				keys = ["name", "alias", "description"]
				
				paramsUpdate = service.category.generateParamsUpdate keys, data 

				query = 
					_id : id
					deletedAt : null

				service.category.update query, paramsUpdate, (err, result) ->
					return cb err if err
					cb null, result
		
		,

			# GET CHILDREN

			(updated, cb) ->

				return cb null, updated if not data.parent or data.isParent

				service.category.updateHierarchy id, data.parent, (err, result) ->
					return cb err if err
					cb null, { category : updated, hierarchy:result }
				

		], (err, result) ->
			return res.status(400).json { status:"error", message: helper.mongooseErrorParser err.errors } if err
			return res.json { status:"success", data: result }
		
	###
	========================================
	|	[DELETE] /categories/:id
	========================================	
	|	delete existing category
	|	
	|	@params
	|	id 	String
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	app.delete "/#{BASE_URL}/:id", (req, res, next) ->
		
		query =
			_id: helper.toObjectId req.params.id

		service.category.delete query, (err, result) -> 
			return res.status(400).json { status:"error", message: helper.mongooseErrorParser err.errors } if err
			return res.json { status:"success", data: result }