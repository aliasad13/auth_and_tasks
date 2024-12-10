class Api::V1::TasksController < ApplicationController

  before_action :set_task, only: [:show, :update, :destroy]

  def index
    tasks = @current_user.tasks.paginate(page: params[:page], per_page: 10)
    render json: tasks, each_serializer: TaskSerializer
  end

  def show
    render json: @task, serializer: TaskSerializer
  end

  def create
    task = @current_user.tasks.build(task_params)
    if task.save
      render json: {task: task, message: "task created successfully!!"}, status: 200
    else
      render json: task.errors.full_messages
    end
  end

  def update
    if @task.update(task_params)
      render json: {message: "#{@task.inspect} - task updated successfully!!"}, status: 200
    else
      render json: @task.errors, status: 403
    end
  end

  def destroy
    if @task.destroy
      render json: {message: "task with id #{@task.id} destroyed successfully!!"}, status: 200
    else
      render json: @task.errors.full_messages
    end
  end

  private

  def task_params
    params.permit(:title, :description, :status, :due_date, :id)
  end

  def set_task
    @task = @current_user.tasks.find_by(id: params[:id])
    render json: {error: "Task with id #{params[:id]} not found for this user"}, status: 404 unless @task
  end
end