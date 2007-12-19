# don't match associations
Rorem.add_matcher(%w(id type), :nothing)
Rorem.add_matcher(/_type$/, :nothing)
Rorem.add_matcher(/_id$/, :nothing)

# Match names
Rorem.add_matcher('name', :table => %w(users people contacts admins employees players)) do |rorem|
  @first_name ||= rorem.first_name
  @last_name ||= rorem.last_name
  [@first_name, @last_name].join(' ')
end

Rorem.add_matcher(%w(first_name firstname given_name givenname)) do |rorem|
  @first_name ||= rorem.first_name
end

Rorem.add_matcher(%w(last_name lastname family_name familyname sur_name surname)) do |rorem|
  @last_name ||= rorem.last_name
end

Rorem.add_matcher('email') do |rorem|
  tlds = %w(se com de org net co.uk co.jp)
  @domain ||= "#{rorem.word(6..12)}.#{tlds.random}"
  @first_name ||= rorem.first_name
  @last_name ||= rorem.last_name
  "#{@first_name.downcase}.#{@last_name.downcase}@#{@domain}"
end

Rorem.add_matcher( %w(birthdate date_of_birth dateofbirth) ) {|r| r.date 45.years.ago..18.years.ago }

Rorem.add_matcher('permalink') do |rorem|
  @title = rorem.title
  @title.downcase.gsub(/[a-z0-9]/, '-')
end

Rorem.add_matcher(/^computerized_/, :word )
Rorem.add_matcher(/^crypted_/, :digest)
Rorem.add_matcher('salt', :digest)