class EntriesController < ApplicationController
  before_action :set_entry, only: [:edit, :update, :destroy]
  before_action :set_blog, only: [:new, :create, :show]

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = Entry.joins(:blog).where(entries: {id: params[:id], blog_id: params[:blog_id]}).select('entries.id, entries.title, entries.body, entries.blog_id, blogs.title as blog_title').take!
    @comments = Comment.joins(entry: [:blog]).where(entries: {id: params[:id], blog_id: params[:blog_id]})
    @comment = Comment.new
  end

  # GET /entries/new
  def new
    @entry = Entry.new
  end

  # GET /entries/1/edit
  def edit
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entry.new(entry_params.merge({blog_id: params[:blog_id]}))

    respond_to do |format|
      if @entry.save
        format.html { redirect_to blog_path(@entry.blog_id), notice: 'Entry was successfully created.' }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entries/1
  # PATCH/PUT /entries/1.json
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to blog_path(@entry.blog_id), notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to blog_path(@entry.blog_id), notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    def set_blog
      @blog = Blog.find(params[:blog_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:title, :body)
    end
end
