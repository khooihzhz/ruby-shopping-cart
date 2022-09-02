# creating class to store Items attributes
require 'json'

class Item
  attr_accessor :price, :item_code, :name

  def initialize(item_code, name, price)
    @item_code = item_code
    @name = name
    @price = price
  end
end


class Checkout
  attr_accessor :products, :promotional_rules

  def initialize(promotional_rules = nil)
    @products = []
    @promotional_rules = JSON.parse(promotional_rules)
  end

  def scan(item)
    @products << item
  end

  def buy_refund
    promotional_rules.each do |rule|
      if rule["type"] == "buy"
        item_count = 0
        @products.each do | product |
          # Count number of items
          if product.item_code == rule["config"]["item_code"]
            item_count += 1
          end
        end
        if item_count >= rule["config"]["amount"]
          @products.each do | product |
            if product.item_code == rule["config"]["item_code"]
              product.price = rule["config"]["new_price"]
            end
          end
        end
      end
    end
  end

  # amount to be eligible for discount
  def spend_discount
    total = 0
    promotional_rules.each do |rule|
      if rule["type"] == "spend"
        @products.each do |product|
          total += product.price
        end
        if total >= rule["config"]["amount"]
          total *= 1 - rule["config"]["discount"] # discount 10% = 90% of total to be payed
        end
      end
    end
    total.round(2)
  end

  def total
    buy_refund
    spend_discount
  end
end

