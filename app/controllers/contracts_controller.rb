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

    if @contract_type == 'company'
      @contract.build_company_contract
    elsif @contract_type == 'individual'
      @contract.build_individual_contract
    end
  end

  def create
    @contract = Contract.new(contract_params)
    @contract.registered_by = current_user.id
    @contract.status = 'active'
    @contract.registration_time = Time.current
    @contract_type = params[:contract_type]

    if @contract_type == 'company'
      @contract.individual_contract = nil
    elsif @contract_type == 'individual'
      @contract.company_contract = nil
    end

    if @contract.save
      generate_and_attach_pdf
      redirect_to workers_show_path, notice: 'Līgums veiksmīgi izveidots.'
    else
      @clients = User.where(role: 'client')
      render :new
    end
  end

  def download
    if @contract.pdf.attached?
      send_data @contract.pdf.download, 
                filename: "ligums_#{@contract.id}.pdf",
                type: 'application/pdf',
                disposition: 'attachment'
    else
      redirect_to clients_show_path, alert: 'Līgumam nav pievienots PDF fails.'
    end
  end

  def accept
    if @contract.update(status: 'accepted', signed_at: Time.current)
      redirect_to clients_show_path, notice: 'Līgums veiksmīgi apstiprināts.'
    else
      redirect_to clients_show_path, alert: 'Neizdevās apstiprināt līgumu.'
    end
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def authorize_worker
    unless current_user.worker?
      redirect_to root_path, alert: 'Tev nav tiesību veikt šo darbību.'
    end
  end

  def authorize_client
    unless current_user.client? && @contract.user_id == current_user.id
      redirect_to root_path, alert: 'Tev nav piekļuves šim līgumam.'
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
  
    # ✅ Ielādē ārējo fontu ar UTF-8 atbalstu
    font_path = Rails.root.join("app/assets/fonts/DejaVuSans.ttf")
    pdf.font_families.update("DejaVuSans" => { normal: font_path })
    pdf.font("DejaVuSans")
  
    pdf.text "Līgums ##{@contract.id}", size: 20, style: :bold
    pdf.move_down 20
  
    client = User.find(@contract.user_id)
    creator = User.find(@contract.registered_by)
  
    pdf.text "Klients: #{client.name}"
    pdf.text "Izveidoja: #{creator.name}"
    pdf.text "Datums: #{@contract.created_at.strftime('%Y. gada %d. %B')}"
    pdf.move_down 20
  
    if @contract.company_contract.present?
      pdf.text "Uzņēmuma līguma informācija", style: :bold
      pdf.move_down 10
      pdf.text "Uzņēmuma nosaukums: #{@contract.company_contract.company_name}"
      pdf.text "Reģistrācijas numurs: #{@contract.company_contract.registration_no}"
      pdf.text "Pārstāvis: #{@contract.company_contract.representative}"
      pdf.text "Pakalpojuma apraksts: #{@contract.company_contract.service_description}"
      pdf.text "Cena: #{@contract.company_contract.price} €"
      pdf.text "Ilgums: #{@contract.company_contract.duration}"
      pdf.text "Uzņēmuma adrese: #{@contract.company_contract.company_address}"
    elsif @contract.individual_contract.present?
      pdf.text "Fiziskas personas līguma informācija", style: :bold
      pdf.move_down 10
      pdf.text "Pakalpojuma apraksts: #{@contract.individual_contract.service_description}"
      pdf.text "Cena: #{@contract.individual_contract.price} €"
      pdf.text "Ilgums: #{@contract.individual_contract.duration}"
    end
  
    pdf_content = pdf.render
  
    @contract.pdf.attach(
      io: StringIO.new(pdf_content),
      filename: "ligums_#{@contract.id}.pdf",
      content_type: 'application/pdf'
    )
  end  
end
