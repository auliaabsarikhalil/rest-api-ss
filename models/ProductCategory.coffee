mongoose    = require "mongoose"
Schema      = mongoose.Schema
ObjectId    = Schema.ObjectId

productSchema = new Schema {
      productId: { type: ObjectId, required: '{PATH} is required!'}
      categoryId: { type: ObjectId, required: '{PATH} is required!'} 
      createdAt: { type: Date }
      updatedAt: { type: Date }
      deletedAt: { type: Date, default:null }
}, { collection: "product_categories" }

productSchema.pre "save", (next) ->
      now = new Date()
      this.updateAt = now
      this.createdAt = now if !this.createdAt 
      next()
      
ProductCategory= module.exports = mongoose.model 'ProductCategory', productSchema