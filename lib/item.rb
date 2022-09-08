class Item
  attr_accessor :price, :item_code, :name

  def initialize(item_code, name, price)
    @item_code = item_code
    @name = name
    @price = price
  end
end