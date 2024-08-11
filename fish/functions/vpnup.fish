function vpnup --wraps='nmcli connection up vpn' --description 'alias vpnup nmcli connection up vpn'
  nmcli connection up vpn $argv
        
end
