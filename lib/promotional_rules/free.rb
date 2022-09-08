class PromotionalRulesFree
  def initialize(config)
    @quantity = config["quantity"]
    @item_code = config["item_code"]
  end

  # This is an array of items
  def process(products)
    if count_by_item_code(products) >= @quantity
      free_one_item(products)
    end

    products
  end

  private

  def count_by_item_code(products)
    count = 0
    products.each do|product|
      if product.item_code == @item_code
        count += 1
      end
    end

    count
  end

  def free_one_item(products)
    products.each do|product|
      if product.item_code == @item_code
        products.delete(product)
        return
      end
    end
  end
end