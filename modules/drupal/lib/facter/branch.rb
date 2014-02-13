require 'facter'

Facter.add(:branch) do
  setcode "cat /etc/system_role"
end