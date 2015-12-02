require "test_helper"

class ItemTest < ActiveSupport::TestCase
  test "belongs to a bucketlist" do
    Bucketlist.delete_all
    assert_empty Item.all
    blist = create(:bucketlist_with_items)

    assert_equal 10, blist.items.count
    assert_equal 10, Item.count
    Item.all.each do |item|
      assert_equal blist, item.bucketlist
      assert_equal blist.id, item.relationship_id
    end
  end
end
