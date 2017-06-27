class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = Blog.all
    @commentsWhereEntryIdEq1 = Comment.select(:id, :body, :status, :entry_id).where(entry_id: 1)
    @entriesWhereCommentStatusIsUnapproved = Entry.select("entries.id, entries.title, entries.body").joins(:comments).where(comments: {status: "unapproved"} ).uniq
    @commentsWhereBlogIdEq1 = Comment.joins(entry: [:blog]).where(blogs: {id: 1}).select("comments.id, comments.body, comments.status, comments.entry_id")

    blogTable = Blog.arel_table
    groupTable = Entry.arel_table
    condition = groupTable[:blog_id].eq(blogTable[:id])
    @blogsWhereNotExistsEntry = Blog.where(Entry.where(condition).exists.not).all.select("blogs.id, blogs.title")

    @blogsWhereCommentsEqUnapproved = Blog.joins(entries: [:comments]).where(comments: {status: "unapproved"}).select("blogs.id, blogs.title").uniq
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @entries = Entry.where(blog_id: @blog.id)
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = Blog.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title)
    end
end
