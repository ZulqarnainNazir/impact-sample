module ContactsHelper
  include LetterAvatar::AvatarHelper
  def related_companies_summary(companies)
    count = companies.count
    text = count > 1 ? "#{companies.first.name} + #{count - 1} More" : companies.first.name
    text.html_safe
  end

  def activity_time_tag(subject)
    time_tag(subject.created_at, title: subject.created_at.to_s(:rfc822), class: 'vertical-date text-muted') do
      "#{time_ago_in_words(subject.created_at)} ago"
    end
  end
end
