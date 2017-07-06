class BlogEntryCommentMailer < ApplicationMailer
  def post_comment_email(entry, comment)
    @entry = entry
    @comment = comment
    to = 'kohiandrew@gmail.com'
    subject = '新しいコメントが登録されました。'
    mail(to: to, subject: subject)
  end
end
