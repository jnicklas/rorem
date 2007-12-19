Rorem::Filler.match(%w(id type), :nothing)
Rorem::Filler.match(/_type$/, :nothing)
Rorem::Filler.match(/_id$/, :nothing)

Rorem::Filler.match('name', :name, :table => %w(users people contacts admins employees players))
Rorem::Filler.match(%w(first_name firstname given_name givenname), :first_name)
Rorem::Filler.match(%w(last_name lastname family_name familyname sur_name surname), :last_name)

Rorem::Filler.match('email') do |rorem|
  tlds = %w(se com de org net co.uk co.jp)
  rorem.first_name.downcase << '.' << rorem.last_name.downcase << '@' << rorem.word(6..12) << '.' << tlds.random
end

Rorem::Filler.match( %w(birthdate date_of_birth dateofbirth) ) {|r| r.date 45.years.ago..18.years.ago }

Rorem::Filler.match(/^computerized_/, :word )
Rorem::Filler.match(/^crypted_/, :digest)
Rorem::Filler.match(:salt, :digest)