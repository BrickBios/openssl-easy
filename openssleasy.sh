#!/bin/sh
clear
password=""
echo
echo "  Open SSL Facile                                   "
echo "  --------------------------------------------------"
echo "                                                    "
echo "  Installazione e Configurazione Automatica         "
echo "  OpenSSL                                           "
echo "  Chiave compatibile con Telegram                   "
echo "                                                    "
echo "  --------------------------------------------------"
echo "  Seguire i passaggi                                "
echo "  Inserisci Password Amministratore                 "
echo
read  password
echo  $password | sudo -S apt-get install openssl
echo  $password | sudo -S apt-get install zenity
echo  $password | sudo -S apt-get install apache2
echo  $password | sudo -S a2enmod ssl
echo  $password | sudo -S service apache2 restart
echo  $password | sudo -S mkdir /etc/apache2/ssl
cd /etc/apache2/sites-available/
echo  $password | sudo -S mv default-ssl.conf default-ssl.conf.old


dominio=`zenity --entry \
--title="Inserisci tuo dominio" \
--text="Inserisci Nome dominio:" \
--entry-text "prova.com"`


echo  $password | sudo -S openssl req -newkey rsa:2048 -sha256 -nodes -keyout /etc/apache2/ssl/PRIVATA.key -x509 -days 365 -out /etc/apache2/ssl/PUBBLICA.pem -subj "/C=IT/ST=Italia/L=location/O=description/CN=$dominio"

echo  $password | sudo -S chmod 777 /etc/apache2/ssl/PUBBLICA.pem
echo  $password | sudo -S echo "<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        SSLEngine on
        SSLCertificateFile /etc/apache2/ssl/PUBBLICA.pem
        SSLCertificateKeyFile /etc/apache2/ssl/PRIVATA.key
        <FilesMatch '\.(cgi|shtml|phtml|php)$'>
                        SSLOptions +StdEnvVars
        </FilesMatch>
        <Directory /usr/lib/cgi-bin>
                        SSLOptions +StdEnvVars
        </Directory>
        BrowserMatch 'MSIE [2-6]' \
                        nokeepalive ssl-unclean-shutdown \
                        downgrade-1.0 force-response-1.0
        BrowserMatch 'MSIE [17-9]' ssl-unclean-shutdown
    </VirtualHost>
</IfModule>" >> /tmp/default-ssl555
echo  $password | sudo -S mv /tmp/default-ssl555 /etc/apache2/sites-available/default-ssl.conf 

echo  $password | sudo -S a2ensite default-ssl.conf
echo  $password | sudo -S service apache2 restart

firefox "https://localhost"
