This is a deployment utility for SQL Server Integration Service packages (.DTSX).  It is currently only built for pushing to MSDB as opposed to going to a filesystem.

There is error handling built in, but this is the first iteration of this utility and I intend to add additional functionality.

Version 1.0
- Verifies that the source folder contains .DTSX files
- Verifies that the destination folder exists
- Prompts to create folders is that does not already exist
- Verifies that the server name inputted responds
- For every .DTSX file in the source folder, the utility will push to MSDB on the destination server
- If any of the files fail, the program will halt and report the error, then exit
- Each file and location destination is provided as output