require File.dirname(__FILE__) + '/../test_helper'

class UserDiariesTest < ActionController::IntegrationTest
  fixtures :users, :diary_entries

  def test_showing_create_diary_entry
    get_via_redirect '/user/test/diary/new'
    # We should now be at the login page
    assert_response :success
    assert_template 'user/login'
    # We can now login
    post  '/login', {'user[email]' => "test@openstreetmap.org", 'user[password]' => "test", :referer => '/user/test/diary/new'}
    assert_response :redirect
    #print @response.body
    # Check that there is some payload alerting the user to the redirect
    # and allowing them to get to the page they are being directed to
    assert_select "html:root" do
      assert_select "body" do
        assert_select "a[href='http://www.example.com/user/test/diary/new']"
      end
    end
    # Required due to a bug in the rails testing framework
    # http://markmail.org/message/wnslvi5xv5moqg7g
    @html_document = nil
    follow_redirect!
    
    assert_response :success
    assert_template 'diary_entry/edit'
    #print @response.body
    #print @html_document.to_yaml

    # We will make sure that the form exists here, full 
    # assert testing of the full form should be done in the
    # functional tests rather than this integration test
    # There are some things that are specific to the integratio
    # that need to be tested, which can't be tested in the functional tests
    assert_select "html:root" do
      assert_select "body" do
        assert_select "div#content" do
          assert_select "h1", "New diary entry" 
          assert_select "form[action='/user/#{users(:normal_user).display_name}/diary/new']" do
            assert_select "input[id=diary_entry_title]"
          end
        end
      end
    end
    
    
  end
end
