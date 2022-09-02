require 'minitest/autorun'
require_relative '../lib/checkout.rb'

PROMOTIONAL_RULES = '
                  [
                    {
                        "type": "buy",
                        "config": {
                                    "amount": 2,
                                    "item_code": "001",
                                    "new_price": 8.50
                                  }
                    },
                    {
                        "type": "spend",
                        "config": {
                                    "amount": 60.00,
                                    "discount": 0.1
                                  }
                    }
                  ]'

class CheckoutTest < Minitest::Test
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