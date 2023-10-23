puts "Seeding development database."
# If there is no first user, create user
jane = User.first_or_create!(email: "janedoe@email.com", 
          first_name: "Jane", last_name: "Doe",
          password: "123456", password_confirmation: "123456", 
          role: User.roles[:admin])
bob = User.first_or_create!(email: "bob@email.com", 
          first_name: "Bob", last_name: "Rock",
          password: "123456", password_confirmation: "123456")

Address.first_or_create!(street: "As 23", city: "Zg", state: "Cro",
          zip: "12114", country: "Croatia",
          user: jane)
Address.first_or_create!(street: "Oklan 23", city: "Kz", state: "Cro",
          zip: "53322", country: "Croatia",
          user: bob)
        
category = Category.first_or_create!(name: "Uncategorized", display_in_nav: true)
Category.first_or_create!(name: "Funny", display_in_nav: false)
Category.first_or_create!(name: "Food", display_in_nav: true)
Category.first_or_create!(name: "Fruits", display_in_nav: true)

# measure the elapsed time it takes to execute a block of code
elapsed = Benchmark.measure do  
# array to bulk push later      
  posts = []
  100.times do |x|
    puts "Creating post #{x}"
    post = Post.new(title: "Title #{x}", body: "Body #{x} Words go here Idk", 
                            user: jane, category: category)                                                    
      2.times do |y|
      puts "Creating comment #{y} for post #{x}"
      post.comments.build(body: "Comment #{y}", user: bob)
  end
    # add element to array
    posts.push(post)  
  end
  # bulk push all arrays after all is finished
  Post.import(posts, recursive: true)
end
puts "Finished in #{elapsed.real} seconds."