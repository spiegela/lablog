require File.dirname(__FILE__) + '/../test_helper'
require 'reservations_cart_controller'

# Re-raise errors caught by the controller.
class ReservationsCartController; def rescue_action(e) raise e end; end

class ReservationsCartControllerTest < Test::Unit::TestCase
  def setup
    @controller = ReservationsCartController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
