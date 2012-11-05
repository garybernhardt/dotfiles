import os

def get_imap_passwd():
  #cmd = "/Applications/MacPorts/CocoaDialog.app/Contents/MacOS/CocoaDialog secure-standard-inputbox --string-output --title 'OfflineIMAP: please input your password'"
  #return os.popen(cmd).readlines()[1][:-1]

  cmd = "/usr/bin/security 2>&1 >/dev/null find-generic-password -a gmail -g"
  line = os.popen(cmd).readline()
  passwds = line.split()
  if len(passwds) == 2:
    return passwds[1][1:-1]
  else:
    return ""
