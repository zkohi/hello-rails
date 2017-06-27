class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy, :approve]
  before_action :set_entry, only: [:create]

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params.merge({status: 'unapproved', entry_id: @entry.id}))

    respond_to do |format|
      if @comment.save
        format.html { redirect_to blog_entry_path(@entry.blog_id, @entry), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @entry = Entry.joins(:blog, [:comments]).where(comments: {id: @comment[:id]}, entries: {id: @comment[:entry_id]}).take!
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to blog_entry_path(@entry.blog_id, @entry), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /comments/1/approve
  # PATCH/PUT /comments/1/approve.json
  def approve
    @entry = Entry.joins(:blog, [:comments]).where(comments: {id: @comment[:id]}, entries: {id: @comment[:entry_id]}).take!
    @comment.update({status: 'approved'})
    respond_to do |format|
      format.html { redirect_to blog_entry_path(@entry.blog_id, @entry), notice: 'Comment was successfully approved.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_entry
      @entry = Entry.joins(:blog).where(entries: {id: params[:entry_id], blog_id: params[:blog_id]}).take!
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:body)
    end
end
