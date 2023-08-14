# frozen_string_literal: true

class AddPodsAndAddEmployeesToPods < ActiveRecord::Migration[5.2]
  def change
    Pod.create(name: 'Northeast')
    Pod.create(name: 'Southwest')
    Pod.create(name: 'Southeast')

    employees_and_pods = [[40, 'Northeast'],
                          [198, 'Southwest'],
                          [196, 'Southeast'],
                          [54, 'Southeast'],
                          [201, 'Northeast'],
                          [154, 'Southwest'],
                          [36, 'Southwest'],
                          [210, 'Southwest'],
                          [195, 'Southeast'],
                          [80, 'Northeast'],
                          [59, 'Northeast'],
                          [197, 'Southeast'],
                          [69, 'Southwest'],
                          [83, 'Southwest'],
                          [245, 'Southwest'],
                          [212, 'Southeast'],
                          [211, 'Southeast'],
                          [208, 'Southwest'],
                          [194, 'Southeast'],
                          [246, 'Southeast']]
    employees_and_pods.each do |employee_and_pod|
      employee = Employee.find_by(id: employee_and_pod.first)
      next if employee.blank?

      pod = Pod.find_by(name: employee_and_pod.last)
      employee.update(pod: pod)
    end
  end
end
