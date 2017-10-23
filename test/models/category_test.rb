require "test_helper"

describe Category do

  describe "relations" do
    it "has a list of products" do
      category = Category.first
      category.must_respond_to :products
      category.products.each do |product|
        product.must_be_kind_of Product
      end
    end
  end

  describe "validations" do
    it "require a name" do
      category = Category.new
      category.valid?.must_equal false
      category.errors.messages.must_include :name
    end

    it "requires a unique name" do
      name = "test name"
      category_1 = Category.new(name: name)
      category_1.save!

      category_2 = Category.new(name: name)
      category_2.save.must_equal false
      category_2.errors.messages.must_include :name
    end

  end
end
