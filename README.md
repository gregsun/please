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
    __<USAGE__      
    __USAGE>__      The usage between these two lines.
    __<IGNORE__
    __IGNORE>__     Anything between these two tags are kept intact, no MACROs will be replaced -
                    - so that please.pl will be managed by itself.
```
