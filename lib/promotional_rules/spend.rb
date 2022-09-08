class PromotionalRulesSpend
  def initialize(config)
    @amount = config["amount"]
    @discount = config["discount"]
  end

  # This is an array of items
  def process(products)
    total_price = 0
    products.each do |product|
      total_price += product.price
    end

    # Apply Discount if Valid
    if total_price >= @amount
      products.each do |product|
        product.price *= 1 - @discount
      end
    end
    products
  end
end