class CombineItemsInCart < ActiveRecord::Migration
  def self.up
  	Cart.all.each do |cart|
  		sums = cart.line_items.group(:product_id).sum(:quantity)

  		sums.each do |p_id, quantity|
  			if quantity > 1
  				cart.line_items.where(:product_id => p_id).delete_all
  				cart.line_items.create(:product_id => p_id, :quantity => quantity)
  			end
  		end
  	end
  end

  def self.down
  	LineItem.where("quantity>1").each do |li|
  		li.quantity.times do
  			LineItem.create :cart_id => li.cart_id, :product_id => li.product_id, :quantity => 1
  		end

  		li.destroy
  	end
  end
end
