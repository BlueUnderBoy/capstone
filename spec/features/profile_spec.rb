require "rails_helper"

describe "/[USERNAME]" do
  it "can be visited", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    visit "/#{user.username}"

    expect(page.status_code).to be(200)
  end

  it "has a link to Posts", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    visit "/#{user.username}"

    expect(page).to have_link("Posts", href: "/#{user.username}")
  end

  it "has a link to Liked photos", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    visit "/#{user.username}"

    expect(page).to have_link("Liked", href: "/#{user.username}/liked")
  end

  it "displays each of the user's photos inside a bootstrap card", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    goal = Goal.create(image: File.open("#{Rails.root}/spec/support/test_image.jpeg"), name: "name", owner_id: user.id)

    visit "/#{user.username}"

    expect(page).to have_tag("div", with: { class: "card" }) do
      with_tag("img", with: { src: goal.image })
      with_text goal.name
    end
  end

  it "shows the comments in the photo bootstrap cards", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    goal = Goal.create(image: File.open("#{Rails.root}/spec/support/test_image.jpeg"), name: "name", owner_id: user.id)
    comment = Comment.create(body: "body", author_id: user.id, goal_id: goal.id)

    visit "/#{user.username}"

    expect(page).to have_tag("div", with: { class: "card" }) do
      with_text comment.body
    end
  end

  it "allows the user to delete their goal", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    goal = Goal.create(image: File.open("#{Rails.root}/spec/support/test_image.jpeg"), name: "name", owner_id: user.id)

    visit "/#{user.username}"

    click_icon("i.fa-trash")

    expect(page).not_to have_content(goal.name)
  end

  it "shows a list of followers on the user profile", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    other_user = User.create(username: "other_user", email: "other_user@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    FriendRequest.create(sender_id: other_user.id, recipient_id: user.id, status: "accepted")

    visit "/#{user.username}"

    click_on "followers"

    expect(page).to have_content(other_user.username)
  end

  it "shows a list of leaders on the user profile", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    other_user = User.create(username: "other_user", email: "other_user@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    FollowRequest.create(sender_id: user.id, recipient_id: other_user.id, status: "accepted")

    visit "/#{user.username}"

    click_on "following"

    expect(page).to have_content(other_user.username)
  end

  it "show an 'Un-follow' button for leaders", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    other_user = User.create(username: "other_user", email: "other_user@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    FriendRequest.create(sender_id: user.id, recipient_id: other_user.id, status: "accepted")

    visit "/#{other_user.username}"

    expect(page).to have_content("Un-follow")
  end

  it "allows a user to unfollow another user", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    other_user = User.create(username: "other_user", email: "other_user@example.com", password: "password", avatar_image: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    FriendRequest.create(sender_id: user.id, recipient_id: other_user.id, status: "accepted")

    visit "/#{other_user.username}"

    click_on "Un-follow"

    expect(page).to have_content("Follow")
  end

  it "allows a user to accept a friend request", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    other_user = User.create(username: "other_user", email: "other_user@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    FriendRequest.create(sender_id: other_user.id, recipient_id: user.id, status: "pending")

    visit "/#{other_user.username}"

    click_on "Accept #{other_user.username}'s request"

    expect(page).not_to have_content("Decline #{other_user.username}'s request")
  end

  it "allows a user to reject a friend request", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    other_user = User.create(username: "other_user", email: "other_user@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    FollowRequest.create(sender_id: other_user.id, recipient_id: user.id, status: "pending")

    visit "/#{other_user.username}"

    click_on "Decline #{other_user.username}'s request"

    expect(page).not_to have_content("Accept #{other_user.username}'s request")
  end
end

def sign_in(user)
  visit "/users/sign_in"

  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def click_icon(icon_element, first: true)
  icon = if first
    all(icon_element).first
  else
    all(icon_element).last
  end

  element_to_click = icon.find(:xpath, "..")
  element_to_click.click
end
