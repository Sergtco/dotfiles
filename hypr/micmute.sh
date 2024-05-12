wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
if [[ $(cat /var/tmp/mic_mute) -eq 0 ]]                                                                                                                                                                                                        
then                                                                                                                                                                                                                                           
  echo 1 > /var/tmp/mic_mute                                                                                                                                                                                                                   
else
  echo 0 > /var/tmp/mic_mute                                                                                                                                                                                                                   
fi
cat /var/tmp/mic_mute |  tee /sys/class/leds/platform::micmute/brightness
