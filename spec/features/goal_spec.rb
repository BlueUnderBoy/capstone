require "rails_helper"

describe "/goals/new" do
  it "has a form to add a new goal", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    visit "/goals/new"

    expect(page).to have_form("/goals", :post)
  end

  it "does not allow the user to add a new goal without a name", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    visit "/"

    click_on "Add goal"

    attach_file "Image", "#{Rails.root}/spec/support/test_image.jpeg"
    click_on "Create Goal"

    expect(page).to have_content("Caption can't be blank")
  end

  it "allows the user to add a new goal", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    visit "/"

    click_on "Add goal"

    attach_file "Image", "#{Rails.root}/spec/support/test_image.jpeg"
    fill_in "Name", with: "name"
    click_on "Create Goal"

    expect(page).to have_content("Goal was successfully created")
  end

  it "redirects to the goal details page after creating a new goal", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    visit "/"

    click_on "Add goal"

    attach_file "Image", "#{Rails.root}/spec/support/test_image.jpeg"
    fill_in "Name", with: "name"
    click_on "Create Goal"

    expect(page).to have_current_path("/goals/#{Goal.last.id}")
  end
end

describe "/goals/[ID]" do
  it "displays the goal and caption inside a bootstrap card", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    goal = Goal.create(image: File.open("#{Rails.root}/spec/support/test_image.jpeg"), name: "name", owner_id: user.id)

    visit "/goals/#{goal.id}"

    expect(page).to have_tag("div", with: { class: "card" }) do
      with_tag("img", with: { src: goal.image })
      with_text goal.name
    end
  end

  it "allows the user to edit the goal", points: 1 do
    user = User.create(username: "alice", email: "alice@example.com", password: "password", profile_pic: File.open("#{Rails.root}/spec/support/test_image.jpeg"))
    sign_in(user)

    goal = Goal.create(image: File.open("#{Rails.root}/spec/support/test_image.jpeg"), name: "name", owner_id: user.id)

    visit "/goals/#{goal.id}"

    click_icon("i.fa-edit")

    fill_in "Name", with: "new name"
    click_on "Update Goal"

    expect(page).to have_content("new name")
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
