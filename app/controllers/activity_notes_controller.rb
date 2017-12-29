# Manage notes inside a particular activity
class ActivityNotesController < ApplicationController
  before_action :authenticate_user!, :set_activity
  before_action :set_note, only: %i[show update destroy]
  respond_to :js

  def index
    @notes = @activity.notes.paginate(page: params[:page], per_page: 8)
    redirect_to edit_activity_path(@activity) if request.format.html?
  end

  def new
    @note = @activity.notes.new
  end

  def create
    @note = @activity.notes.new(note_params)
    return unless @note.save
    flash.now[:success] = 'Note was successfully created.'
  end

  def show; end

  def update
    return unless @note.update(note_params)
    flash.now[:success] = 'Note was successfully updated.'
  end

  def destroy
    if @note.destroy
      flash.now[:success] = 'Note was successfully destroyed.'
    else
      flash.now[:danger] = 'Note could not be destroyed.'
    end
  end

  private

  def set_activity
    @activity = current_org.activities.where(id: params[:activity_id]).first
  end

  def note_params
    params.require(:note).permit(:subject, :date_str, :description)
  end

  def set_note
    @note = @activity.notes.where(id: params[:id]).first
    return unless @note.blank?
    flash[:danger] = 'Note not found.'
    redirect_to edit_activity_path
  end
end
