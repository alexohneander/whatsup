require "application_system_test_case"

class Jobs::HttpChecksTest < ApplicationSystemTestCase
  setup do
    @jobs_http_check = jobs_http_checks(:one)
  end

  test "visiting the index" do
    visit jobs_http_checks_url
    assert_selector "h1", text: "Http checks"
  end

  test "should create http check" do
    visit jobs_http_checks_url
    click_on "New http check"

    click_on "Create Http check"

    assert_text "Http check was successfully created"
    click_on "Back"
  end

  test "should update Http check" do
    visit jobs_http_check_url(@jobs_http_check)
    click_on "Edit this http check", match: :first

    click_on "Update Http check"

    assert_text "Http check was successfully updated"
    click_on "Back"
  end

  test "should destroy Http check" do
    visit jobs_http_check_url(@jobs_http_check)
    click_on "Destroy this http check", match: :first

    assert_text "Http check was successfully destroyed"
  end
end
