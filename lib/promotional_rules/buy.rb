class PromotionalRulesBuy
  def initialize(config)
    @amount = config["amount"]
    @item_code = config["item_code"]
    @new_price = config["new_price"]
  end

  def process(products)
    if product_count(products) >= @amount
      products.each do |product|
        product.price = @new_price if product_same?(product)
      end
    end
    products
  end

  private

  def product_count(products)
    products.count { |product| product_same?(product) }
  end

  def product_same?(product)
    product.item_code == @item_code
  end
end