#Znajdź w pliku access_log zapytania, które mają frazę "denied" w linku
cat access_log | grep "/denied" | cut -d" " -f6,7,8

#Znajdź w pliku access_log zapytania typu POST
cat access_log | grep "\"POST" | cut -d" " -f6,7,8

#Znajdź w pliku access_log zapytania wysłane z IP: 64.242.88.10
cat access_log | grep "64\.242\.88\.10 \- \- \[" | cut -d" " -f6,7,8

#Znajdź w pliku access_log wszystkie zapytania NIEWYSŁANE z adresu IP tylko z FQDN
cat access_log | grep -vE "^\b([0-9]{1,3}.){3}[0-9]{1,3}\b" | -f6,7,8

#Znajdź w pliku access_log unikalne zapytania typu DELETE
cat access_log | grep "\"DELETE" | cut -d" " -f6,7,8 | uniq

#Znajdź unikalnych 10 adresów IP w access_log
cat access_log | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | uniq | sed '10q'
