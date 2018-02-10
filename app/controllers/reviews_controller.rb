class ReviewsController < ApplicationController

  before_action :set_konfig, only: [:get_card]
  skip_before_action :verify_authenticity_token
  # params: student_id, deck_id
  # returns: card { front, back, schedule}
  def get_card
    if @konfig
    @schedule = @konfig.get_card
      render json: @schedule.as_json
    else
      render json: {error:"Couldn't find Konfig with the provided student_id and deck_id."}, status: :not_found
    end

  end



  private

  def set_konfig
    @konfig = Konfig.find_by(deck_id: params[:deck_id], student_id: params[:student_id])
  end

end
