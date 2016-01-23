mongoose    = require "mongoose"
Schema      = mongoose.Schema
ObjectId    = Schema.ObjectId

categorySchema = new Schema {
      categoryId: { type: ObjectId, required: '{PATH} is required!'}
      parentId: { type: ObjectId, required: '{PATH} is required!'} 
      createdAt: { type: Date }
      updatedAt: { type: Date }
      deletedAt: { type: Date, default:null }
}, { collection: "category_hierarchies" }

categorySchema.pre "save", (next) ->
      now = new Date()
      this.updateAt = now
      this.createdAt = now if !this.createdAt 
      next()
      
CategoryHierarchy = module.exports = mongoose.model 'CategoryHierarchy', categorySchema