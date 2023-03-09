##Function takes a parameters. which is file name and return 0 if the file exists
function checkFile {
	FILENAME=${1}
	[ ! -f ${FILENAME} ] && return 1
	return 0
}
##Function takes a parameter which is filename and return 0 if the file has read perm
function checkFileR {
	FILENAME=${1}
	[ ! -r ${FILENAME} ] && return 1
	return 0
}
##Function takes a paremter which is filename and returns 0 if the file has write permission
function checkFileW {
	FILENAME=${1}
        [ ! -w ${FILENAME} ] && return 1
        return 0
}

## Function takes a parameter with username, and return 0 if the user requested is the same as current user
function checkUser {
	RUSER=${1}
	[ ${RUSER} == ${USER} ] && return 0
	return 1
}

### Function takes a username, and password then check them in accs.db, and returns 0 if match otherwise returns 1
function authUser {
	USERNAME=${1}
	USERPASS=${2}
	###1-Get the password hash from accs.db for this user if user found
	###2-Extract the salt key from the hash
	###3-Generate the hash for the userpass against the salt key
	###4-Compare hash calculated, and hash comes from the file.
	###5-IF match returns 0,otherwise returns 1
	USERLINE=$(grep ":${USERNAME}:" accs.db)
	[ -z ${USERLINE} ] && return 0
	PASSHASH=$(echo ${USERLINE} | awk ' BEGIN { FS=":" } { print $3} ')
	SALTKEY=$(echo ${PASSHASH} | awk ' BEGIN { FS="$" } { print $3 } ')
	NEWHASH=$(openssl passwd -salt ${SALTKEY} -6 ${USERPASS})
	if [ "${PASSHASH}" == "${NEWHASH}" ]
	then
		USERID=$(echo ${USERLINE} | awk ' BEGIN { FS=":" } { print $1} ')
		return ${USERID}
	else
		return 0
	fi
}

function checkId {
	CUSTOMERID=${1}
	IDCHECK=$(echo ${CUSTID} | grep -cw "[0-9]*")
	[ ${IDCHECK} -eq 0 ] && return 0
	return 1
}

function checkname {
	CUSTOMERNAME=${1}
	NAMECHECK=$(echo "${CUSTOMERNAME}" | grep -cw "^[a-z]*\-\?\_\?[a-z]*$")
        [ ${NAMECHECK} -eq 0 ] && return 0 
	return 1	
}

function checkEmail {
	CUSTOMEREMAIL=${1}
	EMAILCHECK="^[a-zA-Z0-9.]+\@[a-zA-Z]+\.[a-z]{2,4}$"
	if [[ ${CUSTOMEREMAIL} =~ ${EMAILCHECK} ]]
	then
        	return 1
	else
        	return 0
	fi

}

function checkIdExist {
	CUSTOMID=${1}
	while read LINE
	do
		CHECKIDEXIST=$( echo ${LINE} | awk ' BEGIN { FS=":" } { print $1 } ' | grep -c  "^${CUSTOMID}$" )
		if [ ${CHECKIDEXIST} -ne 0 ]
		then 
			return 1 
		fi
	done < customers.db
}

function checkEmailExist {
	CUSTOMEMAIL=${1}
        while read LINE
        do
        CHECKEMAILEXIST=$( echo ${LINE} | awk ' BEGIN { FS=":" } { print $3 } ' | grep -c "^${CUSTOMEMAIL}$" )
        if [ ${CHECKEMAILEXIST} -ne 0 ]
        then
                return 1
        fi
        done < customers.db

}

function checkConfirm {
	YORN=${1}
	case "${YORN}" in
		"y")
			return 1
			;;
		"*")
			return 0
			;;
	esac
	
}
