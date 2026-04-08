
# Privacy Policy

The source code of the application is open and available in the repository
for review and analysis at "https://github.com/maxrys/rocketapp".


## Application structure

Launcher is a full application — it is not an extension
and does not require any other extensions.

The user decides which application will be added next to the grid:
- through the OS dialog window;
- by dragging the application icon into the Launcher window.


## Modifying the file system

Launcher does not interact with the file system — it does not
read or write any data.  


## Data storage

Launcher uses the standard `Swift Data` mechanism to store
the "list of added applications" in the local database.

This list is created at the user's request for Launcher to function and
contains the following information about each added application:
- the name of the application;
- the bundle ID of the application;
- the file system path to the application;
- the application icon.


## Other activities

Launcher:
- runs in an isolated OS environment (sandbox);
- does not register user clicks;
- does not have access to the clipboard;
- does not send or receive data over the network;
- does not collect or store personal data;
- does not transfer data to third parties.
