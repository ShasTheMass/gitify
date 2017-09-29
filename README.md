# on2git
on2git.sh is a script that can convert your local folders into git based folders while preserving file creation and modification dates as git commits.

## Usage
- open terminal
- clone on2git repo by running 
	> `git clone https://github.com/ShasTheMass/on2git.git`
- cd into on2git folder
	> `cd on2git`
- run the on2git.sh file, passing the local folder location as the first argument and your github username as the second argument. Note: if you are on mac use `on2git_BSD.sh`, otherwise use `on2git.sh`, as follows:
	> For Mac 	: `./on2git_BSD.sh` [your local folder location] [your github username] 
	
	> For Linux : `./on2git.sh` [your local folder location] [your github username]


### Note
- If you came across access permission issues on the last step above, run the following command
	> `chmod u+x on2git.sh`
- Then repeat,
	> `./on2git.sh [`your local folder location`]` `[` your github username `]`

