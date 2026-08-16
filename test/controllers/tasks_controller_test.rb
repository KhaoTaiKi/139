require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task = tasks(:second_task)
  end

  test "should get index" do
    get tasks_url
    assert_response :success
    assert_select "header", text: /Doearly Tasks/
  end

  test "should get index with active filter" do
    get tasks_url(filter: "active")
    assert_response :success
  end

  test "should get index with completed filter" do
    get tasks_url(filter: "completed")
    assert_response :success
  end

  test "should get new" do
    get new_task_url
    assert_response :success
    assert_select "form"
  end

  test "should get confirm_delete" do
    get confirm_delete_task_url(@task)
    assert_response :success
    assert_select "h3", text: /Delete Task Confirmation/
  end

  test "should create task via HTML format" do
    assert_difference("Task.count", 1) do
      post tasks_url, params: { task: { title: "New Task from Test" } }
    end

    assert_redirected_to tasks_url
    assert_equal "New Task from Test", Task.last.title
  end

  test "should create task via Turbo Stream format" do
    assert_difference("Task.count", 1) do
      post tasks_url, params: { task: { title: "New Turbo Task" } }, as: :turbo_stream
    end

    assert_response :success
    assert_match(/turbo-stream/, response.media_type)
    assert_includes response.body, %(target="tasks_list")
  end

  test "should not create invalid task" do
    assert_no_difference("Task.count") do
      post tasks_url, params: { task: { title: "" } }
    end

    assert_response :unprocessable_entity
  end

  test "should toggle task completion" do
    initial_status = @task.completed?

    patch toggle_task_url(@task), as: :turbo_stream
    assert_response :success

    @task.reload
    assert_equal !initial_status, @task.completed?
  end

  test "should destroy task via Turbo Stream format" do
    assert_difference("Task.count", -1) do
      delete task_url(@task), as: :turbo_stream
    end

    assert_response :success
    assert_match(/turbo-stream/, response.media_type)
    assert_includes response.body, %(action="remove")
  end
end
