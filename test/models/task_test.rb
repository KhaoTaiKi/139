require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "should not save task without title" do
    task = Task.new(title: "")
    assert_not task.save, "Saved task without a title"
    assert_includes task.errors[:title], "can't be blank"
  end

  test "should save task with valid title" do
    task = Task.new(title: "Write comprehensive unit tests")
    assert task.save, "Failed to save valid task"
    assert_not task.completed?, "Default completed status should be false or nil"
  end

  test "scope completed returns only completed tasks" do
    completed_tasks = Task.completed
    assert completed_tasks.any?, "Expected at least one completed task"
    completed_tasks.each do |task|
      assert task.completed?, "Task #{task.id} should be completed"
    end
  end

  test "scope active returns only uncompleted tasks" do
    active_tasks = Task.active
    assert active_tasks.any?, "Expected at least one active task"
    active_tasks.each do |task|
      assert_not task.completed?, "Task #{task.id} should not be completed"
    end
  end

  test "completed? method returns boolean accurately" do
    task = Task.new(completed: true)
    assert_equal true, task.completed?

    task.completed = false
    assert_equal false, task.completed?

    task.completed = nil
    assert_equal false, task.completed?
  end
end
