# lib/delayed_rake.rb
class DelayedRake < Struct.new(:task, :options)
  def perform
    env_options = ''
    options && options.stringify_keys!.each do |key, value|
      env_options << " #{key.upcase}=#{value}"
    end
    system("cd #{Rails.root} && RAILS_ENV=#{Rails.env} bundle exec rake #{task} #{env_options}")
  end
end