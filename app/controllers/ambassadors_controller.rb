class AmbassadorsController < ApplicationController
  before_action :set_ambassador, only: [:show, :edit, :update, :destroy]

  # GET /ambassadors
  # GET /ambassadors.json
  def index
    @ambassadors = Ambassador.all
  end

  # GET /ambassadors/1
  # GET /ambassadors/1.json
  def show
  end

  # GET /ambassadors/new
  def new
    @ambassador = Ambassador.new
  end

  # GET /ambassadors/1/edit
  def edit
  end

  # POST /ambassadors
  # POST /ambassadors.json
  def create
    @ambassador = Ambassador.new(ambassador_params)

    respond_to do |format|
      if @ambassador.save
        format.html { redirect_to @ambassador, notice: 'Ambassador was successfully created.' }
        format.json { render :show, status: :created, location: @ambassador }
      else
        format.html { render :new }
        format.json { render json: @ambassador.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ambassadors/1
  # PATCH/PUT /ambassadors/1.json
  def update
    respond_to do |format|
      if @ambassador.update(ambassador_params)
        format.html { redirect_to @ambassador, notice: 'Ambassador was successfully updated.' }
        format.json { render :show, status: :ok, location: @ambassador }
      else
        format.html { render :edit }
        format.json { render json: @ambassador.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ambassadors/1
  # DELETE /ambassadors/1.json
  def destroy
    @ambassador.destroy
    respond_to do |format|
      format.html { redirect_to ambassadors_url, notice: 'Ambassador was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ambassador
      @ambassador = Ambassador.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ambassador_params
      params[:ambassador]
    end
end
