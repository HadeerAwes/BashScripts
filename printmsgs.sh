## Function takes a message a parameter, and print it as an error
function printErrorMsg {
	MSG=${1}
	echo "ERROR: ${MSG}"
	return 0
}

function printMainMenu {
	echo "Main menu"
	echo -e "\t a) Authenticate"
	echo -e "\t 1) Add a customer"
	echo -e "\t 2) Update a customer email"
	echo -e "\t 3) Delete a customer"
	echo -e "\t 4) Query a customer email"
	echo -e "\t 5) Quit"
	echo -n "Please, select a option: "
}

function printDetails {
	DETAILS=${1}
	sed -n "/${DETAILS}/P" customers.db
	return 0 
}

function printConfirm {
	CONFIRM=${1}
	echo -n "Are you sure you want to delete ${CONFIRM} [y:n]: "
	return 0 
}


