class PopulateInvite

  def self.run(contact, user, company)
    puts "Populating Invite..."

    invite = Invite.create!(
      invitee: contact,
      inviter: user,
      company: company,
      message: "You've been invited!"
    )
  end
end
