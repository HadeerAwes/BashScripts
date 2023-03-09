## Function, takes customer name, and prints out the id, name, and email. Returns 0 if found, otherwise return 1
function queryCustomer {
	local CUSTNAME=${1}
	LINE=$(grep "^${CUSTNAME}$" customers.db)
	[ -z ${LINE} ] && printErrorMsg "Sorry, ${CUSTNAME} is not found" && return 7
	echo "Information for the customer"
	echo -e "\t ${LINE}"
	return 0
}

