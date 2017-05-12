#
# RouterOS Presence Detection for OpenHab2
# Joscha Arenz / 2017
#


:local scriptComment "ROS Presence Detection"


#
# Global Variables for DHCP-Lease Script
#
:global leaseBound
:global leaseServerName
:global leaseActMAC
:global leaseActIP


#
# Lookup Table Mac -> Openhab2 Item-Name (SwitchItem)
#
:local lookUpMACtoItem {"44:00:00:00:00:00"="Central_phone1_Presence";"2C:00:00:00:00:00"="Central_phone2_Presence"}
:local httpMode "https"
:local openhabAPIUrl "https://openhab/rest/items/"
:local httpUser "httpuser"
:local httpPassword "httppassword"

#
# Script
#
:log info ($scriptComment . " : " . $leaseBound . " " . $leaseServerName . " " . $leaseActMAC . " " . leaseActIP)

:if ($leaseBound = 1) do={
:if ([:len ($lookUpMACtoItem->$leaseActMAC)]>1) do {
    :log info ($scriptComment . " : " . $lookUpMACtoItem->$leaseActMAC . " went online.")
    :local url ($openhabAPIUrl . $lookUpMACtoItem->$leaseActMAC . "/state")
    /tool fetch mode=$httpMode http-method=put http-data="OPEN" user=$httpUser password=$httpPassword url=$url
}
} else={
:if ([:len ($lookUpMACtoItem->$leaseActMAC)]>1) do {
    :log info ($scriptComment . " : " . $lookUpMACtoItem->$leaseActMAC . " went offline.")
    :local url ($openhabAPIUrl . $lookUpMACtoItem->$leaseActMAC . "/state")
    /tool fetch mode=$httpMode http-method=put http-data="CLOSED" user=$httpUser password=$httpPassword url=$url
 }
}
