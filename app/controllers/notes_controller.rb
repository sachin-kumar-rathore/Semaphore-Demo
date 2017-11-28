class NotesController < ApplicationController
  
  before_action :authenticate_user!, :set_project
  before_action :set_note, only: [:show, :update, :destroy]
  respond_to :js

  def index
    @notes = @project.notes.paginate(page: params[:page], per_page: 8)
    redirect_to edit_project_path(@project) if request.format.html?
  end

  def new
    @note = @project.notes.new
  end

  def create
    @note = @project.notes.new(note_params)
    if @note.save
      flash.now[:success] = 'Note was successfully created.'
    end
  end

  def show
  end

  def update
    if @note.update(note_params)
      flash.now[:success] = 'Note was successfully updated.'
    end
  end

  def destroy
    if @note.destroy
      flash.now[:success] = 'Note was successfully destroyed.'
    else
      flash.now[:danger] = 'Note could not be destroyed.'
    end
  end

  private

  def set_project
    @project = current_org.projects.where(id: params[:project_id]).first
  end

  def note_params
    params.require(:note).permit(:subject, :date_str, :description)
  end

  def set_note
    @note = @project.notes.where(id: params[:id]).first
  end

end
