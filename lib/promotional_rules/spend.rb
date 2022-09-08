class PromotionalRulesSpend
  def initialize(config)
    @amount = config["amount"]
    @discount = config["discount"]
  end

  # This is an array of items
  def process(products)
    if total_price(products) >= @amount
      products.each do |product|
        discount_product(product)
      end
    end

    products
  end

  def total_price(products)
    total_price = 0
    products.each do |product|
      total_price += product.price
    end

    total_price
  end

  def discount_product(product)
    product.price *= 1 - @discount
  end
end