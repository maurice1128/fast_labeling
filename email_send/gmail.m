
classdef gmail
    properties

    end
    
    methods (Static)


        function send_mail_from_maurice_nycu (reciever ,title, content)

setpref('Internet' ,'SMTP_Server', 'smtp.gmail.com')
setpref('Internet','E_mail', 'maurice.y@nycu.edu.tw')
setpref('Internet','SMTP_Username', 'maurice.y@nycu.edu.tw')
setpref('Internet','SMTP_Password', 'j;6aj4cj86')


props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.starttls.enable','true');

sendmail(reciever, title, content)

        end
    end
end


