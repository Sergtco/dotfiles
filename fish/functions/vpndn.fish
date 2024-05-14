function vpndn --wraps='nmcli connection down vpn' --description 'alias vpndn nmcli connection down vpn'
  nmcli connection down vpn $argv
        
end
