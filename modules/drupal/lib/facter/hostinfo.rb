require 'facter'


Facter.add("alex_test") { setcode { '12345 lulz' } }
