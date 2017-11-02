class NotesController < ApplicationController
  
  before_action :authenticate_user!, :set_project
  before_action :set_note, only: [:show, :update, :destroy]

  def index
    if @project
      @notes = @project.notes.paginate(page: params[:page], per_page: 8)
    else
      flash.now[:info] = 'You must save a project before creating notes.'
    end
    respond_to do |format|
      format.js
    end
  end

  def new
    @note = @project.notes.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @note = @project.notes.new(note_params)
    respond_to do |format|
      if @note.save
        flash.now[:success] = 'Note was successfully created.'
      end
      format.js
    end
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        flash.now[:success] = 'Note was successfully updated.'
      end
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @note.destroy
        flash.now[:success] = 'Note was successfully destroyed.'
      else
        flash.now[:info] = 'Note could not be destroyed.'
      end
      format.js
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
