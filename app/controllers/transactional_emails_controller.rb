class TransactionalEmailsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_transactional_email, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  # GET /transactional_emails
  # GET /transactional_emails.json
  def index
    @transactional_emails = TransactionalEmail.all.paginate(page: params[:page], per_page: 8)
  end

  # GET /transactional_emails/1
  # GET /transactional_emails/1.json
  def show
  end

  # GET /transactional_emails/new
  def new
    @transactional_email = TransactionalEmail.new
  end

  # GET /transactional_emails/1/edit
  def edit
  end

  # POST /transactional_emails
  # POST /transactional_emails.json
  def create
    @transactional_email = TransactionalEmail.new(transactional_email_params)

    respond_to do |format|
      if @transactional_email.save
        format.html { redirect_to transactional_emails_path, notice: 'Transactional email was successfully created.' }
        format.json { render :show, status: :created, location: @transactional_email }
      else
        format.html { render :new }
        format.json { render json: @transactional_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactional_emails/1
  # PATCH/PUT /transactional_emails/1.json
  def update
    if params[:commit] == 'Test'
      TransactionMailer.send_test_email(@transactional_email.type_id, params[:send_to])
    else
      @transactional_email.update(transactional_email_params)
    end
  end

  # DELETE /transactional_emails/1
  # DELETE /transactional_emails/1.json
  def destroy
    @transactional_email.destroy
    respond_to do |format|
      format.html { redirect_to transactional_emails_url, notice: 'Transactional email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_transactional_email
    @transactional_email = TransactionalEmail.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transactional_email_params
    params.require(:transactional_email).permit(:name, :subject, :body, :send_to)
  end
end
