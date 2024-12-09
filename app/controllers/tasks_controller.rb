class TasksController < ApplicationController

  def index
    tasks = @current_user.tasks.paginate(page: params[:page], per_page: 10)
    render json: tasks
  end

  def show
    task = @current_user.tasks.find_by(id: params[:task_id])
    render json: task
  end

  def create
    task = @current_user.tasks.build(task_params)
    if task.save
      render json: {message: "task created successfully!!"}, status: 200
    else
      render json: task.errors.full_messages
    end
  end

  def update
    task = @current_user.tasks.find_by(id: params[:task_id])
    if task.update(task_params)
      render json: {message: "#{task} - task updated successfully!!"}
    else
      render json: task.errors, status: 403
    end
  end

  def destroy
    task = @current_user.tasks.find_by(id: params[:id])
    if task.destroy
      render json: {message: "task destroyed successfully!!"}, status: 200
    else
      render json: task.errors.full_messages
    end
  end

  private

  def task_params
    params.require(:task).premit(:title, :description, :status, :due_date)
  end

end