require "test_helper"
require "json"

class AttachmentTest < Minitest::Test
  def setup
    @shrine = uploader.class
    user_class = Struct.new(:avatar_data)
    user_class.include @shrine[:avatar]
    @user = user_class.new
  end

  test "assigns the correct attacher class" do
    assert_equal @shrine, @user.avatar_attacher.shrine_class
  end

  test "setting and getting" do
    @user.avatar = fakeio("image")

    assert_equal "image", @user.avatar.read
  end

  test "url" do
    @user.avatar = fakeio("image")

    refute_empty @user.avatar_url
  end

  test "inheritance" do
    admin_class = Class.new(@user.class)
    admin = admin_class.new

    admin.avatar = fakeio("image")

    assert_equal "image", admin.avatar.read
  end

  test "introspection" do
    assert_match "Attachment(avatar)", @user.class.ancestors[1].inspect
  end

  test ".attachment alias" do
    @user.class.include @shrine.attachment(:foo)
    assert_instance_of @shrine::Attachment, @user.class.ancestors[1]
  end
end
