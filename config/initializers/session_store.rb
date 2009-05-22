# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_test-app_session',
  :secret      => 'a6d97057a5241ac35c506452b0bcb5381ea78c76e8c83af8c2cea020199f7cf179186fe7e1e1e7cf90108e0390a910cb31172aab3ddb24feb26ebee6e3572c39'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
