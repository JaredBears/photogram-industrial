desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  pp "Creating Sample Data"

  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all
  end

  usernames = Array.new { Faker::Name.first_name }

  usernames << "alice"
  usernames << "bob"

  13.times do
    usernames << Faker::Name.first_name
  end

  usernames.each do |username|
    User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      private: [true, false].sample,
    )
  end

  pp "There are now #{User.count} users."

  users = User.all

  50.times do
    photo = Photo.new
    photo.owner_id = User.all.sample.id
    photo.image = Faker::LoremFlickr.image(size: "50x50")
    photo.caption = Faker::Lorem.sentence
    photo.save!
  end

  pp "Created #{Photo.count} photos."

  100.times do
    comment = Comment.new
    comment.author_id = User.all.sample.id
    comment.photo_id = Photo.all.sample.id
    comment.body = Faker::Lorem.sentence
    comment.save!
  end

  pp "Created #{Comment.count} comments."

  users.each do |first_user|
    users.each do |second_user|
      next if first_user == second_user

      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.keys.sample,
        )
      end

      if rand < 0.75
        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.keys.sample,
        )
      end
    end

    15.times do
      like = Like.create(
        fan_id: first_user.id,
        photo_id: Photo.all.sample.id
      )
    end
  end
  pp "There are now #{FollowRequest.count} follow requests."
  pp "There are now #{Like.count} likes."

end
