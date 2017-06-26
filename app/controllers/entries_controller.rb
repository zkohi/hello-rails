class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :edit, :update, :destroy]
  before_action :set_blog, only: [:new, :create]

  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.all
    @commentsWhereEntryIdEq1 = Comment.select(:id, :body, :status, :entry_id).where(entry_id: 1)
    @entriesWhereCommentStatusIsUnapproved = Entry.select("entries.id, entries.title, entries.body").joins(:comments).where(comments: {status: "unapproved"} ).uniq
    @commentsWhereBlogIdEq1 = Comment.joins(entry: [:blog]).where(blogs: {id: 1}).select("comments.id, comments.body, comments.status, comments.entry_id")

    blogTable = Blog.arel_table
    groupTable = Entry.arel_table
    condition = groupTable[:blog_id].eq(blogTable[:id])
    @blogsWhereNotExistsEntry = Blog.where(Entry.where(condition).exists.not).all.select("blogs.id, blogs.title")

    @blogsWhereCommentsEqUnapproved = Blog.joins(entries: [:comments]).where(comments: {status: "unapproved"}).select("blogs.id, blogs.title").uniq
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
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
    @entry = Entry.new(entry_params.merge(params.permit(:blog_id).to_h))

    respond_to do |format|
      if @entry.save
        format.html { redirect_to blog_entries_path(@entry.blog_id), notice: 'Entry was successfully created.' }
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
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
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
      format.html { redirect_to entries_url, notice: 'Entry was successfully destroyed.' }
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
