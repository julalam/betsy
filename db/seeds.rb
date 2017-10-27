require 'csv'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
MERCHANT_FILE = Rails.root.join('db', 'seed_data', 'merchant_seeds.csv')
puts "Loading raw merchant data from #{MERCHANT_FILE}"

merchant_failures = []
CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.id = row['id']
  merchant.username = row['username']
  merchant.email = row['email']
  merchant.uid = row['uid']
  merchant.provider = row['provider']
  puts "Created merchant: #{merchant.inspect}"
  successful = merchant.save
  if !successful
    merchant_failures << merchant
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"



PRODUCT_FILE = Rails.root.join('db', 'seed_data', 'product_seeds.csv')
puts "Loading raw driver data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.id = row['id']
  product.name = row['name']
  product.price = row['price']
  product.stock = row['stock']
  product.description = row['description']
  product.retired = row['retired']
  product.image_url = row['image_url']
  product.merchant_id = row['merchant_id']
  puts "Created product: #{product.inspect}"
  successful = product.save
  if !successful
    product_failures << product
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"

CATEGORY_FILE = Rails.root.join('db', 'seed_data', 'category_seeds.csv')
puts "Loading raw categories products data from #{CATEGORY_FILE}"

categories_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.id = row['id']
  category.name = row['name']
  puts "Created category: #{category.inspect}"
  successful = category.save
  if !successful
    categories_failures << category
  end
end

puts "Added #{Category.count} categories  records"
puts "#{categories_failures.length} categories failed to save"

#### Making categories products seeds data###
category1 = Category.first
category2 = Category.last
category1.products << Product.first
category1.products << Product.last
category2.products << Product.all[6]
category2.products << Product.all[7]

category1.products.each do |product|
  puts "#{category1.name} has #{product.name}"
end
category2.products.each do |product|
  puts "#{category2.name} has #{product.name}"
end

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end
# puts "Added #{CategoriesProducts.count} categories products records"
# puts "#{categories_failures.length} categories products failed to save"
