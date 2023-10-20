# Run seed file based on environment
puts "Seeding database"
# Code will load db/seed/ production or develompent or test depending on environment set
load(Rails.root.join("db", "seeds", "#{Rails.env.downcase}.rb"))