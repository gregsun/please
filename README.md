# please
Perl release and management tool
This tool is to replace a predefined MACROs in text file (release note or source file) with dynamic contents. The following MACROS are supported:
```
    __TIMESTAMP__   time stamp, example Wed Jun 17 18:07:02 2020
    __FILE__        File name
    __SOURCE__      Full path name
    __EXE__         Compiled file name
    __HOST__        Machine name where this tool runs
    __VER__         Git version (local)
    __<GITLOG__     for begining of the local git log
    __GITLOG>__     the git log will be in between these two tags
    __<USAGE__      Get the usage from source file to readme file. This part shares with source
    __USAGE>__      The usage between these two lines.
    __<IGNORE__
    __IGNORE>__     Anything between these two tags are kept intact, no MACROs will be replaced -
                    - so that please.pl will be managed by itself.
```
Example of please.readme
```
Release Notes of please v1.__VER__
__TIMESTAMP__
Built on machine __HOST__ __EXE__ from __SOURCE__
Usage:
__<USAGE__
__USAGE>__

----------List of Changes-----------------
__<GITLOG__
__GITLOG>__
```

Result:
```
Release Notes of please v1.4
Wed Jun 17 18:07:02 2020
Built on machine greg-T408S src/please from src/please.pl
Usage:
src/please is for perl release management
	src/please -i <file>.pl
	It will compile <file>.pl to <file> and update <file>.readme to <file>.readme.txt as release notes.

##Built on greg-T408S from src/please.pl Wed Jun 17 18:07:02 2020 git version v1.4

----------List of Changes-----------------
#Log 2020-06-17 17:58:06 -0700 : add tag for IGNORE so that this file itself can be released
#Log 2020-06-17 13:49:19 -0700 : add new tags and style with __<TAG__ to __TAG>__ for pairs
#Log 2020-06-17 11:16:23 -0700 : add tag __EXE__ and __SOURCE__
#Log 2020-06-16 21:51:30 -0700 : create release management with macros
```
