require 'facter'

Facter.add(:uri) do
  # Execute string as OS command to obtain the value of uri fact.
  setcode do
    Facter::Util::Resolution.exec("cat /etc/system_role")
  end
end