# Class Checkout -> Pass in Promotional Rules -> Scan Items -> Profit

require 'minitest/autorun'
require 'json'

PROMOTIONAL_RULES = '
                      [
                        {
                          "type": "spend",
                          "amount": 60,
                          "discount": 0.1
                        },
                        {
                          "type": "buy",
                          "amount": 2,
                          "item_code": "001",
                          "new_price": 8.5
                        }
                      ]'

class CheckoutTest < Minitest::Test
  def test_able_to_read_attributes_from_product
    product = Item.new("001", "Red Scarf", 9.25)
    assert product.price == 9.25
    assert product.name == "Red Scarf"
    assert product.product_code == "001"
  end

  def test_able_to_scan_and_store_item_in_list
    item = Item.new("001", "Red Scarf", 9.25)
    co = Checkout.new('[{"type": "no_promotion"}]')
    co.scan(item)

    assert co.products == {
      "001" => {
        :name => "Red Scarf",
        :price => 9.25,
        :amount => 1
      }
    }
  end


  def test_able_to_read_promotional_rules


    co = Checkout.new(PROMOTIONAL_RULES)

    assert co.promotional_rules == JSON.parse(PROMOTIONAL_RULES)
  end

  def test_refund_amount_is_correct
    item = Item.new("001", "Red Scarf", 9.25)

    co = Checkout.new(PROMOTIONAL_RULES)
    co.scan(item)
    co.scan(item)

    assert co.total == 17.00
  end

  def test_able_to_calculate_total_price_of_items
    item = Item.new("001", "Red Scarf", 9.25)
    co = Checkout.new('[{"type": "np"}]')
    co.scan(item)
    co.scan(item)

    assert co.total == 18.50
  end

  def test_case_1
    item = Item.new("001", "Red Scarf", 9.25)
    item_2 = Item.new("002", "Silver cufflinks", 45.00)
    item_3 = Item.new("003", "Silk Dress", 19.95)

    co = Checkout.new(PROMOTIONAL_RULES)
    co.scan(item)
    co.scan(item_2)
    co.scan(item_3)

    assert co.total == 66.78
  end

  def test_case_2
    item = Item.new("001", "Red Scarf", 9.25)
    item_3 = Item.new("003", "Silk Dress", 19.95)

    co = Checkout.new(PROMOTIONAL_RULES)
    co.scan(item)
    co.scan(item_3)
    co.scan(item)

    assert co.total == 36.95
  end

  def test_case_3
    item = Item.new("001", "Red Scarf", 9.25)
    item_2 = Item.new("002", "Silver cufflinks", 45.00)
    item_3 = Item.new("003", "Silk Dress", 19.95)

    co = Checkout.new(PROMOTIONAL_RULES)
    co.scan(item)
    co.scan(item_2)
    co.scan(item_3)
    co.scan(item)

    assert co.total == 73.76
  end
end



# creating class to store Items attributes
class Item
  attr_reader :price, :product_code, :name

  def initialize(product_code, name, price)
    @product_code = product_code
    @name = name
    @price = price
  end
end

# Type of Promotions
# 1. Spend X Amounts, Get Y Amount of Discount
# 2. Buy X Amounts, Get Item Y in Z Price

# Example of Design
# [
#   {
#     "type": "spend",
#     "amount": 60,
#     "discount": 0.1
#   },
#   {
#     "type": "buy",
#     "amount": 2,
#     "item_code": "001",
#     "new_price": 8.5
#   }
# ]


class Checkout
  attr_accessor :products, :promotional_rules

  def initialize(promototional_rules = nil)
    @products = {} # Potential of storing this in Hash instead?
    @promotional_rules = JSON.parse(promototional_rules)
  end

  # Scan into a hash map
  # {
  #   :001 => {
  #     :name => "Red Scarf",
  #     :price => 9.5,
  #     :amount => 1
  #   },
  #   :002 => ....
  # }
  def scan(item)
    # check if item ald exists in hash, then we can directly add into amount
    if products.key?(item.product_code)
      products[item.product_code][:amount] += 1
    else
      products[item.product_code] = {
        :name => item.name,
        :price => item.price,
        :amount => 1
      }
    end
  end

  # 1. Get Item Code 2. Check Number of items >= amount required for discount? 3. Refund = number of items in cart * price difference
  def buy_refund
    promotional_rules.each do |rule|
      if rule["type"] == "buy"
        if products[rule["item_code"]][:amount] >= rule["amount"]
          # Update Price
          products[rule["item_code"]][:price] = rule["new_price"]
        end
      end
    end
  end

  # amount to be eligible for discount
  def spend_discount(total)
    promotional_rules.each do |rule|
      if rule["type"] == "spend"
        if total >= rule["amount"]
          total *= 1 - rule["discount"] # discount 10% = 90% of total to be payed
        end
      end
    end

    total.round(2)
  end

  def total
    total = 0
    buy_refund
    products.each do |key, value|
      total += value[:amount].to_i * value[:price].to_f
    end

    spend_discount(total)
  end
end

