class Category

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

	###
	========================================
	|	@find
	========================================	
	|	find category data
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

		@db.category.find query, fields, cb


	###
	========================================
	|	@findOne
	========================================	
	|	find one category data
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

		@db.category.findOne query, fields, cb

	###
	========================================
	|	@create
	========================================	
	|	create new data
	|	
	|	@params
	|	:data 		object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	create:(data, cb) ->
		@dboose.category.create data, cb

	###
	========================================
	|	@update
	========================================	
	|	update existing data
	|	
	|	@params
	|	:query 			object
	|	:paramsUpdate 	object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	update:(query, paramsUpdate, cb) ->
		@dboose.category.update query, { $set: paramsUpdate }, cb

	###
	========================================
	|	@delete
	========================================	
	|	delete data
	|	
	|	@params
	|	:query 		object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	delete: (query, cb) ->
		@dboose.category.update query, { $set: { deletedAt: new Date() } }, cb

	###
	========================================
	|	@createHierarchy
	========================================	
	|	create new category hiearchy 
	|	
	|	@params
	|	:categoryId 	string
	|	:parents 		array
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	createHierarchy: (categoryId, parents, cb) ->
		
		data = []

		parents.forEach (parent) =>
			
			obj = 
				categoryId: @helper.toObjectId categoryId
				parentId: @helper.toObjectId parent
			
			data.push obj

		@dboose.categoryHierarchy.create data, cb

	###
	========================================
	|	@updateHierarchy
	========================================	
	|	update existing category hiearchy 
	|	
	|	@params
	|	:categoryId 	string
	|	:parents 		array
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	updateHierarchy: (categoryId, parents, cb) ->

		categoryId = @helper.toObjectId categoryId

		@async.waterfall [

			(cb) =>

				@forceDeleteHierarchy { categoryId: categoryId }, (err, result) ->
					return cb err if err
					cb null, result
		
		,

			(result, cb) =>

				@createHierarchy categoryId, parents, (err, result) ->
					return cb err if err
					cb null, result 

		], cb

	###
	========================================
	|	@forceDeleteHierarchy
	========================================	
	|	permanent delete category hiearchy 
	|	
	|	@params
	|	:categoryId 	string
	|	:parents 		array
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	forceDeleteHierarchy: (query, cb) ->
		@dboose.categoryHierarchy.remove query, cb


	###
	========================================
	|	@findChild
	========================================	
	|	find child category + append data 
	|	
	|	@params
	|	:id 	string
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	findChild: (id, cb) ->

		@async.waterfall [

			(cb) =>

				@dboose.categoryHierarchy.find { parentId: @helper.toObjectId id }, (err, children) ->
					return cb err if err
					cb null, children

		,

			(children, cb) =>

				catList  = []

				if children
					children.forEach (child) => catList.push @helper.toObjectId child.categoryId if child and child.categoryId

				@find { _id: { $in : catList } }, { name:1 }, (err, result) ->
					return cb err if err 
					cb null, result

		], cb

	###
	========================================
	|	@delete
	========================================	
	|	soft delete category data 
	|	
	|	@params
	|	:query 	object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###

	delete:(query, cb) ->
		@update query, { deletedAt: new Date() }, cb

	###
	========================================
	|	@generateParamsUpdate
	========================================	
	|	generate params update 
	|	
	|	@params
	|	:keys	 	array
	|	:data 		object
	|
	|	Author		: Aulia
	|	Last update	: 23 Jan 2016 by Aulia
	###
		
	generateParamsUpdate: (keys, data) ->
		paramsUpdate = {}
		keys.forEach (key) ->
			paramsUpdate[key] = data[key] if data[key]
		return paramsUpdate 

module.exports = Category