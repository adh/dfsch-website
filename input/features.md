# Features

## Macros

As dfsch is member of Lisp-family of languages, it provides support
for macros. For example construct similar to prefix operator `++`
known from C-like languages can be defined by:

    (define-macro (incr x)
      `(set! ,x (1+ ,x)))

Macros can perform arbitrary computation when producing their
expansion and are not limited to simple templates. For example
[`define-class`](http://dfsch.org/snapshots/documentation/entries/define-class.html)
in standard library is actually implemented as relatively complex
macro written in dfsch itself whose expansion depends on some parts of
internal state of runtime system. Another good example of macros is `tk-gui:define-widgets` which implements domain specific language for description of GUI forms. Use of this macro is demonstrated in [examples/tk-gui-demo.scm](https://github.com/adh/dfsch/blob/master/examples/tk-gui-demo.scm), and it's implementation is large part of [lib-scm/tk-gui.scm](https://github.com/adh/dfsch/blob/master/lib-scm/tk-gui.scm). 

Most important part of macros is that syntactic construct like these
can be implemented by any program or library without requiring special
support in language or runtime.

## Object system

dfsch's powerful [object
system](http://dfsch.org/snapshots/documentation/chapters/Types-and-object-orientation.html)
simplifies many common tasks by reducing amounts of boiler plate code
in object oriented programs.

For example [dfsch's documentation
generator](https://github.com/adh/dfsch/blob/master/tools/docgen.scm)
defines generic method like this:

    (define-generic-function get-object-documentation
      :method-combination 
      (make-simple-method-combination (lambda (res)
                                        (apply nconc (reverse res)))))

Which then allows definition of handful of methods like this:

    (define-method (get-object-documentation (object <standard-function>) 
                                             &key supress-head &allow-other-keys)
      `(,(if supress-head 
             '(:strong "Arguments:")
             '(:h2 "Arguments"))
        (:pre ,(format "~a" (slot-ref object :orig_args)))))

or even specializing on abstract qualities of types instead of
inheritance hierarchy:

    (define-method (get-object-documentation (object <<documented>>) 
                                             &key supress-head  &allow-other-keys)
      (format-documentation-slot object :supress-head supress-head))

Results of all matching methods are then combined into one list (SXML
fragment) by method combination defined above, while method's
themselves do not contain any code to actually build this list.

## XML, S-XML and HTML5

[`sxml`](http://dfsch.org/snapshots/documentation/modules/sxml/)
module provides support for xml parsing and serialization with
S-expression based internal representation. For example:

    ]=> (xml:sxml-parse-string "<foo><bar attr=\"value\"/></foo>")
    ("foo" ("bar" (:attributes ("attr" "value"))))

and

    ]=> (xml:sxml-emit-string '(:network (:name "default")
          ..> (:forward :dev "eth0" :mode "nat")))
    "<network><name>default</name><forward mode=\"nat\" dev=\"eth0\" /></network>"

