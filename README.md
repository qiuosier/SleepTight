# SleepTight
A background process for macOS to run program at sleep and wake up. The SleepTight project includes a modified/customized version of SleepWatcher 2.2.1, originally developed by Bernhard Baehr.

SleepWatcher is a command line daemon tool to execute commands when the Mac sleeps or wakes up. See https://www.bernhard-baehr.de/ for more information about the original SleepWatcher.

SleepWatcher 2.2.1 runs on Mac OS X 10.5 and above. This modification, i.e. SleepTight, is tested on macOS Mojave 10.14.4.

The macOS comes with [launchd](https://en.wikipedia.org/wiki/Launchd) to manage daemon services. The lanuchd is used to run SleepWatcher. Running SleepWatcher as a per-user process (user agent) does not require root permission. SleepTight includes a modified makefile to install SleepWatcher as a user agent. launchd uses a `.plist` configuration file for each process. For user agent, the `.plist` file should be stored in `~\Library\LaunchAgents`.

For introduction and usage of launchd, see https://www.launchd.info/.

See more details about launchd on Apple Documentation Archive: 
* [Creating Launch Daemons and Agents](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html#//apple_ref/doc/uid/10000172i-SW7-BCIEDDBJ)
* [Technical Notes TN2083: Daemons and agents](https://developer.apple.com/library/archive/technotes/tn2083/_index.html)

## Customize the `.plist` file.
The `de.bernhard-baehr.sleepwatcher.plist` configures the options for running sleepwatcher. Options are stored as an array under the key `ProgramArguments`. The default configuration contains the following options:
```
<array>
    <string>/usr/local/sbin/sleepwatcher</string>
    <string>-V</string>
    <string>-s ~/.sleep</string>
    <string>-w ~/.wakeup</string>
</array>
```
There are 4 items in the above array:
1. The sleepwatcher binary location.
2. `-V`, log any action sleepwatcher performs.
3. `-s ~/.sleep`, execute `~/.sleep` file when the system is going into sleep.
4. `-w ~/.wakeup`, execute `~/.wakeup` file when the system is going into sleep.

You should either save the files (e.g. shell scripts) you would like to be executed as the `~/.sleep` and `~/.wakeup`, or change them to the paths of you executable files. The `make install` command does not create these files. You can also add more options by adding another `<string>...</string>` to the array.

See the [SleepWatcher Manual](sleepwatcher_manual.html) for all the available options.

By default, the logs are sent to syslog. For debug or logging purpose, you can add the following into the `<dict>` part so that the standard outputs and errors are saved into the file you specified (`/path/to/log/file.log`).
```
<key>StandardErrorPath</key>
<string>/path/to/log/file.log</string>
<key>StandardOutPath</key>
<string>/path/to/log/file.log</string>
```

## Build and Install on macOS Mojave
Use the following commands to create a symlink for libgcc_s:
```
$ cd /usr/local/lib
$ sudo ln -s ../../lib/libSystem.B.dylib libgcc_s.10.4.dylib
```

In the source code folder, build the binary for 64-bit system:
```
$ make sleepwatcher64
```

Install the binary and manual for the user:
```
$ make install
```
The above command will:
* Install the sleepwatcher binary to `/usr/local/sbin`.
* Install the sleepwatcher manual to `/usr/local/share/man`.
* Install the `de.bernhard-baehr.sleepwatcher.plist` to `~\Library\LaunchAgents`.

You can also set the path to your customized `.plist` file by:
```
$ make install PLIST=path/to/your.plist
```

Remove the binary from source code folder:
```
$ make clean
```

## Known Issue
launchd ouputs "This service is defined to be constantly running and is inherently inefficient." when the process starts.

2019 Qiu Qin.
