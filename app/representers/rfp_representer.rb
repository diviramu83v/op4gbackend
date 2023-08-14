class RfpRepresenter
  def initialize(rfp:)
    @rfp = rfp
  end

  def created_bid_details_as_json
    {
      rfpId: rfp.id,
      rfpCountries: rfp.rfp_countries.map do |rfp_c|
        {
          id: rfp_c.id,
          countryName: rfp_c.country.name,
          targets: rfp_c.rfp_targets.as_json(except: [:tblRFP_id, :country_id, :ir, :loi, :nsize, :type_name, :quotas, :target_type_id])
        }
      end
    }
  end

  def open_bids_as_json(to_be_invited = false)
    {
      wo: rfp.id,
      clientName: !rfp.project.client.nil? ? rfp.project.client.name : "",
      projectName: rfp.project.name,
      projectManager: !rfp.project.manager.nil? ? rfp.project.manager.name : "",
      vendorsInvited: to_be_invited ? 1 : rfp.rfp_vendors.count,
      vendorsResponded: rfp.rfp_vendors.where("feasible_count != 0 AND cpi != 0").count,
      assignedTo: rfp.assigned_to.name,
      bidDueDate: rfp.bid_due_date
    }
  end

  def rfp_result_as_json
    {
      id: rfp.id,
      wo: rfp.project.work_order,
      projectName: rfp.project.name,
      bidDueDate: rfp.bid_due_date,
      rfpCountries: rfp.rfp_countries.map do |rfp_c|
        {
          id: rfp_c.id,
          countryName: rfp_c.country.name,
          targets: rfp_c.rfp_targets.map do |target|
            {
              id: target.id,
              fields: target.rfp_target_qualifications.as_json(except: [:id, :tblRFP_id, :target_id])
            }
          end
        }
      end
    }
  end

  def show
    rfp.as_json(
      except: [:created_at, :updated_at, :project_id],
      methods: [:attachmentFile],
      include: [
        {
          rfp_countries: {
            include: [:country],
            methods: [:targetCount]
          }
        }
      ]
    ).merge(project: {id: rfp.project.id, name: rfp.project.name})
  end

  private attr_reader :rfp
end