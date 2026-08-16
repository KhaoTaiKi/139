class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy toggle confirm_delete]

  # GET /tasks or /
  def index
    # Auto-seed default tasks if database is empty so F5 / reload always restores starter tasks
    seed_default_tasks_if_empty

    @filter = params[:filter]
    @tasks = case @filter
    when "active" then Task.active.recent
    when "completed" then Task.completed.recent
    else Task.recent
    end
    @task = Task.new
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.completed ||= false

    if @task.save
      @tasks = Task.recent
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to tasks_path, notice: "Task created successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/1/edit
  def edit
  end

  # GET /tasks/1/confirm_delete
  def confirm_delete
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      @tasks = Task.recent
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to tasks_path, notice: "Task updated." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /tasks/1/toggle
  def toggle
    @task.update(completed: !@task.completed?)
    @tasks = Task.recent
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tasks_path }
    end
  end

  # DELETE /tasks/1
  def destroy
    @deleted_title = @task.title
    @task.destroy
    @tasks = case params[:filter]
    when "active" then Task.active.recent
    when "completed" then Task.completed.recent
    else Task.recent
    end
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tasks_path, notice: "Task deleted." }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :completed)
  end

  def seed_default_tasks_if_empty
    return if Task.exists?

    Task.create!([
      { title: "Review Phase 1 Rails Hotwire Architecture Slide Deck", completed: true },
      { title: "Implement Turbo Frames for Scoped Task Item Updates", completed: true },
      { title: "Broadcast Real-Time Task Mutations with Turbo Streams", completed: false },
      { title: "Deploy Production SQLite3 & Propshaft Asset Pipeline", completed: false }
    ])
  end
end
