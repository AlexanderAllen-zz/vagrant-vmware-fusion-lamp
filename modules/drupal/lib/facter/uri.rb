require 'facter'

Facter.add(:uri) do
  # Execute string as OS command to obtain the value of uri fact.
  setcode "whoami"
end