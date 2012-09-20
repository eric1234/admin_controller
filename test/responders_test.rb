require File.expand_path('../test_helper.rb', __FILE__)

class RespondersControllerTest < ActionController::TestCase
  
  test 'new' do
    get :new
    assert_match /form called/i, @response.body
  end

  test 'edit' do
    get :edit, :id => 'fake'
    assert_match /form called/i, @response.body
  end

  test 'create fail' do
    post :create
    assert_match /form called/i, @response.body
  end
  test 'update fail' do
    put :update, :id => 'fake'
    assert_match /form called/i, @response.body
  end

  test 'over-written navigation_location' do
    delete :destroy, :id => 'fake'
    assert_redirected_to '/objects'
  end

end

# An example controller we can test with
class RespondersController < ActionController::Base
  include Rails.application.routes.url_helpers
  self.responder = AdminController::Responder
  respond_to :html
  prepend_view_path "test/fixtures/controller_views"

  def new; respond_with(Object.new) end
  def edit; respond_with(Object.new) end
  def create
    obj = Object.new
    def obj.errors; ['Fail'] end
    respond_with obj
  end
  def update
    obj = Object.new
    def obj.errors; ['Fail'] end
    respond_with obj
  end
  def destroy; respond_with Object.new end

  protected

  def navigation_location; '/objects' end
end
