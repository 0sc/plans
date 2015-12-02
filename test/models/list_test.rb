require "test_helper"

class ListTest < ActiveSupport::TestCase
  test "validates presence of name in bucketlist" do
    bucketlist = build(:bucketlist, name: nil)
    refute bucketlist.valid?
    refute_empty bucketlist.errors
    assert bucketlist.errors.full_messages.include? "Name can't be blank"
    assert bucketlist.errors.full_messages.include?(
      "Name is too short (minimum is 2 characters)"
    )
  end

  test "validates presence of name in item" do
    item = build(:item, name: nil)
    refute item.valid?
    refute_empty item.errors
    assert item.errors.full_messages.include? "Name can't be blank"
    assert item.errors.full_messages.include?(
      "Name is too short (minimum is 2 characters)"
    )
  end

  test "validates length of name for bucketlist" do
    bucketlist = build(:bucketlist, name: "o")
    refute bucketlist.valid?
    refute_empty bucketlist.errors
    assert bucketlist.errors.full_messages.include?(
      "Name is too short (minimum is 2 characters)"
    )

    bucketlist = build(:bucketlist, name: Faker::Lorem.sentence(100))
    refute bucketlist.valid?
    refute_empty bucketlist.errors
    assert bucketlist.errors.full_messages.include?(
      "Name is too long (maximum is 100 characters)"
    )
  end

  test "validates length of name for items" do
    item = build(:item, name: "o")
    refute item.valid?
    refute_empty item.errors
    assert item.errors.full_messages.include?(
      "Name is too short (minimum is 2 characters)"
    )

    item = build(:item, name: Faker::Lorem.sentence(100))
    refute item.valid?
    refute_empty item.errors
    assert item.errors.full_messages.include?(
      "Name is too long (maximum is 100 characters)"
    )
  end

  test "save valid bucketlist name" do
    bucketlist = build(:bucketlist, name: "valid name")
    assert bucketlist.valid?
    assert_empty bucketlist.errors
    assert bucketlist.save
  end

  test "save valid item name" do
    item = build(:item, name: "valid name")
    assert item.valid?
    assert_empty item.errors
    assert item.save
  end
end
