require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get comments_index_url
    assert_response :success
  end

  test "should get show" do
    get comments_show_url
    assert_response :success
  end

  test "should get create" do
    get comments_create_url
    assert_response :success
  end

  test "should get edit" do
    get comments_edit_url
    assert_response :success
  end

  test "should get destory" do
    get comments_destory_url
    assert_response :success
  end
end
