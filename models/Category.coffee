mongoose    = require "mongoose"
Schema      = mongoose.Schema
ObjectId    = Schema.ObjectId

categorySchema = new Schema {
      name: { type: String, required: '{PATH} is required!'}
      alias: { type: String, required: '{PATH} is required!'}
      description: { type: String, required: '{PATH} is required!'}
      isParent: { type: Boolean, default: false } 
      createdAt: { type: Date }
      updatedAt: { type: Date }
      deletedAt: { type: Date, default:null }
}

categorySchema.pre "save", (next) ->
      now = new Date()
      this.updateAt = now
      this.createdAt = now if !this.createdAt 
      next()
      
Category = module.exports = mongoose.model 'Category', categorySchema