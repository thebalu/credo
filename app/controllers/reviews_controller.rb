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

  # params: schedule_id, grade
  def answer_card
    render json: {error:"Please provide schedule_id and grade."}, status: :unprocessable_entity and return unless params[:schedule_id] && params[:grade]
    @schedule = Schedule.find_by_id(params[:schedule_id])
    grade = params[:grade].to_i
    if @schedule
      if 1<=grade && grade<=@schedule.number_of_buttons
        if @schedule.answer_card(grade)
          render json: @schedule.as_json
        else
          render json: {error:"Unknown error when saving schedule."}, status: :unprocessable_entity
        end
      else
        render json: {error:"Grade must be between 1 and #{@schedule.number_of_buttons}."}, status: :not_found
      end
    else
      render json: {error:"Couldn't find Schedule."}, status: :not_found
    end
  end

  private

  def set_konfig
    @konfig = Konfig.find_by(deck_id: params[:deck_id], student_id: params[:student_id])
  end

end
