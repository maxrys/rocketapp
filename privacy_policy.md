
# Privacy Policy

The source code of the application is open and available in the repository
for review and analysis at "https://github.com/maxrys/rocketapp".

Launcher is a full application — it is not an extension and does not require any other extensions.  
Launcher does not require any additional permissions.  
Launcher operates in an isolated OS environment (sandbox) and cannot affect anything.  
The user decides which application will be added next to the grid:
- through the OS dialog window;
- by dragging the application icon into the Launcher window.

Launcher does not interact with the file system — it does not read or write any data.  
Launcher uses the standard _Swift Data_ mechanism to store the "list of added applications" in the local file system.  
This list is created at the user's request for Launcher to function and contains the following information about each added application:
- the name of the application;
- the bundle ID of the application;
- the file system path to the application;
- the application icon.

Launcher:
- does not have access to the clipboard;
- does not send or receive data over external networks;
- does not collect or store any personal data;
- does not transmit any data to third parties.
