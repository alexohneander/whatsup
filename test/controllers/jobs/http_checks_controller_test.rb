require "test_helper"

class Jobs::HttpChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @jobs_http_check = jobs_http_checks(:one)
  end

  test "should get index" do
    get jobs_http_checks_url
    assert_response :success
  end

  test "should get new" do
    get new_jobs_http_check_url
    assert_response :success
  end

  test "should create jobs_http_check" do
    assert_difference("Jobs::HttpCheck.count") do
      post jobs_http_checks_url, params: { jobs_http_check: {  } }
    end

    assert_redirected_to jobs_http_check_url(Jobs::HttpCheck.last)
  end

  test "should show jobs_http_check" do
    get jobs_http_check_url(@jobs_http_check)
    assert_response :success
  end

  test "should get edit" do
    get edit_jobs_http_check_url(@jobs_http_check)
    assert_response :success
  end

  test "should update jobs_http_check" do
    patch jobs_http_check_url(@jobs_http_check), params: { jobs_http_check: {  } }
    assert_redirected_to jobs_http_check_url(@jobs_http_check)
  end

  test "should destroy jobs_http_check" do
    assert_difference("Jobs::HttpCheck.count", -1) do
      delete jobs_http_check_url(@jobs_http_check)
    end

    assert_redirected_to jobs_http_checks_url
  end
end
