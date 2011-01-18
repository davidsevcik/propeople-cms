class MultilingualMailer < ActionMailer::Base
  def translator_notification(page, language)
    @recipients = YAML::load(Radiant::Config['multilingual.translator_emails'])[language.to_s]
    @from = 'robot@alcaplast.cz'
    @subject = "Nová stránka k překladu"
    @body = {:page => page, :language => language}
  end
end
