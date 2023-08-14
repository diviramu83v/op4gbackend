# frozen_string_literal: true

class Admin::ProjectProcessorsController < Admin::BaseController
  def index; end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    file = CSV.generate(headers: true) do |csv|
      csv << ['Client name', 'Project start date', 'Project finish date', 'Work order', 'PM report (completes)',
              'Completes HO before', 'Completes HO after', '# rejected IDs', 'Payout', 'CB amount']
      CSV.foreach(params[:project][:upload].path, headers: true) do |row|
        next if row[0].nil?

        if row[0].match(/\((\d*?)\)/).nil?
          csv << ['BAD PROJECT ID', '', '', row[0], row[1], row[2], row[3], row[4],
                  row[5], row[6]]
        else
          project_id = row[0].match(/\((\d*?)\)/)[1]
          project = Project.find_by(id: project_id)

          csv << [project.client.name, project.started_at, project.finished_at, row[0], row[1], row[2], row[3], row[4],
                  row[5], row[6]]
        end
      end
    end
    send_data file, filename: filename
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def filename
    filename = params[:project][:upload].original_filename.split('.')
    filename.pop
    "#{filename.join('_')}_processed.csv"
  end
end
