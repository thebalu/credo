class KonfigsController < ApplicationController
  before_action :set_konfig, only: [:show, :edit, :update, :destroy]

  # GET /konfigs
  # GET /konfigs.json
  def index
    @konfigs = Konfig.all
  end

  # GET /konfigs/1
  # GET /konfigs/1.json
  def show
  end

  # GET /konfigs/new
  def new
    @konfig = Konfig.new
  end

  # GET /konfigs/1/edit
  def edit
  end

  # POST /konfigs
  # POST /konfigs.json
  def create
    @konfig = Konfig.new(konfig_params)

    respond_to do |format|
      if @konfig.save
        format.html { redirect_to @konfig, notice: 'Konfig was successfully created.' }
        format.json { render :show, status: :created, location: @konfig }
      else
        format.html { render :new }
        format.json { render json: @konfig.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /konfigs/1
  # PATCH/PUT /konfigs/1.json
  def update
    respond_to do |format|
      if @konfig.update(konfig_params)
        format.html { redirect_to @konfig, notice: 'Konfig was successfully updated.' }
        format.json { render :show, status: :ok, location: @konfig }
      else
        format.html { render :edit }
        format.json { render json: @konfig.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /konfigs/1
  # DELETE /konfigs/1.json
  def destroy
    @konfig.destroy
    respond_to do |format|
      format.html { redirect_to konfigs_url, notice: 'Konfig was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_konfig
      @konfig = Konfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def konfig_params
      params.require(:konfig).permit(:deck_id,:student_id,:grad_steps, :starting_step, :lapse_starting_step, :new_limit)
    end
end
