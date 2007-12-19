Rorem.add_matcher(%w(id type), :nothing)
Rorem.add_matcher(/_type$/, :nothing)
Rorem.add_matcher(/_id$/, :nothing)

Rorem.add_matcher('name', :name, :table => %w(users people contacts admins employees players))
Rorem.add_matcher(%w(first_name firstname given_name givenname), :first_name)
Rorem.add_matcher(%w(last_name lastname family_name familyname sur_name surname), :last_name)

Rorem.add_matcher('email') do |rorem|
  tlds = %w(se com de org net co.uk co.jp)
  rorem.first_name.downcase << '.' << rorem.last_name.downcase << '@' << rorem.word(6..12) << '.' << tlds.random
end

Rorem.add_matcher( %w(birthdate date_of_birth dateofbirth) ) {|r| r.date 45.years.ago..18.years.ago }

Rorem.add_matcher(/^computerized_/, :word )
Rorem.add_matcher(/^crypted_/, :digest)
Rorem.add_matcher(:salt, :digest)