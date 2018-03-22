class TransactionalEmailsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_transactional_email, only: [:edit, :update]
  layout 'admin'

  # GET /transactional_emails
  # GET /transactional_emails.json
  def index
    @transactional_emails = TransactionalEmail.all.order('type_id')
        #.paginate(page: params[:page], per_page: 8)
  end


  # GET /transactional_emails/1/edit
  def edit
  end


  # PATCH/PUT /transactional_emails/1
  # PATCH/PUT /transactional_emails/1.json
  def update
    if params[:commit] == 'Test'
      test_email_sending
    else
      @transactional_email.update(transactional_email_params)
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

  def valid_email?(email)
    valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    email.present? && (email =~ valid_email_regex)
  end

  def test_email_sending
    if valid_email?(params[:send_to])
      TransactionMailer.send_test_email(@transactional_email.type_id,
                                        transactional_email_params, params[:send_to]).deliver
    else
      @errors = "Email is Invalid!"
    end
  end
end
