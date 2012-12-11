$: << File.join('..','..','lib')

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Dummy::Application.initialize!

# Bring in the gem classes.
require 'zormk'
