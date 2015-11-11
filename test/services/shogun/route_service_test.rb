require 'test_helper'

class RouteServiceTest < ActiveSupport::TestCase

  test "reloads the RouteService instance" do
    @r = Shogun::RouteService.instance.reload!

    # Ensure return from Reload (the @pages hash) is of type Hamster::Hash
    assert Hamster::Hash === @r, "Expected Hamster::Hash, got #{@r.class.name}"
  end

end