[`shtml`](http://dfsch.org/snapshots/documentation/modules/shtml/)
module provides support for serialization of similar internal
representation to HTML5 and is extensively used by above mentioned
[dfsch's documentation
generator](https://github.com/adh/dfsch/blob/master/tools/docgen.scm)
and this website. dfsch also contains implementation of
[Markdown](http://daringfireball.net/projects/markdown/) based on
[libupskirt](http://fossil.instinctive.eu/libupskirt/index) in
[`markdown`](http://dfsch.org/snapshots/documentation/modules/markdown/)
module.

## Networking

[`socket-port`](http://dfsch.org/snapshots/documentation/modules/socket-port/)
module provides access to networking with support for unix stream
sockets and TCP. Simple server can be implemented by:

    (require :socket-port)
    
    (define sock (tcp-bind "localhost" "1234"))
    
    (server-socket-run-accept-loop sock
                                   (lambda (port)
                                     (display "Hi there!\r\n" port)
                                     (socket-port-close! port)))

This program can then be accessed by TCP client like this:

    $ netcat localhost 1234
    Hi there!

[`http`](http://dfsch.org/snapshots/documentation/modules/http/) and
[`http-server`](http://dfsch.org/snapshots/documentation/modules/http-server/)
modules extend this functionality into simple implementation of
HTTP/1.1 server with interface usable for simple web
applications. Example can be found in [examples/http-server-demo.scm](https://github.com/adh/dfsch/blob/master/examples/http-server-demo.scm).

## Many more libraries

dfsch comes with many more modules, for example:

 * [INI file parsing and modification](http://dfsch.org/doc/0.4.0/modules/ini-file/)
 * [CSV parser](http://dfsch.org/doc/0.4.0/modules/csv/)
 * [Command line parser](http://dfsch.org/doc/0.4.0/modules/cmdopts/)
 * [JSON parser and serializer](http://dfsch.org/doc/0.4.0/modules/json/)
 * Interfaces to [common operating system functions](http://dfsch.org/doc/0.4.0/modules/os/) an to [many POSIX functions](http://dfsch.org/doc/0.4.0/modules/unix/)
 * [Base64, URL encoding, Query string parsing...](http://dfsch.org/doc/0.4.0/modules/inet/)
 * [Ciphers and hash functions](http://dfsch.org/doc/0.4.0/modules/crypto/)
 * [Gzip and deflate support](http://dfsch.org/doc/0.4.0/modules/zlib/)
 * [Reading of ZIP archives](http://dfsch.org/doc/0.4.0/modules/minizip/)
 * [Multithreading](http://dfsch.org/doc/0.4.0/modules/threads/)
 * [Subprocesses](http://dfsch.org/doc/0.4.0/modules/process/)

Also, dfsch includes interface to some external C libraries:

 * [`curl`](http://dfsch.org/doc/0.4.0/modules/curl/): [libcurl](http://curl.haxx.se/libcurl/) for URL access
 * [`ffi`](http://dfsch.org/doc/0.4.0/modules/ffi/): [libffi](http://sourceware.org/libffi/) base foreign function interface for direct calling of C code from dfsch
 * [`gd`](http://dfsch.org/doc/0.4.0/modules/gd/): [libgd](http://www.boutell.com/gd/) for bitmap graphics
 * [`pcre`](http://dfsch.org/doc/0.4.0/modules/pcre/): [Perl compatible regular expressions](http://www.pcre.org/)
 * [`tk-gui`](http://dfsch.org/doc/0.4.0/modules/tk-gui/): [Tk widget set](http://www.tcl.tk/) (with `tk-gui-interface` low-level interface to Tcl)
 * [`tokyo-cabinet`](http://dfsch.org/doc/0.4.0/modules/tokyo-cabinet/): [Tokyo Cabinet](http://fallabs.com/tokyocabinet/) 
 * [`tokyo-tyrant`](http://dfsch.org/doc/0.4.0/modules/tokyo-tyrant/): [Tokyo Cabinet](http://fallabs.com/tokyotyrant/) 
 * [`sqlite`](http://dfsch.org/doc/0.4.0/modules/sqlite/) and [`sqlite3`](http://dfsch.org/doc/0.4.0/modules/sqlite3/): Two commonly used versions of [SQLite database](http://sqlite.org/)

## Extensibility and embedability

Runtime system of dfsch is designed to make writing of additional extension modules simple. Simple extension module can be implemented by this code:

    #include <dfsch/dfsch.h>
    #include <dfsch/load.h>
    
    DFSCH_DEFINE_PRIMITIVE(hello_world,
                           "Greet the world or entity named by optional string "
                           "argument"){
      char* entity;
      DFSCH_STRING_ARG_OPT(args, entity, "world");
      DFSCH_ARG_END(args);
    
      printf("hello %s\n", entity);
      return NULL;
    }
    
    void dfsch_module_module_register(dfsch_object_t* env){
      dfsch_package_t* module = dfsch_make_package("module",
                                                   "Example module package");
      dfsch_provide(env, "module");
      dfsch_defcanon_pkgcstr(env, module, "hello-world", 
                             DFSCH_PRIMITIVE_REF(hello_world));
    }

Assuming it is stored in file named `module.c` and dfsch`s include
files and libraries can be found by compiler, it can then be compiled
by

    $ gcc -shared -fPIC -o module.dsl module.c -ldfsch

and used:

    $ dfsch-repl -L. -rmodule
      /\___/\    dfsch version 0.4.0-rc2
     ( o   o )
     ==  *  ==   dfsch is free software, and you are welcome to redistribute it
       )   (     under certain conditions; see file COPYING for details.
    
    ]=> (module:hello-world)
    hello world
    ()

It is interesting to note, that while dfsch will also accept extension
module with normal operating system's extension (eg `.so` or `.dll`),
it is preferred to use `.dsl`. Also dfsch will not search for modules
in current directory except when explicitly instructed to do so by
`-L.`