# frozen_string_literal: true

class Employee::SendIncentiveBatchesController < ApplicationController
  authorize_resource class: 'IncentiveBatch'

  def create
    incentive_batch = IncentiveBatch.find(params[:incentive_batch_id])
    if incentive_batch.send_rewards
      flash[:notice] = 'Tango orders are being created'
    else
      flash[:alert] = 'Not enough funds in the account to fulfill order'
    end

    redirect_to incentive_batches_url(incentive_batch)
  end
end
