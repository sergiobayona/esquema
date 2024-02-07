class TasksController < ApplicationController
  def index
    @tasks = Task.all

    respond_to do |format|
      format.html
      format.js
      format.xml { render xml: @tasks }
    end
  end

  def new; end

  def create; end

  def edit
    @task = Task.find(params[:id])
  end

  def update; end
end
