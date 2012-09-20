require File.expand_path('../test_helper.rb', __FILE__)

class CrudsControllerTest < ActionController::TestCase

  test 'index' do
    get :index
    assert_equal ['list'], assigns['mock_objs']
  end

  test 'new' do
    get :new
    assert_instance_of MockObj, assigns['mock_obj']
    assert !assigns['mock_obj'].respond_to?(:found)
    assert !assigns['mock_obj'].saved
    assert !assigns['mock_obj'].destroyed
  end

  test 'create' do
    post :create
    assert_instance_of MockObj, assigns['mock_obj']
    assert !assigns['mock_obj'].respond_to?(:found)
    assert assigns['mock_obj'].saved
    assert !assigns['mock_obj'].destroyed
  end

  test 'edit' do
    get :edit, :id => 'fake'
    assert_instance_of MockObj, assigns['mock_obj']
    assert assigns['mock_obj'].found
    assert !assigns['mock_obj'].saved
    assert !assigns['mock_obj'].destroyed
  end

  test 'update' do
    put :update, :id => 'fake'
    assert_instance_of MockObj, assigns['mock_obj']
    assert assigns['mock_obj'].found
    assert assigns['mock_obj'].saved
    assert !assigns['mock_obj'].destroyed
  end

  test 'destroy' do
    delete :destroy, :id => 'fake'
    assert_instance_of MockObj, assigns['mock_obj']
    assert assigns['mock_obj'].found
    assert !assigns['mock_obj'].saved
    assert assigns['mock_obj'].destroyed
  end

  test 'detection' do
    c = Foo::MockObjController.new
    assert_equal 'mock_obj', c.send(:object_name)
    assert_equal MockObj, c.send(:klass)
  end

end

class MockObj
  attr_accessor :saved, :destroyed

  def initialize(*args)
    self.saved = false
  end
  def attributes=(attrs={}); end
  def save; self.saved = true end
  def destroy; self.destroyed = true end
  def self.all; ['list'] end
  def self.find(*args);
    obj = new
    def obj.found; true end
    obj
  end
  def self.model_name
    m = 'MockObj'
    def m.singular_route_key; :mock_obj end
    def m.human; 'mock obj' end
    def m.plural; 'mock_objs' end
    m
  end
end

# An example controller we can test with
class CrudsController < ActionController::Base
  include Rails.application.routes.url_helpers
  include AdminController::Crud
  prepend_view_path "test/fixtures/controller_views"

  def klass; MockObj end
  def object_name; 'mock_obj' end
  def mock_objs_url(*args); '/url' end
end

# So we can verify object_name and klass resolve correctly
module Foo
  class MockObjController < ActionController::Base
    include Rails.application.routes.url_helpers
    include AdminController::Crud
  end
end
