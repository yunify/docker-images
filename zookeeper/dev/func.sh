function waitport () {
	while ! nc -z $1 $2; do   
  		sleep 0.1
	done
}
