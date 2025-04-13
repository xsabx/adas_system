require 'prawn'

class ContractsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contract, only: [:download, :accept]
  before_action :authorize_worker, only: [:new, :create]
  before_action :authorize_client, only: [:download, :accept]

  def new
    @clients = User.where(role: 'client')
    @contract = Contract.new
    @contract_type = params[:contract_type]

    # Build the appropriate contract type based on params[:contract_type]
    if @contract_type == 'company'
      @contract.build_company_contract
    elsif @contract_type == 'individual'
      @contract.build_individual_contract
    end
  end

  def create
    @contract = Contract.new(contract_params)
    @contract.registered_by = current_user.id
    @contract.status = 'draft'  # Set initial status
    @contract.registration_time = Time.current  # Set registration time
    @contract_type = params[:contract_type]

    # Remove attributes for the non-selected contract type
    if @contract_type == 'company'
      @contract.individual_contract = nil
    elsif @contract_type == 'individual'
      @contract.company_contract = nil
    end

    if @contract.save
      generate_and_attach_pdf
      redirect_to workers_show_path, notice: 'Contract was successfully created.'
    else
      @clients = User.where(role: 'client')
      render :new
    end
  end

  def download
    if @contract.pdf.attached?
      send_data @contract.pdf.download, 
                filename: "contract_#{@contract.id}.pdf",
                type: 'application/pdf',
                disposition: 'attachment'
    else
      redirect_to clients_show_path, alert: 'No PDF attached to this contract.'
    end
  end

  def accept
    if @contract.update(status: 'accepted', signed_at: Time.current)
      redirect_to clients_show_path, notice: 'Contract was successfully accepted.'
    else
      redirect_to clients_show_path, alert: 'Failed to accept contract.'
    end
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def authorize_worker
    unless current_user.worker?
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def authorize_client
    unless current_user.client? && @contract.user_id == current_user.id
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def contract_params
    params.require(:contract).permit(
      :user_id,
      company_contract_attributes: [:company_name, :registration_no, :representative, 
                                  :service_description, :price, :duration, :company_address],
      individual_contract_attributes: [:service_description, :price, :duration]
    )
  end

  def generate_and_attach_pdf
    pdf = Prawn::Document.new

    pdf.text "Contract ##{@contract.id}", size: 20, style: :bold
    pdf.move_down 20

    client = User.find(@contract.user_id)
    creator = User.find(@contract.registered_by)
    
    pdf.text "Client: #{client.name}"
    pdf.text "Created by: #{creator.name}"
    pdf.text "Date: #{@contract.created_at.strftime('%B %d, %Y')}"
    pdf.move_down 20

    if @contract.company_contract.present?
      pdf.text "Company Contract Details", style: :bold
      pdf.move_down 10
      pdf.text "Company Name: #{@contract.company_contract.company_name}"
      pdf.text "Registration Number: #{@contract.company_contract.registration_no}"
      pdf.text "Representative: #{@contract.company_contract.representative}"
      pdf.text "Service Description: #{@contract.company_contract.service_description}"
      pdf.text "Price: $#{@contract.company_contract.price}"
      pdf.text "Duration: #{@contract.company_contract.duration}"
      pdf.text "Company Address: #{@contract.company_contract.company_address}"
    elsif @contract.individual_contract.present?
      pdf.text "Individual Contract Details", style: :bold
      pdf.move_down 10
      pdf.text "Service Description: #{@contract.individual_contract.service_description}"
      pdf.text "Price: $#{@contract.individual_contract.price}"
      pdf.text "Duration: #{@contract.individual_contract.duration}"
    end

    # Generate PDF content
    pdf_content = pdf.render

    # Attach the PDF directly from the content
    @contract.pdf.attach(
      io: StringIO.new(pdf_content),
      filename: "contract_#{@contract.id}.pdf",
      content_type: 'application/pdf'
    )
  end
end 