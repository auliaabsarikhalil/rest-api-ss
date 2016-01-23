module.exports = (params) ->

	{ mongojs } = params

	toObjectId: (id) ->
		
		try
			id = mongojs.ObjectId id.toString()
		
		return id 

	mongooseErrorParser: (errors) ->

		parsed = []

		try
			for key of errors
				error 	= errors[key]
				message = error.message
				message = message.replace("_", " ");
				message = message.replace("{PATH}", error.path);
				message = message.replace("{value}", error.value);
				parsed.push message
		catch e
			parsed = [errors]
				
		return parsed	