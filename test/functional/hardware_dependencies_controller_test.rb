require File.dirname(__FILE__) + '/../test_helper'
require 'hardware_dependencies_controller'

# Re-raise errors caught by the controller.
class HardwareDependenciesController; def rescue_action(e) raise e end; end

class HardwareDependenciesControllerTest < Test::Unit::TestCase
  def setup
    @controller = HardwareDependenciesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
