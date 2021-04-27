# systemy-operacyjne2-lab

## Lab1

It's a simple bash script that takes 3 arguments: `SOURCE_DIR`, `RM_LIST`, `TARGET_DIR` with default values: `lab_uno`, `lab_uno/2remove`, `bakap`.
If `TARGET_DIR` does not exist, it is created. 
It iterates over the contents of the `RM_LIST` file and only if the file with that name appears in the `SOURCE_DIR` directory, it deletes it.
If a file is not in the list but is a regular file, it moves it to `TARGET_DIR`. 
If a file is not on the list, but is a directory, it copies it to TARGET_DIR with the contents.
If there are any files in the `SOURCE_DIR` directory left after the operation is completed then:
- it writes, for example, "There is something more." on the console and
- if at least 2 files, it prints: "There are at least 2 files more.",
- if more than 4, it prints: "There are more than 4 files." (4 is also more than 2),
- if not more than 4, but at least 2, it prints "There are at least 2 files more but less than 4 files.",
- If there is nothing left, it writes "Kononowicz was there.".

It revokes write permissions from all files in the `TARGET_DIR` directory.
Finally, it packs the `TARGET_DIR` directory and name it `bakap_DATE.zip`, where `DATE` is the day the script was run in the format `YYYY-MM-DD`.
