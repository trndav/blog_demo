# Seed for benchmark db usage
# IRB:  rails db:drop (or delete db other way)
# IRB: rails db:setup
# Comments are not created bc of:
# Active record - import problem: Recursive calls only world with postgres.

# arays to bulk push later
posts = []
comments = []
# measure the elapsed time it takes to execute a block of code
elapsed = Benchmark.measure do
        User.create(email: "janedoe@email.com", name: "Jane Doe", 
                password: "123456", password_confirmation: "123456", role: User.roles[:admin])
        User.create(email: "bob@email.com", name: "Bob", 
                password: "123456", password_confirmation: "123456")
        50.times do |x|
                puts "Creating post #{x}"
                post = Post.new(title: "Title #{x}", body: "Body #{x} Words go here Idk", user_id: User.first.id)
                # add element to array
                posts.push(post)                                        
                        2.times do |y|
                        puts "Creating comment #{y} for post #{x}"
                        comment = post.comments.new(body: "Comment #{y}", user_id: User.second.id)
                        # add element to array
                        comments.push(comment)
                end
        end
end
# bulk push all arrays after all is finished
Post.import(posts)
Comment.import(comments)
puts "Elapsed in #{elapsed.real} seconds."