###
========================================
|	@LIBRARIES
========================================
|	
|	Author		: Aulia
|	Last update	: 23 Jan 2016 by Aulia
###

Settings 	= require "settings"
env 		= require "./.env"
config 		= new Settings require('./config'), { env : env }
express 	= require "express"
bodyParser 	= require "body-parser"
mongojs 	= require "mongojs"
db 			= mongojs "#{config.mongo.host}:#{config.mongo.port}/#{config.database}"
app 		= express()
mongoose 	= require "mongoose"
async 		= require "async"

app.use bodyParser.json()
app.use bodyParser.urlencoded { extended: true }

###
========================================
|	@PARAMS
========================================
|	init all params.
|	
|	Author		: Aulia
|	Last update	: 23 Jan 2016 by Aulia
###

params =  
	app 		: app 
	mongoose 	: mongoose
	config 		: config
	mongojs		: mongojs
	async		: async


###
========================================
|	@HELPER
========================================
|	
|	Author		: Aulia
|	Last update	: 23 Jan 2016 by Aulia
###

params["helper"] = require("./helper")(params)

###
========================================
|	@DB
========================================
|	
|	Author		: Aulia
|	Last update	: 23 Jan 2016 by Aulia
###

params["db"] =
	product : db.collection "products"
	category : db.collection "categories"
	categoryHierarchy : db.collection "category_hierarchies"
	productCategory : db.collection "product_categories"

###
========================================
|	@MONGOOSE
========================================
|	
|	Author		: Aulia
|	Last update	: 23 Jan 2016 by Aulia
###

DB = require("./models/DB")(params)
params["dboose"] =
	product: mongoose.model "Product"
	category: mongoose.model "Category"
	categoryHierarchy: mongoose.model "CategoryHierarchy"
	productCategory: mongoose.model "ProductCategory"

###
========================================
|	@SERVICES
========================================
|	
|	Author		: Aulia
|	Last update	: 23 Jan 2016 by Aulia
###

ProductService = require("./services/Product")
CategoryService = require("./services/Category")
params["service"] =
	product: new ProductService params
	category: new CategoryService params

###
========================================
|	@ROUTER
========================================
|	
|	Author		: Aulia
|	Last update	: 23 Jan 2016 by Aulia
###

require('./routers/index')(params)

server = app.listen config.port, config.host
console.log "Rest API SS is listening at http://#{config.host}:#{config.port}"