require 'minitest/autorun'
require_relative '../lib/checkout.rb'
require_relative '../lib/item.rb'
require_relative '../lib/promotional_rules/buy.rb'
require_relative '../lib/promotional_rules/spend.rb'

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
                    },


                    {
                      "type": "free",
                      "config": {
                        "quantity": 3,
                        "item_code": "003"
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
    red_scarf = Item.new("001", "Red Scarf", 9.25)
    silk_dress = Item.new("003", "Silk Dress", 19.95)
    red_scarf_2 = Item.new("001", "Red Scarf", 9.25)

    co = Checkout.new(PROMOTIONAL_RULES)
    co.scan(red_scarf)
    co.scan(silk_dress)
    co.scan(red_scarf_2)

    assert co.total == 36.95
  end

  def test_case_3
    red_scarf = Item.new("001", "Red Scarf", 9.25)
    silver_cuff = Item.new("002", "Silver cufflinks", 45.00)
    silk_dress = Item.new("003", "Silk Dress", 19.95)
    red_scarf_2 = Item.new("001", "Red Scarf", 9.25)

    co = Checkout.new(PROMOTIONAL_RULES)
    co.scan(red_scarf)
    co.scan(silver_cuff)
    co.scan(silk_dress)
    co.scan(red_scarf_2)
    assert co.total == 73.76
  end

  def test_case_4
    silk_dress_1 = Item.new("003", "Silk Dress", 19.95)
    silk_dress_2 = Item.new("003", "Silk Dress", 19.95)
    silk_dress_3 = Item.new("003", "Silk Dress", 19.95)

    co = Checkout.new(PROMOTIONAL_RULES)
    co.scan(silk_dress_1)
    co.scan(silk_dress_2)
    co.scan(silk_dress_3)
    assert co.total == 39.90
  end
end