require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "has secure password" do
    user = create(:user, password: "pass")
    refute user.new_record?
    refute_equal user.password, user.password_digest
  end

  test "has many bucketlist" do
    user = create(:user_with_bucketlist)
    assert_equal 10, user.bucketlists.count
    Bucketlist.all.each do |blist|
      assert_equal user, blist.user
      assert_equal user.id, blist.relationship_id
    end
  end

  test "validates presence of name" do
    user = build(:user, name: nil)
    refute user.valid?
    refute_empty user.errors
    assert user.errors.full_messages.include? "Name can't be blank"
    assert user.errors.full_messages.include?(
      "Name is too short (minimum is 2 characters)"
    )
  end

  test "validates length of name" do
    user = build(:user, name: "o")
    refute user.valid?
    refute_empty user.errors
    assert user.errors.full_messages.include?(
      "Name is too short (minimum is 2 characters)"
    )

    user = build(:user, name: Faker::Lorem.sentence(100))
    refute user.valid?
    refute_empty user.errors
    assert user.errors.full_messages.include?(
      "Name is too long (maximum is 50 characters)"
    )
  end

  test "saves valid name" do
    user = build(:user, name: "valid name")
    assert user.valid?
    assert_empty user.errors
    assert user.save
  end

  test "validates presence of email" do
    user = build(:user, email: nil)
    refute user.valid?
    refute_empty user.errors
    assert user.errors.full_messages.include? "Email can't be blank"
  end

  test "validates downcase of email" do
    user = create(:user, email: "VALID@email.COM")
    refute user.reload.new_record?
    assert_equal "valid@email.com", user.email
    refute_equal "VALID@email.COM", user.email
  end

  test "validates email" do
    user = build(:user, email: "122dsdf")
    refute user.valid?
    refute_empty user.errors
    assert user.errors.full_messages.include? "Email is invalid"

    user = build(:user, email: "email@email")
    refute user.valid?
    refute_empty user.errors
    assert user.errors.full_messages.include? "Email is invalid"

    user = build(:user, email: "email.com")
    refute user.valid?
    refute_empty user.errors
    assert user.errors.full_messages.include? "Email is invalid"

    user = build(:user, email: "@email.com")
    refute user.valid?
    refute_empty user.errors
    assert user.errors.full_messages.include? "Email is invalid"
  end

  test "validates email not case_sensitive" do
    create(:user, email: "eMaIl@emAil.cOm")
    user2 = build(:user, email: "email@email.com")
    refute user2.valid?
    refute_empty user2.errors
    assert user2.errors.full_messages.include? "Email has already been taken"
  end

  test "saves valid email" do
    user = build(:user, email: "valid@EMAIL.com")
    assert user.valid?
    assert_empty user.errors
    assert user.save
  end
end
