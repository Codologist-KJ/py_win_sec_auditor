import subprocess

#Defines the programs main menu
def main_task_menu():
    print("[1] Windows Security Audit")
    print("[2] Task 2")
    print("[3] Task 3")
    print("[4] Task 4")
    print("[0] Exit program.")

#Windows Powershell Script location
ps_script = ".\\ps\\WinSecAudit_v2.ps1"

#Defines module for running the Powershell script
def run_pscript():
    cmd = ["PowerShell", "-File", ps_script, "-Verb", "RunAs"] 
    ec = subprocess.call(cmd)
    print("Powershell returned: {0:d}".format(ec))
    print("\nThe Windows security auditing process is complete...")
    

#Main menu for program      
main_task_menu()
main_option = int(input("Select your option: " ))

while main_option != 0:
    if main_option == 1:
        run_pscript()
           
    elif main_option == 2:
        print("Main Task 2 has been called.")

    elif main_option == 3:
        print("Main Task 3 has been called.")

    elif main_option == 4:
        print("Main Task 4 has been called.")

    else:
        #Message if a vaild option is not selected
        print("You have not selected a valid option.")

    print()
    main_task_menu()
    main_option = int(input("Select your option: " ))
 
exit()

#Read and Process PowerShell Transcript Files


#Return to Security Task Menu
