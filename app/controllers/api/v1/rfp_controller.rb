class Api::V1::RfpController < Api::BaseAllowExternalController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # before_action :authenticate_employee! # test with non authen, please uncomment for production
  before_action :set_rfp, only: [:bid_update, :result, :show, :rfp_countries, :update_bid_details, :update_targetings, :update_cpi_feasible_total]

  def index
    page = params[:page].present? ? params[:page].to_i : 1
    rfps = Rfp.offset((page - 1) * Rfp::RFP_PAGINATE).limit(Rfp::RFP_PAGINATE).order(created_at: :desc)

    total = Rfp.count

    if params[:vendor].present?
      vendor = Vendor.find(params[:vendor])
      
      rfps = vendor.rfps.offset((page - 1) * Rfp::RFP_PAGINATE).limit(Rfp::RFP_PAGINATE).order(created_at: :desc)
      total = rfps.count
    end

    result = params[:vendor].present? ?
      rfps.map {|r| RfpRepresenter.new(rfp: r).open_bids_as_json(true) } :
      rfps.map {|r| RfpRepresenter.new(rfp: r).open_bids_as_json }

    render json: ResponseFormatRepresenter.new(
      success: true,
      code: 200,
      payload: {
        items: result.as_json,
        total: total,
        per_page: Rfp::RFP_PAGINATE
      }
    ), status: :ok
  end

  def show
    render json: ResponseFormatRepresenter.new(
      success: true,
      code: 200,
      payload: RfpRepresenter.new(rfp: @rfp).show
    ), status: :ok
  end

  def rfp_countries
    begin
      rfp_country = @rfp.rfp_countries.find(params[:rfp_country_id])
      result = rfp_country.as_json(
        include: [
          {
            rfp_targets: {
              include: [:target_type, :rfp_target_qualifications],
              except: [:target_type_id],
              methods: [:vendors_overview]
            }
          }
        ]
      )

      render json: ResponseFormatRepresenter.new(
        success: true,
        code: 200,
        payload: result
      ), status: :ok
    rescue => exception
      render json: ResponseFormatRepresenter.new(
        success: false,
        code: 400,
        payload: {},
        message: exception.as_json || @rfp|| "Something wrong, please checking again!"
      ), status: :ok
    end
  end

  def create_bid_details
    begin
      project = Project.find(params[:projectId])

      @rfp = Rfp.create!(
        project_id: project.id,
        total_n_size: params[:totalNSize],
        no_of_countries: params[:noOfCountries],
        no_of_open_ends: params[:noOfOpenEnds],
        pi: params[:pi],
        qualfollowup: params[:qualfollowup],
        tracker: params[:tracker],
        additional_details: params[:additionalDetails],
        assigned_to_id: Employee.first.id
      )

      if @rfp

        params[:countries].each do |k, v|
          rfp_country = @rfp.rfp_countries.create!(
            tblRFP_id: @rfp.id,
            country_id: v[:id]
          )
          
          (1..v[:noOfTargets].to_i).each do |i|
            RfpTarget.create!(
              tblRFP_id: @rfp.id,
              country_id: rfp_country.id,
              name: "Target #{i}",
              quotas: 0,
              target_type_id: TargetType.first.id
            )
          end
        end

        @rfp.attachment.attach(params[:file]) if params[:file].present?

        render json: ResponseFormatRepresenter.new(
          success: true,
          code: 200,
          payload: RfpRepresenter.new(rfp: @rfp).created_bid_details_as_json,
          message: "RFP bid details create successfully!"
        ), status: :ok
      end
    rescue Redis::CannotConnectError => e
      render json: ResponseFormatRepresenter.new(
        success: true,
        code: 200,
        payload: RfpRepresenter.new(rfp: @rfp).created_bid_details_as_json,
        message: "RFP bid details create successfully!"
      ), status: :ok
      return
    rescue => exception
      render json: ResponseFormatRepresenter.new(
        success: false,
        code: 400,
        payload: {},
        message: exception.as_json || @rfp|| "Something wrong, please checking again!"
      ), status: :ok
    end
  end

  def update_bid_details
    begin
      @rfp.project_id = params[:projectId] if params[:projectId].present?
      @rfp.total_n_size = params[:totalNSize] if params[:totalNSize].present?
      @rfp.no_of_countries = params[:noOfCountries] if params[:noOfCountries].present?
      @rfp.no_of_open_ends = params[:noOfOpenEnds] if params[:noOfOpenEnds].present?
      @rfp.pi = params[:pi] if params[:pi].present?
      @rfp.qualfollowup = params[:qualfollowup] if params[:qualfollowup].present?
      @rfp.tracker = params[:tracker] if params[:tracker].present?
      @rfp.additional_details = params[:additionalDetails] if params[:additionalDetails].present?

      if params[:file].present?
        @rfp.attachment.purge
        @rfp.attachment.attach(params[:file])
      end

      render json: ResponseFormatRepresenter.new(
        success: true,
        code: 200,
        payload: {},
        message: @rfp.save ? "Update successfully!" : "Update failed!"
      ), status: :ok
    rescue Redis::CannotConnectError => e
      render json: ResponseFormatRepresenter.new(
        success: true,
        code: 200,
        payload: RfpRepresenter.new(rfp: @rfp).created_bid_details_as_json,
        message: "RFP bid details create successfully!"
      ), status: :ok
      return
    rescue => exception
      render json: ResponseFormatRepresenter.new(
        success: false,
        code: 400,
        payload: {},
        message: exception.as_json || @rfp|| "Something wrong, please checking again!"
      ), status: :ok
    end
  end

  def create_targetings
    begin
      @rfp = Rfp.find(params[:rfpId])

      params[:rfpCountries].each do |v|
        v[:targets].each do |tv|
          rfp_target = RfpTarget.find(tv[:id])

          unless rfp_target.nil?
            rfp_target.update!(
              name: tv[:name],
              ir: tv[:ir],
              loi: tv[:loi],
              nsize: tv[:nsize],
              target_type_id: tv[:targetTypeId],
              quotas: tv[:quotas]
            )

            tv[:qualifications].each do |qual_value|
              rfp_qual = RfpTargetQualification.create!(
                tblRFP_id: params[:rfpId],
                target_id: rfp_target.id,
                field_name: qual_value[:fieldName],
                field_value: qual_value[:fieldValue]
              )
            end

            tv[:vendors].each do |vendor_id|
              rfp_vendor = RfpVendor.create!(
                tblRFP_id: @rfp.id,
                vendor_id: vendor_id,
                rfp_target_id: rfp_target.id,
              )
              # send email to vendor to be invited, please uncomment with production
              # VendorMailer.invite(nil).deliver_now # change to deliver_later if u want run on bg job
            end
          end
        end
      end

      render json: ResponseFormatRepresenter.new(
        success: true,
        code: 200,
        payload: {
          rfpId: @rfp.id
        },
        message: "RFP targetings create successfully!"
      ), status: :ok
    rescue => exception
      render json: ResponseFormatRepresenter.new(
        success: false,
        code: 400,
        payload: {},
        message: exception.as_json || "Something wrong, please checking again!"
      ), status: :ok
    end
  end

  def update_targetings
    begin
      params[:rfpCountries].each do |rfp_country|
        rfp_country[:targets].each do |target|
          rfp_target = @rfp.rfp_targets.find(target[:id])

          rfp_target.name = target[:name] if target[:name].present?
          rfp_target.ir = target[:ir] if target[:ir].present?
          rfp_target.loi = target[:loi] if target[:loi].present?
          rfp_target.nsize = target[:nsize] if target[:nsize].present?
          rfp_target.target_type_id = target[:targetTypeId] if target[:nsize].present?
          rfp_target.quotas = target[:quotas] if target[:quotas].present?

          rfp_target.save!

          target[:qualifications].each do |qual|
            rfp_qualification = rfp_target.rfp_target_qualifications.find_by(id: qual[:id])

            if rfp_qualification
              rfp_qualification.field_name = qual[:fieldName] if qual[:fieldName].present?
              rfp_qualification.field_value = qual[:fieldValue] if qual[:fieldValue].present?
              rfp_qualification.save!
            else
              RfpTargetQualification.create!(
                tblRFP_id: @rfp.id,
                target_id: rfp_target.id,
                field_name: qual[:fieldName],
                field_value: qual[:fieldValue]
              )
            end
          end
        end
      end
      render json: ResponseFormatRepresenter.new(
        success: true,
        code: 200,
        payload: {},
        message: "Update successfully!"
      ), status: :ok
    rescue => exception
      render json: ResponseFormatRepresenter.new(
        success: false,
        code: 400,
        payload: {},
        message: exception.as_json || "Something wrong, please checking again!"
      ), status: :ok
    end
  end

  def result
    begin
      rfp_countries_with_target = @rfp.rfp_countries.map do |rc|
        targets = []
        rc.rfp_targets.each do |rt|
          quals = []
          keys = []

          rt.rfp_target_qualifications.map do |rtq|
            values = rtq.field_name === "Age Group" ? [rtq.field_value] : JSON.parse(rtq.field_value)
            quals.push(values)
            keys.push(rtq.field_name)
          end

          while quals.count < 4 || keys.count < 4
            quals.push([""])
            keys.push("key")
          end

          # maximum 4 loop => 16 record
          fields = []
          quals[0].each {|i0| quals[1].each{|i1| quals[2].each{|i2| quals[3].each{|i3| fields.push({"#{keys[0]}": i0, "#{keys[1]}": i1, "#{keys[2]}": i2, "#{keys[3]}": i3})}}}}
          fields.map {|f| f.delete(:key)}
          targets.push({
            id: rt.id,
            name: rt.name,
            cpi: rt.rfp_vendors.count === 0 ? 0 : rt.rfp_vendors.first.cpi,
            cpiDetail: rt.cpi_detail,
            feasibleCount: rt.rfp_vendors.count === 0 ? 0 : rt.rfp_vendors.first.feasible_count,
            feasibleCountDetail:rt.feasible_detail,
            fields: fields,
          })
        end
        {
          id: rc.id,
          countryName: rc.country.name,
          targets: targets
        }
      end

      result = {
        id: @rfp.id,
        wo: @rfp.id,
        projectName: @rfp.project.name,
        bidDueDate: @rfp.bid_due_date,
        rfpCountries: rfp_countries_with_target
      }

      render json: ResponseFormatRepresenter.new(
        success: true,
        code: 200,
        payload: result,
      ), status: :ok
     rescue => exception
      render json: ResponseFormatRepresenter.new(
        success: false,
        code: 400,
        payload: {},
        message: exception.as_json || "Something wrong, please checking again!"
      ), status: :ok
    end
  end

  def update_cpi_feasible_total
    begin
      rfp_target = RfpTarget.find(params[:targetId])
      
      rfp_target.cpi_detail = params[:cpiDetail] if params[:cpiDetail].present?
      rfp_target.feasible_detail= params[:feasibleCountDetail] if params[:feasibleCountDetail].present?

      rfp_target.rfp_vendors.each do |rv|
        rv.cpi = params[:cpi] if params[:cpi].present?
        rv.feasible_count = params[:feasibleCount] if params[:feasibleCount].present?
        
        rv.save!
      end

      rfp_target.save!
      
      render json: ResponseFormatRepresenter.new(
        success: true,
        code: 200,
        payload: {},
        message: "Update successfully!"
      ), status: :ok
    rescue => exception
            render json: ResponseFormatRepresenter.new(
        success: false,
        code: 400,
        payload: {},
        message: exception.as_json || "Something wrong, please checking again!"
      ), status: :ok
    end
  end
  

  def vendor
    begin
      vendor = Vendor.find(params[:id])
      page = params[:page].present? ? params[:page].to_i : 1

      rfps = vendor.rfps.where(status: "open").offset((page - 1) * Rfp::RFP_PAGINATE).limit(Rfp::RFP_PAGINATE).order(created_at: :desc)

      result = {
        id: vendor.id,
        name: vendor.name,
        rfpList: rfps.map do |rfp|
          {
            rfpId: rfp.id,
            wo: rfp.project.work_order,
            projectName: rfp.project.name,
            totalNSize: rfp.total_n_size,
            bidDueDate: rfp.bid_due_date
          }
        end
      }

      render json: ResponseFormatRepresenter.new(
        success: true,
        code: 200,
        payload: {
          items: result.as_json,
          total: rfps.count,
          per_page: Rfp::RFP_PAGINATE
        }
      ), status: :ok
      
    rescue => exception
      render json: ResponseFormatRepresenter.new(
        success: false,
        code: 400,
        payload: {},
        message: exception.as_json || "Something wrong, please checking again!"
      ), status: :ok
    end
  end

  def bid_update
    begin
      @rfp.update!(status: "close")
      @rfp.rfp_vendors.update_all(status: "close")

      render json: ResponseFormatRepresenter.new(
        success: true,
        code: 200,
        payload: {},
        message: "Update successfully!"
      ), status: :ok
      
    rescue => exception
      render json: ResponseFormatRepresenter.new(
        success: false,
        code: 400,
        payload: {},
        message: exception.as_json || "Something wrong, please checking again!"
      ), status: :ok
    end
  end

  private

  def set_rfp
    @rfp = Rfp.find(params[:id])
  end

  def record_not_found
    render json: ResponseFormatRepresenter.new(
      success: false,
      code: 422,
      payload: {},
      error: "Record not found"
    ).send, status: 422
  end
end
