desc "Fill the database tables with some sample data"
task sample_data: :environment do
  starting = Time.now

  # Clean up existing uploaded files
  FileUtils.rm_rf(Rails.root.join("public", "uploads"))

  FriendRequest.destroy_all
  Goal.destroy_all
  User.destroy_all

  people = Array.new(10) do
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
    }
  end

  people << { first_name: "Alice", last_name: "Smith" }
  people << { first_name: "Bob", last_name: "Smith" }
  people << { first_name: "Carol", last_name: "Smith" }
  people << { first_name: "Dave", last_name: "Smith" }
  people << { first_name: "Eve", last_name: "Smith" }

  people.each do |person|
    username = person.fetch(:first_name).downcase

    user = User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      first_name: "#{person[:first_name]}",
      last_name: "#{person[:last_name]}"
      profile_pic: File.open("#{Rails.root}/public/avatars/#{rand(1..10)}.jpeg")
    )
  end

  users = User.all

  users.each do |first_user|
    users.each do |second_user|
      if rand < 0.75
        status = "accepted"
        first_user_friend_request = first_user.sent_friend_requests.create(
          recipient: second_user,
          status: status
        )
      end

      if rand < 0.75
        status = "accepted"
        second_user_friend_request = second_user.sent_friend_requests.create(
          recipient: first_user,
          status: status
        )
      end
    end
  end

  users.each do |user|
    rand(3).times do
      goal = user.own_goals.create(
        name: {user.first_name}" has a new goal!",
        amount_needed: "$#{rand(100..1000)}",
        amount_saved: "$#{rand(0..100)}",
        image: File.open("#{Rails.root}/public/photos/#{rand(1..10)}.jpeg")
      )
    end
  end

  ending = Time.now
  p "It took #{(ending - starting).to_i} seconds to create sample data."
  p "There are now #{User.count} users."
  p "There are now #{FriendRequest.count} friend requests."
  p "There are now #{Goal.count} goals."
end
