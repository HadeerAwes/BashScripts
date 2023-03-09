#!/bin/bash
### Script that handles customer info in file customers.db
#BASH script manages user data
#	Data files:
#		customers.db:
#			id:name:email
#		accs.db:
#			id,username,pass
#	Operations:
#		Add a customer
#		Delete a customer
#		Update a customer email
#		Query a customer
#	Notes:
#		Add,Delete, update need authentication
#		Query can be anonymous
#	Must be root to access the script
###################### TODO
#################################
### Exit codes:
##	0: Success
##	1: No customers.db file exists
##	2: No accs.db file exists
##	3: no read perm on customers.db
##	4: no read perm on accs.db
##	5: must be root to run the script
##	6: Can not write to customers.db
##	7: Customer name is not found
source ./checker.sh
source ./printmsgs.sh
source ./dbops.sh
checkFile "customers.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not find customers.db" &&  exit 1
checkFile "accs.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not find accs.db" &&  exit 2
checkFileR "customers.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not read from customers.db" &&  exit 3
checkFileR "accs.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not read from accs.db" &&  exit 4
checkFileW "customers.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not write to customers.db" &&  exit 6
checkUser "root"
[ ${?} -ne 0 ] && printErrorMsg "You are not root, change to root and come back" && exit 5
CONT=1
USERID=0
while [ ${CONT} -eq 1 ]
do
	printMainMenu
	read OP
	case "${OP}" in
		"a")
			echo "Authentication:"
			echo "---------------"
			echo -n "Username: "
			read ADMUSER
			echo -n "Password: "
			read -s ADMPASS
			authUser ${ADMUSER} ${ADMPASS}
			USERID=${?}
			if [ ${USERID} -eq 0 ] 
				then
					echo "Invalid username/password combination"
				else
					echo "Welcome to the system"
			fi

			;;
		"1")
			if [ ${USERID} -eq 0 ]
			then
				printErrorMsg "You are not authenticated, please authenticate 1st"
			else
				### TODO
					# check for id is valid integer
					# check for customer name is only alphabet,-_
					# check for email format
					# Check for userid exist or not
					# Check for email exist or not

				echo "Adding a new customer"
				echo "---------------------"
				echo -n "Enter customer ID : "
				read CUSTID
				checkId ${CUSTID}
				if [ ${?} -eq 0 ] 
				then
					printErrorMsg "It is not an integer"
				else
					checkIdExist ${CUSTID}
					if [ ${?} -eq 1 ]
					then
						printErrorMsg "Invalid id already exist"
					else 
						echo -n "Enter customer name : "
						read CUSTNAME
						checkname ${CUSTNAME}
						if [ ${?} -eq 0 ]
		                                then
        		                                printErrorMsg "The name must be alphabetical and can contains - or _"
						else 
							echo -n "Enter customer email : "
							read CUSTEMAIL
							checkEmail ${CUSTEMAIL}
							if [ ${?} -eq 0 ]
							then
								printErrorMsg "Invalid email format"
							else
								checkEmailExist ${CUSTEMAIL}
			                                        if [ ${?} -eq 1 ]
                        			                then
                                                			printErrorMsg "Invalid Email already exist"


								else
									echo "${CUSTID}:${CUSTNAME}:${CUSTEMAIL}" >> customers.db
									echo "customer ${CUSTID} saved.."
								fi
							fi
						fi
					fi
				fi

			fi
			;;
		"2")
			if [ ${USERID} -eq 0 ]
                        then
                                printErrorMsg "You are not authenticated, please authenticate 1st"
			else
				echo "Updating an existing email"	
				#TODO
				#	Read required id to update
				#	check for valid integer
				#	check for id exists
				#	print details
				#	ask for confirmation
				# yes, 
					# ask for new email
					# check email is valid
					# check email exists
					# confirm
					# yes: update the email in the file
					echo -n "Enter ID : "
                                        read  UPDATEID
                                        checkId ${UPDATEID}
                                        if [ ${?} -eq 0 ]
                                        then
                                                printErrorMsg "It is not an integer"
                                        else
                                                checkIdExist ${UPDATEID}
                                                if [ ${?} -ne 1 ]
                                                then
                                                        printErrorMsg "Invalid id not exist"
                                                else
                                                        printDetails "${UPDATEID}"
							echo -n "Are you sure you want to update ${UPDATEID} [y:n]: "
                                                        read CHECKUPDATE
                                                        checkConfirm "${CHECKUPDATE}"
                                                        if [ ${?} -eq 1 ]
                                                        then
								echo -n "Enter customer email : "
                                                        	read NEWCUSTEMAIL
                                                        	checkEmail ${NEWCUSTEMAIL}
                                                        	if [ ${?} -eq 0 ]
                                                        	then
                                                                	printErrorMsg "Invalid email format"
                                                        	else
                                                                	checkEmailExist ${NEWCUSTEMAIL}
                                                                	if [ ${?} -eq 1 ]
                                                                	then
                                                                        	printErrorMsg "Invalid Email already exist"


                                                                	else
                                                                        	OLD=$(grep -w ${UPDATEID} customers.db | awk 'BEGIN { FS = ":" }{ print $3 }')

										sed -i "s/${OLD}/${NEWCUSTEMAIL}/g" customers.db
                                                                        	echo "customer ${UPDATETID} updated.."
                                                                	fi
								fi
							fi
						fi
					fi

                        fi

			;;
		"3")
			if [ ${USERID} -eq 0 ]
                        then
                                printErrorMsg "You are not authenticated, please authenticate 1st"
			else
				echo "Deleting existing user"
				##ToOD
				#	Read required ID to delete
					# check for valid integer
					# check id exists
					# Print details
					# ask for confirmation
					# yes: Delete permanently
					echo -n "Enter ID : "
                                	read  DELID
					checkId ${DELID}
                                	if [ ${?} -eq 0 ]
                                	then
                                        	printErrorMsg "It is not an integer"
					else
						checkIdExist ${DELID}
                                        	if [ ${?} -ne 1 ]
                                        	then
                                                	printErrorMsg "Invalid id not exist"
						else
							printDetails "${DELID}"
							echo -n "Are you sure you want to delete ${DELID} [y:n]: "
							read ${CHECK}
							checkConfirm "${CHECK}"
							if [ ${?} -eq 1 ]
							then
								sed -i "/${DELID}/d" customers.db
								echo "One record deleted"
							fi


						fi
					fi


                        fi
			;;
		"4")
			echo -n "Enter name : "
			read CUSTNAME
			queryCustomer ${CUSTNAME}
			;;
		"5")
			echo "Thank you, see you later Bye"
			CONT=0
			;;
		*)
			echo "Invalid option, try again"
	esac
done



exit 0



