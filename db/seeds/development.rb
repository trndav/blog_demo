def seed_users
  # If there is no first user, create user
  @jane = User.first_or_create!(email: "janedoe@email.com", 
            first_name: "Jane", last_name: "Doe",
            password: "123456", password_confirmation: "123456", 
            role: User.roles[:admin])
  @adminbro = User.first_or_create!(email: "adminbro@email.com", 
            first_name: "Admin", last_name: "Bro",
            password: "123456", password_confirmation: "123456")
end

def seed_addresses
  Address.first_or_create!(street: "As 23", city: "Zg", state: "Cro",
            zip: "12114", country: "Croatia",
            user: @jane)
  Address.first_or_create!(street: "Oklan 23", city: "Kz", state: "Cro",
            zip: "53322", country: "Croatia",
            user: @adminbro)
end

def seed_categories
  category = Category.first_or_create!(name: "Uncategorized", display_in_nav: true)
  Category.first_or_create!(name: "Funny", display_in_nav: false)
  Category.first_or_create!(name: "Food", display_in_nav: true)
  Category.first_or_create!(name: "Fruits", display_in_nav: true)
end

def seed_posts_and_comments
  # array to bulk push later      
  posts = []
  jane = User.first
  adminbro = User.second 
  category = Category.first 
  20.times do |x|
    puts "Creating post #{x}"
    post = Post.new(title: "Title #{x}", body: "Body #{x} Words go here Idk", 
                            user: @jane, category: category)                                                    
      2.times do |y|
        puts "Creating comment #{y} for post #{x}"
        post.comments.build(body: "This is comment #{y}", user: @adminbro)
      end
    # add element to array
    posts.push(post)  
  end
  # bulk push all arrays after all is finished
  Post.import(posts, recursive: true)
end

def seed_ahoy
  Ahoy.geocode = false
  request = OpenStruct.new(
    params: {}, 
    referer: "http://somepage.com",
    remote_id: "0.0.0.0",
    user_agent: "Internet Explorer, yeah right.",
    original_url: "rails"
  )  
  visit_properties = Ahoy::VisitProperties.new(request, api: nil)
  properties = visit_properties.generate.select { |_, v| v }
  example_visit = Ahoy::Visit.create!(properties.merge(
    visit_token: SecureRandom.uuid,
    visitor_token: SecureRandom.uuid
  ))

  2.months.ago.to_date.upto(Date.today) do |date|
    Post.all.each do |post|
      rand(1..5).times do |x|
        Ahoy::Event.create!(name: "Viewed Post",
            visit: example_visit,
            properties: { post_id: post.id },
            time: date.to_time + rand(0..23).hours + rand(0..59).minutes)
      end
    end
  end
end

# measure the elapsed time it takes to execute a block of code
elapsed = Benchmark.measure do  
  puts "Seeding development database."
  seed_users 
  seed_addresses
  seed_categories 
  seed_posts_and_comments  
  seed_ahoy
end
puts "Finished in #{elapsed.real} seconds."