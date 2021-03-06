class ProductsController < ApplicationController

  def simple_index
    tabulatr_for Product
  end

  def one_item_per_page_with_pagination
    @pagination = true
    tabulatr_for Product, {action: 'simple_index', default_pagesize: 1}
  end

  def one_item_per_page_without_pagination
    @pagination = false
    tabulatr_for Product, {action: 'simple_index', default_pagesize: 1}
  end

  def count_tags
    tabulatr_for Product
  end
end
