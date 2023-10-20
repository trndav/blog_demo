# Seed for benchmark db usage
# IRB:  rails db:drop (or delete db other way)
# IRB: rails db:setup
# Comments are not created bc of:
# Active record - import problem: Recursive calls only world with postgres.
# Fixed comments import with recursive: true

        User.create(email: "janedoe@email.com", name: "Jane Doe", 
                password: "123456", password_confirmation: "123456", role: User.roles[:admin])
        User.create(email: "bob@email.com", name: "Bob", 
                password: "123456", password_confirmation: "123456")

# comments = []
# measure the elapsed time it takes to execute a block of code
elapsed = Benchmark.measure do  
        # aray to bulk push later      
        posts = []
        100.times do |x|
                puts "Creating post #{x}"
                post = Post.new(title: "Title #{x}", body: "Body #{x} Words go here Idk", user: User.first)
                # add element to array                                                      
                        2.times do |y|
                        puts "Creating comment #{y} for post #{x}"
                        post.comments.build(body: "Comment #{y}", user: User.second)
                        # comments.push(comment)
                end
                # add element to array
                posts.push(post)  
        end
        # bulk push all arrays after all is finished
        Post.import(posts, recursive: true)
end
# Comment.import(comments)
puts "Elapsed in #{elapsed.real} seconds."