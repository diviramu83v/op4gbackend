# frozen_string_literal: true

class BackfillSlugForDemoQueryProjectInclusions < ActiveRecord::Migration[5.2]
  def change
    DemoQueryProjectInclusion.find_each do |demo_query_project_inclusion|
      slug = demo_query_project_inclusion.survey_response_pattern.slug

      demo_query_project_inclusion.update(slug: slug)
    end
  end
end
