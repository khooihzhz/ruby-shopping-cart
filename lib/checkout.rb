# creating class to store Items attributes
require 'json'
require_relative 'promotional_rules.rb'
require_relative 'promotional_rules/buy.rb'
require_relative 'promotional_rules/spend.rb'

PROMOTIONAL_RULES_CLASS = {
  'buy' => PromotionalRules::Buy,
  'spend' => PromotionalRules::Spend
}

class Checkout
  attr_accessor :products, :promotional_rules

  def initialize(promotional_rules = nil)
    @products = []
    @promotional_rules = JSON.parse(promotional_rules)
  end

  def scan(item)
    @products << item
  end

  def total
    process
    total_price = 0
    @products.each do |product|
      total_price += product.price
    end

    total_price.round(2)
  end

  def process
    promotional_rules.each do |rule|
      @products = PROMOTIONAL_RULES_CLASS[rule["type"]].new(rule["config"]).process(@products)
    end
  end
end

