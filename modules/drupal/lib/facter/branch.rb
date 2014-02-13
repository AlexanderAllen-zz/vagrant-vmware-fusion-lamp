require 'facter'

Facter.add(:branch) do
  setcode do
    Facter::Util::Resolution.exec("cat /etc/system_role")
  end
end