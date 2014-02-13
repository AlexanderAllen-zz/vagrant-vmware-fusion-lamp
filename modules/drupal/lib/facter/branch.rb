require 'facter'


Facter.add("uri") { 
  setcode { '12345 lulz' } 
}
