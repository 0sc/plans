require "test_helper"

class BucketlistTest < ActiveSupport::TestCase
  def setup
    @bucketlist = create(:bucketlist_with_items)
  end

  test "has many items" do
    assert_equal 10, @bucketlist.items.count
    Item.all.each do |item|
      assert_equal @bucketlist, item.bucketlist
      assert_equal @bucketlist.id, item.relationship_id
    end
  end

  test "belongs to user" do
    Bucketlist.delete_all
    assert_empty Bucketlist.all
    user = create(:user_with_bucketlist)

    assert_equal 10, user.bucketlists.count
    assert_equal 10, Bucketlist.count
    Bucketlist.all.each do |blist|
      assert_equal user, blist.user
      assert_equal user.id, blist.relationship_id
    end
  end

  test "destroys dependent items when deleted" do
    assert_equal 10, Item.count
    @bucketlist.destroy
    assert_equal 0, Item.count
  end

  test "returns pending items" do
    assert_equal 10, @bucketlist.pending.count
  end

  test "returns completed items" do
    num = rand(1..5)
    num.times do
      @bucketlist.items.create(done: true, name: Faker::Lorem.word)
    end
    assert_equal num + 10, @bucketlist.items.count
    assert_equal num, @bucketlist.completed.count
  end

  test "returns item that match a search" do
    num = rand(1..5)
    num.times do
      Bucketlist.create(name: "#{Faker::Lorem.word}maTch")
    end
    assert_equal num + 1, Bucketlist.count
    assert_equal num, Bucketlist.search("maTch").count
  end

  test "returns bucketlist that doesn't belong to the user" do
    Bucketlist.delete_all
    email = Faker::Internet.email
    user1 = create(:user_with_bucketlist, amount: 2, email: email)
    user2 = create(:user_with_bucketlist)

    assert_equal 12, Bucketlist.count
    assert_equal 10, user2.bucketlists.count
    result = Bucketlist.not_mine(user2)
    assert_equal 2, result.count
    assert_equal result, user1.bucketlists
  end
end
