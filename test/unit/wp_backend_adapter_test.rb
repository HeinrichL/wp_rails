require 'test_helper'

class WPBackendAdapterTest < ActiveSupport::TestCase

  test "invalid address" do
    assert_equal(WPBackendAdapter.validate_address("unknown address"), false)
  end

  test "validate address" do
    assert_equal(WPBackendAdapter.validate_address("Berliner Tor 7"), true)
  end
end