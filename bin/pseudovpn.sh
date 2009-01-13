KEEPALIVE="while true; do echo 'foo'; sleep 5; done"

while true; do
    ssh hq.bitbacker.com -L8080:localhost:80 $KEEPALIVE
    sleep 1
done
