class LineItem < ActiveRecord::Base
  attr_accessible :product, :cart_id, :product_id
  belongs_to :product
  belongs_to :cart
end
