mongoose = require "mongoose"

productSchema = new mongoose.Schema {
      name: { type: String, required: '{PATH} is required!'}
      price: { type: Number, required: '{PATH} is required!'}
      quantity: { type: Number, required: '{PATH} is required!'}
      description: { type: String, required: '{PATH} is required!'}
      createdAt: { type: Date }
      updatedAt: { type: Date }
      deletedAt: { type: Date, default:null }
}
     
productSchema.pre "save", (next) ->
      now = new Date()
      this.updateAt = now
      this.createdAt = now if !this.createdAt 
      next()
      
Product = module.exports = mongoose.model 'Product', productSchema